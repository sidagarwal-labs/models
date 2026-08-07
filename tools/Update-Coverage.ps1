[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$readmePath = Join-Path $repositoryRoot 'README.md'
$gitDirectory = Join-Path $repositoryRoot '.git'
$recentStartMarker = '<!-- recent-updates:start -->'
$recentEndMarker = '<!-- recent-updates:end -->'
$startMarker = '<!-- coverage:start -->'
$endMarker = '<!-- coverage:end -->'
$recentUpdateCount = 10

function ConvertTo-RepositoryPath {
    param([Parameter(Mandatory = $true)][string]$FullName)

    return $FullName.Substring($repositoryRoot.Length + 1).Replace('\', '/')
}

function ConvertTo-MarkdownTarget {
    param([Parameter(Mandatory = $true)][string]$RepositoryPath)

    return @(
        $RepositoryPath.Split('/') | ForEach-Object {
            [System.Uri]::EscapeDataString($_)
        }
    ) -join '/'
}

function Get-Quarter {
    param([Parameter(Mandatory = $true)][string]$Value)

    $trimmedValue = $Value.Trim()
    $prefix = if ($trimmedValue -match '^(?i)FQ') { 'FQ' } else { 'Q' }
    $quarter = $null
    $year = $null

    if ($trimmedValue -match "^(?i)F?Q(?<quarter>[1-4])[\s'/-]?(?:20)?(?<year>\d{2})[AE]?$" ) {
        $quarter = [int]$Matches.quarter
        $shortYear = [int]$Matches.year
        $year = if ($shortYear -ge 70) { 1900 + $shortYear } else { 2000 + $shortYear }
    }
    elseif ($trimmedValue -match "^(?i)(?:20)?(?<year>\d{2})[\s'/-]?Q(?<quarter>[1-4])[AE]?$" ) {
        $quarter = [int]$Matches.quarter
        $shortYear = [int]$Matches.year
        $year = if ($shortYear -ge 70) { 1900 + $shortYear } else { 2000 + $shortYear }
    }
    elseif ($trimmedValue -match "^(?i)(?<quarter>[1-4])Q(?:20)?(?<year>\d{2})[AE]?$" ) {
        $quarter = [int]$Matches.quarter
        $shortYear = [int]$Matches.year
        $year = if ($shortYear -ge 70) { 1900 + $shortYear } else { 2000 + $shortYear }
    }

    if ($null -eq $quarter) {
        return $null
    }

    return [pscustomobject]@{
        Display = "$prefix$quarter $year"
        SortKey = ($year * 10) + $quarter
        IsEstimate = $trimmedValue -match '(?i)E$'
    }
}

function Read-ArchiveEntry {
    param([Parameter(Mandatory = $true)]$Entry)

    $reader = New-Object System.IO.StreamReader($Entry.Open())
    try {
        return $reader.ReadToEnd()
    }
    finally {
        $reader.Dispose()
    }
}

function Get-ColumnNumber {
    param([Parameter(Mandatory = $true)][string]$CellReference)

    $columnNumber = 0
    foreach ($character in [regex]::Match($CellReference, '^[A-Z]+').Value.ToCharArray()) {
        $columnNumber = ($columnNumber * 26) + ([int]$character - [int][char]'A' + 1)
    }

    return $columnNumber
}

function Get-YellowStyles {
    param([Parameter(Mandatory = $true)][xml]$StylesXml)

    $yellowStyles = @{}
    $fills = @($StylesXml.SelectNodes("/*[local-name()='styleSheet']/*[local-name()='fills']/*[local-name()='fill']"))
    $cellFormats = @($StylesXml.SelectNodes("/*[local-name()='styleSheet']/*[local-name()='cellXfs']/*[local-name()='xf']"))
    $indexedColors = @($StylesXml.SelectNodes("/*[local-name()='styleSheet']/*[local-name()='colors']/*[local-name()='indexedColors']/*[local-name()='rgbColor']"))

    for ($styleIndex = 0; $styleIndex -lt $cellFormats.Count; $styleIndex++) {
        $fillId = [int]$cellFormats[$styleIndex].GetAttribute('fillId')
        if ($fillId -ge $fills.Count) {
            continue
        }

        $foreground = $fills[$fillId].SelectSingleNode("*[local-name()='patternFill']/*[local-name()='fgColor']")
        if ($null -eq $foreground) {
            continue
        }

        $rgb = $foreground.GetAttribute('rgb')
        $indexed = $foreground.GetAttribute('indexed')
        if ([string]::IsNullOrWhiteSpace($rgb) -and -not [string]::IsNullOrWhiteSpace($indexed)) {
            $indexedValue = [int]$indexed
            if ($indexedValue -lt $indexedColors.Count) {
                $rgb = $indexedColors[$indexedValue].GetAttribute('rgb')
            }
        }

        if ($rgb.Length -lt 6) {
            continue
        }

        $rgb = $rgb.Substring($rgb.Length - 6)
        $red = [Convert]::ToInt32($rgb.Substring(0, 2), 16)
        $green = [Convert]::ToInt32($rgb.Substring(2, 2), 16)
        $blue = [Convert]::ToInt32($rgb.Substring(4, 2), 16)
        if ($red -ge 200 -and $green -ge 180 -and $blue -le 160) {
            $yellowStyles[$styleIndex] = $true
        }
    }

    return $yellowStyles
}

function Get-CellText {
    param(
        [Parameter(Mandatory = $true)]$Cell,
        [Parameter(Mandatory = $true)][AllowEmptyCollection()][array]$SharedStrings
    )

    $cellType = $Cell.GetAttribute('t')
    if ($cellType -eq 'inlineStr') {
        return $Cell.InnerText
    }

    $valueNode = $Cell.SelectSingleNode("*[local-name()='v']")
    if ($null -eq $valueNode) {
        return ''
    }

    if ($cellType -eq 's') {
        $sharedStringIndex = [int]$valueNode.InnerText
        if ($sharedStringIndex -lt $SharedStrings.Count) {
            return $SharedStrings[$sharedStringIndex]
        }
        return ''
    }

    return $valueNode.InnerText
}

function Get-LatestCoverage {
    param([Parameter(Mandatory = $true)][string]$WorkbookPath)

    $archive = $null
    $periodCells = @()
    $cellStats = @{}

    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($WorkbookPath)
        $sharedStrings = @()
        $sharedStringsEntry = $archive.GetEntry('xl/sharedStrings.xml')
        if ($null -ne $sharedStringsEntry) {
            [xml]$sharedStringsXml = Read-ArchiveEntry -Entry $sharedStringsEntry
            $sharedStrings = @(
                $sharedStringsXml.SelectNodes("/*[local-name()='sst']/*[local-name()='si']") |
                    ForEach-Object { $_.InnerText }
            )
        }

        $yellowStyles = @{}
        $stylesEntry = $archive.GetEntry('xl/styles.xml')
        if ($null -ne $stylesEntry) {
            [xml]$stylesXml = Read-ArchiveEntry -Entry $stylesEntry
            $yellowStyles = Get-YellowStyles -StylesXml $stylesXml
        }

        $sheetEntries = @(
            $archive.Entries |
                Where-Object { $_.FullName -match '^xl/worksheets/sheet\d+\.xml$' } |
                Sort-Object FullName
        )

        foreach ($sheetEntry in $sheetEntries) {
            $sheetStream = $null
            $sheetReader = $null
            try {
                $sheetStream = $sheetEntry.Open()
                $sheetReader = [System.Xml.XmlReader]::Create($sheetStream)

                while (-not $sheetReader.EOF) {
                    if ($sheetReader.NodeType -ne [System.Xml.XmlNodeType]::Element -or $sheetReader.LocalName -ne 'row') {
                        if (-not $sheetReader.Read()) {
                            break
                        }
                        continue
                    }

                    $rowNumber = [int]$sheetReader.GetAttribute('r')
                    if ($rowNumber -gt 50) {
                        break
                    }

                    [xml]$rowXml = $sheetReader.ReadOuterXml()
                    $row = $rowXml.DocumentElement
                    foreach ($cell in @($row.SelectNodes("*[local-name()='c']"))) {
                        $cellReference = $cell.GetAttribute('r')
                        $column = Get-ColumnNumber -CellReference $cellReference
                        if ($column -gt 300) {
                            continue
                        }

                        $value = Get-CellText -Cell $cell -SharedStrings $sharedStrings
                        if ([string]::IsNullOrWhiteSpace($value)) {
                            continue
                        }

                        $columnKey = "$($sheetEntry.FullName):$column"
                        if (-not $cellStats.ContainsKey($columnKey)) {
                            $cellStats[$columnKey] = [pscustomobject]@{
                                FormulaRows = New-Object 'System.Collections.Generic.List[int]'
                                ConstantRows = New-Object 'System.Collections.Generic.List[int]'
                            }
                        }

                        if ($null -ne $cell.SelectSingleNode("*[local-name()='f']")) {
                            $cellStats[$columnKey].FormulaRows.Add($rowNumber)
                        }
                        else {
                            $cellStats[$columnKey].ConstantRows.Add($rowNumber)
                        }

                        $period = Get-Quarter -Value $value
                        if ($null -eq $period) {
                            continue
                        }

                        $styleValue = $cell.GetAttribute('s')
                        $styleIndex = if ([string]::IsNullOrWhiteSpace($styleValue)) { 0 } else { [int]$styleValue }
                        $periodCells += [pscustomobject]@{
                            RowKey = "$($sheetEntry.FullName):$rowNumber"
                            SheetKey = $sheetEntry.FullName
                            RowNumber = $rowNumber
                            Column = $column
                            Display = $period.Display
                            SortKey = $period.SortKey
                            IsForecast = $period.IsEstimate -or $yellowStyles.ContainsKey($styleIndex)
                        }
                    }
                }
            }
            finally {
                if ($null -ne $sheetReader) {
                    $sheetReader.Dispose()
                }
                if ($null -ne $sheetStream) {
                    $sheetStream.Dispose()
                }
            }
        }
    }
    finally {
        if ($null -ne $archive) {
            $archive.Dispose()
        }
    }

    $quarterRows = @($periodCells | Group-Object RowKey | Where-Object Count -ge 3)
    $boundaryCandidates = @(
        foreach ($quarterRow in $quarterRows) {
            $orderedCells = @($quarterRow.Group | Sort-Object SortKey, Column)

            $firstForecast = @($orderedCells | Where-Object IsForecast | Select-Object -First 1)
            if ($firstForecast.Count -eq 0) {
                continue
            }

            $latestActual = @(
                $orderedCells |
                    Where-Object { $_.SortKey -lt $firstForecast[0].SortKey -and -not $_.IsForecast } |
                    Select-Object -Last 1
            )
            if ($latestActual.Count -eq 0) {
                continue
            }

            [pscustomobject]@{
                Period = $latestActual[0]
                QuarterCount = $orderedCells.Count
            }
        }
    )

    if ($boundaryCandidates.Count -gt 0) {
        return @(
            $boundaryCandidates |
                Sort-Object @{ Expression = { $_.QuarterCount }; Descending = $true }, @{ Expression = { $_.Period.SortKey }; Descending = $true } |
                Select-Object -First 1
        )[0].Period.Display
    }

    $formulaBoundaryCandidates = @(
        foreach ($quarterRow in $quarterRows) {
            $orderedCells = @($quarterRow.Group | Sort-Object SortKey, Column)

            $formulaForecasts = @(
                foreach ($periodCell in $orderedCells) {
                    $columnKey = "$($periodCell.SheetKey):$($periodCell.Column)"
                    $stats = $cellStats[$columnKey]
                    $formulaCount = @($stats.FormulaRows | Where-Object { $_ -gt $periodCell.RowNumber }).Count
                    $constantCount = @($stats.ConstantRows | Where-Object { $_ -gt $periodCell.RowNumber }).Count
                    [pscustomobject]@{
                        Period = $periodCell
                        IsForecast = $formulaCount -ge 3 -and $constantCount -le 2 -and $formulaCount -gt ($constantCount * 2)
                    }
                }
            )

            $trailingForecastCount = 0
            for ($index = $formulaForecasts.Count - 1; $index -ge 0; $index--) {
                if (-not $formulaForecasts[$index].IsForecast) {
                    break
                }
                $trailingForecastCount++
            }

            $actualIndex = $formulaForecasts.Count - $trailingForecastCount - 1
            if ($trailingForecastCount -lt 2 -or $actualIndex -lt 0) {
                continue
            }

            [pscustomobject]@{
                Period = $formulaForecasts[$actualIndex].Period
                QuarterCount = $orderedCells.Count
                ForecastCount = $trailingForecastCount
            }
        }
    )

    if ($formulaBoundaryCandidates.Count -gt 0) {
        return @(
            $formulaBoundaryCandidates |
                Sort-Object @{ Expression = { $_.QuarterCount }; Descending = $true }, @{ Expression = { $_.ForecastCount }; Descending = $true }, @{ Expression = { $_.Period.SortKey }; Descending = $true } |
                Select-Object -First 1
        )[0].Period.Display
    }

    $coverageRowCandidates = @(
        foreach ($quarterRow in $quarterRows) {
            $orderedCells = @($quarterRow.Group | Sort-Object SortKey, Column)

            [pscustomobject]@{
                Period = $orderedCells[-1]
                QuarterCount = $orderedCells.Count
            }
        }
    )

    if ($coverageRowCandidates.Count -gt 0) {
        return @(
            $coverageRowCandidates |
                Sort-Object @{ Expression = { $_.QuarterCount }; Descending = $true }, @{ Expression = { $_.Period.SortKey }; Descending = $true } |
                Select-Object -First 1
        )[0].Period.Display
    }

    $repeatedSummaryPeriods = @(
        $periodCells |
            Where-Object { -not $_.IsForecast } |
            Group-Object SortKey |
            Where-Object Count -ge 2 |
            ForEach-Object { $_.Group[0] } |
            Sort-Object SortKey -Descending
    )
    if ($repeatedSummaryPeriods.Count -gt 0) {
        return $repeatedSummaryPeriods[0].Display
    }

    return 'Not listed'
}

$tickerWorkbooks = @(
    Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File -Filter '*.xlsx' |
        Where-Object {
            $_.BaseName -cmatch '^[A-Z][A-Z0-9_]{0,5}$' -and
            -not $_.FullName.StartsWith($gitDirectory, [System.StringComparison]::OrdinalIgnoreCase) -and
            (ConvertTo-RepositoryPath -FullName $_.FullName) -notmatch '(^|/)\[models\]/'
        } |
        Sort-Object FullName
)

$dirtyWorkbookPaths = @(
    & git -C $repositoryRoot diff HEAD --name-only --diff-filter=AM -- '*.xlsx'
    if ($LASTEXITCODE -ne 0) {
        throw 'Could not read changed workbook paths from Git.'
    }

    & git -C $repositoryRoot ls-files --others --exclude-standard -- '*.xlsx'
    if ($LASTEXITCODE -ne 0) {
        throw 'Could not read untracked workbook paths from Git.'
    }
) | Where-Object { -not [string]::IsNullOrWhiteSpace($_) } | Select-Object -Unique

$coverageRows = @()

foreach ($workbook in $tickerWorkbooks) {
    $repositoryPath = ConvertTo-RepositoryPath -FullName $workbook.FullName
    $directory = [System.IO.Path]::GetDirectoryName($repositoryPath).Replace('\', '/')
    try {
        $coverage = Get-LatestCoverage -WorkbookPath $workbook.FullName
    }
    catch {
        throw "Could not inspect quarterly coverage in $repositoryPath ($($_.Exception.Message))"
    }

    if ($coverage -eq 'Not listed') {
        Write-Warning "No quarterly coverage label was found in $repositoryPath."
    }

    $coveragePeriod = if ($coverage -eq 'Not listed') { $null } else { Get-Quarter -Value $coverage }

    $coverageRows += [pscustomobject]@{
        Ticker = $workbook.BaseName
        Sector = $directory.Replace('/', ' / ')
        Target = ConvertTo-MarkdownTarget -RepositoryPath $repositoryPath
        Coverage = $coverage
        CoverageSortKey = if ($null -eq $coveragePeriod) { 0 } else { $coveragePeriod.SortKey }
    }
}

$stockRows = @(
    foreach ($tickerGroup in $coverageRows | Group-Object Ticker) {
        $preferredModel = @(
            $tickerGroup.Group |
                Sort-Object @{ Expression = { $_.CoverageSortKey }; Descending = $true }, Target |
                Select-Object -First 1
        )[0]

        [pscustomobject]@{
            Ticker = $tickerGroup.Name
            Sector = @($tickerGroup.Group.Sector | Sort-Object -Unique) -join ', '
            Target = $preferredModel.Target
            Coverage = $preferredModel.Coverage
            CoverageSortKey = $preferredModel.CoverageSortKey
        }
    }
)

$existingReadme = if (Test-Path -LiteralPath $readmePath) { [System.IO.File]::ReadAllText($readmePath) } else { '' }
$storedRecentEntries = @()
if ($existingReadme.Contains($recentStartMarker) -and $existingReadme.Contains($recentEndMarker)) {
    $recentBlockPattern = [regex]::Escape($recentStartMarker) + '(.*?)' + [regex]::Escape($recentEndMarker)
    $recentBlockMatch = [regex]::Match($existingReadme, $recentBlockPattern, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $storedRecentEntries = @(
        [regex]::Matches($recentBlockMatch.Groups[1].Value, '(?m)^(?<line>\| \[(?<ticker>[A-Z0-9_]+)\].*)$') |
            ForEach-Object {
                [pscustomobject]@{
                    Ticker = $_.Groups['ticker'].Value
                    Status = if ($_.Groups['line'].Value -match '\| Pending \|$') { 'Pending' } else { 'Updated' }
                }
            }
    )
}

$dirtyEntries = @(
    $dirtyWorkbookPaths | ForEach-Object {
        [pscustomobject]@{
            Ticker = [System.IO.Path]::GetFileNameWithoutExtension($_)
            Status = 'Updated'
        }
    }
)
$candidateRecentEntries = @($dirtyEntries) + @($storedRecentEntries)
$recentRows = New-Object 'System.Collections.Generic.List[object]'
$recentTickers = @{}
foreach ($recentEntry in $candidateRecentEntries) {
    $recentTicker = $recentEntry.Ticker
    $recentModel = @($stockRows | Where-Object Ticker -eq $recentTicker | Select-Object -First 1)
    if ($recentModel.Count -eq 0 -or $recentTickers.ContainsKey($recentTicker)) {
        continue
    }

    $recentRows.Add([pscustomobject]@{
        Ticker = $recentModel[0].Ticker
        Sector = $recentModel[0].Sector
        Target = $recentModel[0].Target
        Coverage = $recentModel[0].Coverage
        Status = $recentEntry.Status
    })
    $recentTickers[$recentTicker] = $true
    if ($recentRows.Count -eq $recentUpdateCount) {
        break
    }
}

$recentLines = New-Object 'System.Collections.Generic.List[string]'
$recentLines.Add($recentStartMarker)
$recentLines.Add('| Ticker | Sector | Latest earnings | Status |')
$recentLines.Add('| --- | --- | --- | --- |')
foreach ($row in $recentRows) {
    $recentLines.Add("| [$($row.Ticker)]($($row.Target)) | $($row.Sector) | $($row.Coverage) | $($row.Status) |")
}
$recentLines.Add($recentEndMarker)
$recentTable = $recentLines -join [System.Environment]::NewLine

$tableLines = New-Object 'System.Collections.Generic.List[string]'
$tableLines.Add($startMarker)
$tableLines.Add('| Ticker | Sector | Latest earnings |')
$tableLines.Add('| --- | --- | --- |')
foreach ($row in $stockRows | Sort-Object Sector, Ticker) {
    $tableLines.Add("| [$($row.Ticker)]($($row.Target)) | $($row.Sector) | $($row.Coverage) |")
}
$tableLines.Add($endMarker)
$table = $tableLines -join [System.Environment]::NewLine

$readme = $existingReadme

if ($readme.Contains($startMarker) -and $readme.Contains($endMarker)) {
    $pattern = [regex]::Escape($startMarker) + '.*?' + [regex]::Escape($endMarker)
    $content = [regex]::Replace($readme, $pattern, $table, [System.Text.RegularExpressions.RegexOptions]::Singleline)
}
else {
    $existingContent = $readme.TrimStart()
    $content = "# Financial Models$([System.Environment]::NewLine)$([System.Environment]::NewLine)## Coverage$([System.Environment]::NewLine)$([System.Environment]::NewLine)$table"
    if (-not [string]::IsNullOrWhiteSpace($existingContent)) {
        $content += "$([System.Environment]::NewLine)$([System.Environment]::NewLine)$existingContent"
    }
}

if ($content.Contains($recentStartMarker) -and $content.Contains($recentEndMarker)) {
    $recentPattern = [regex]::Escape($recentStartMarker) + '.*?' + [regex]::Escape($recentEndMarker)
    $content = [regex]::Replace($content, $recentPattern, $recentTable, [System.Text.RegularExpressions.RegexOptions]::Singleline)
    $content = $content.Replace('## Recent updates', '## Model update tracker').Replace('## Recent model updates', '## Model update tracker')
}
else {
    $coverageHeading = '## Coverage'
    $coverageHeadingIndex = $content.IndexOf($coverageHeading, [System.StringComparison]::Ordinal)
    $recentSection = "## Model update tracker$([System.Environment]::NewLine)$([System.Environment]::NewLine)$recentTable$([System.Environment]::NewLine)$([System.Environment]::NewLine)"
    if ($coverageHeadingIndex -ge 0) {
        $content = $content.Insert($coverageHeadingIndex, $recentSection)
    }
    else {
        $content = $recentSection + $content
    }
}

$content = $content.TrimEnd() + [System.Environment]::NewLine
if ([System.IO.File]::ReadAllText($readmePath) -ceq $content) {
    Write-Host "Coverage tracker is already current: $($stockRows.Count) stocks."
    return
}

[System.IO.File]::WriteAllText(
    $readmePath,
    $content,
    (New-Object System.Text.UTF8Encoding($false))
)

Write-Host "Updated README.md coverage tracker with $($stockRows.Count) stocks."