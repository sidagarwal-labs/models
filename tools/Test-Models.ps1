[CmdletBinding()]
param(
    [switch]$StrictPrivacy
)

$ErrorActionPreference = 'Stop'

Add-Type -AssemblyName System.IO.Compression.FileSystem

$repositoryRoot = Split-Path -Parent $PSScriptRoot
$gitDirectory = Join-Path $repositoryRoot '.git'
$excelExtensions = @('.xlsx', '.xlsm', '.xlsb', '.xls')
$validationErrors = New-Object 'System.Collections.Generic.List[string]'
$authors = @{}
$externalLinkFiles = @()
$connectionFiles = @()
$embeddedObjectFiles = @()
$commentFiles = @()
$customPropertyFiles = @()

function ConvertTo-RepositoryPath {
    param([Parameter(Mandatory = $true)][string]$FullName)

    return $FullName.Substring($repositoryRoot.Length + 1).Replace('\', '/')
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

function Format-FindingList {
    param([Parameter(Mandatory = $true)][array]$Files)

    $visibleFiles = @($Files | Select-Object -First 8)
    $suffix = if ($Files.Count -gt $visibleFiles.Count) { " (+$($Files.Count - $visibleFiles.Count) more)" } else { '' }
    return ($visibleFiles -join ', ') + $suffix
}

$temporaryFiles = @(
    Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File |
        Where-Object {
            $_.Name -like '~$*.xls*' -and
            -not $_.FullName.StartsWith($gitDirectory, [System.StringComparison]::OrdinalIgnoreCase)
        }
)

foreach ($temporaryFile in $temporaryFiles) {
    $validationErrors.Add("Close Excel and remove its lock file: $(ConvertTo-RepositoryPath -FullName $temporaryFile.FullName)")
}

$workbooks = @(
    Get-ChildItem -LiteralPath $repositoryRoot -Recurse -File |
        Where-Object {
            $excelExtensions -contains $_.Extension.ToLowerInvariant() -and
            -not $_.FullName.StartsWith($gitDirectory, [System.StringComparison]::OrdinalIgnoreCase)
        } |
        Sort-Object FullName
)

foreach ($workbook in $workbooks) {
    $relativePath = ConvertTo-RepositoryPath -FullName $workbook.FullName
    $extension = $workbook.Extension.ToLowerInvariant()

    if ($workbook.Length -eq 0) {
        $validationErrors.Add("Workbook is empty: $relativePath")
        continue
    }

    if ($workbook.Length -gt 2GB) {
        $validationErrors.Add("Workbook exceeds GitHub's maximum Git LFS object size: $relativePath")
        continue
    }

    if ($extension -eq '.xls') {
        Write-Warning "Legacy .xls workbook cannot receive the full package audit: $relativePath"
        continue
    }

    $archive = $null
    try {
        $archive = [System.IO.Compression.ZipFile]::OpenRead($workbook.FullName)
        $entryNames = @($archive.Entries | ForEach-Object { $_.FullName })
        $workbookEntry = if ($extension -eq '.xlsb') { 'xl/workbook.bin' } else { 'xl/workbook.xml' }

        if (-not ($entryNames -contains '[Content_Types].xml') -or -not ($entryNames -contains $workbookEntry)) {
            $validationErrors.Add("File is not a complete Excel package: $relativePath")
            continue
        }

        $coreEntry = $archive.GetEntry('docProps/core.xml')
        if ($null -ne $coreEntry) {
            [xml]$coreXml = Read-ArchiveEntry -Entry $coreEntry
            foreach ($propertyName in @('creator', 'lastModifiedBy')) {
                $node = $coreXml.SelectSingleNode("//*[local-name()='$propertyName']")
                if ($null -ne $node -and -not [string]::IsNullOrWhiteSpace($node.InnerText)) {
                    $authors[$node.InnerText.Trim()] = $true
                }
            }
        }

        if (@($entryNames | Where-Object { $_ -match '^xl/externalLinks/externalLink\d+\.xml$' }).Count -gt 0) {
            $externalLinkFiles += $relativePath
        }

        if ($entryNames -contains 'xl/connections.xml') {
            $connectionFiles += $relativePath
        }

        if (@($entryNames | Where-Object { $_ -like 'xl/embeddings/*' }).Count -gt 0) {
            $embeddedObjectFiles += $relativePath
        }

        if (@($entryNames | Where-Object { $_ -match '^xl/(comments\d+\.xml|threadedComments/)' }).Count -gt 0) {
            $commentFiles += $relativePath
        }

        if ($entryNames -contains 'docProps/custom.xml') {
            $customPropertyFiles += $relativePath
        }
    }
    catch {
        $validationErrors.Add("Workbook could not be read: $relativePath ($($_.Exception.Message))")
    }
    finally {
        if ($null -ne $archive) {
            $archive.Dispose()
        }
    }
}

Write-Host "Validated $($workbooks.Count) workbooks; all readable Excel packages passed structural checks."

if ($authors.Count -gt 0) {
    Write-Warning "Workbook author metadata found: $((@($authors.Keys | Sort-Object) -join ', '))"
}

if ($externalLinkFiles.Count -gt 0) {
    Write-Warning "External workbook links found in $($externalLinkFiles.Count) file(s): $(Format-FindingList -Files $externalLinkFiles)"
}

if ($connectionFiles.Count -gt 0) {
    Write-Warning "Data connections found in $($connectionFiles.Count) file(s): $(Format-FindingList -Files $connectionFiles)"
}

if ($embeddedObjectFiles.Count -gt 0) {
    Write-Warning "Embedded objects found in $($embeddedObjectFiles.Count) file(s): $(Format-FindingList -Files $embeddedObjectFiles)"
}

if ($commentFiles.Count -gt 0) {
    Write-Warning "Excel comments or notes found in $($commentFiles.Count) file(s): $(Format-FindingList -Files $commentFiles)"
}

if ($customPropertyFiles.Count -gt 0) {
    Write-Warning "Custom document properties found in $($customPropertyFiles.Count) file(s): $(Format-FindingList -Files $customPropertyFiles)"
}

$privacyFindingCount = $authors.Count + $externalLinkFiles.Count + $connectionFiles.Count + $embeddedObjectFiles.Count + $commentFiles.Count + $customPropertyFiles.Count
if ($StrictPrivacy -and $privacyFindingCount -gt 0) {
    $validationErrors.Add("Strict privacy mode found $privacyFindingCount metadata or workbook feature finding(s). Review them in Excel before publishing.")
}

if ($validationErrors.Count -gt 0) {
    foreach ($validationError in $validationErrors) {
        Write-Host "ERROR: $validationError" -ForegroundColor Red
    }

    throw "Model validation failed with $($validationErrors.Count) error(s)."
}
