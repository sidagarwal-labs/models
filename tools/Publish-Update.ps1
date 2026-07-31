[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Message,

    [switch]$Yes
)

$ErrorActionPreference = 'Stop'

$repositoryRoot = Split-Path -Parent $PSScriptRoot

function Assert-GitSuccess {
    param([Parameter(Mandatory = $true)][string]$Operation)

    if ($LASTEXITCODE -ne 0) {
        throw "$Operation failed with Git exit code $LASTEXITCODE."
    }
}

Push-Location $repositoryRoot
try {
    & (Join-Path $PSScriptRoot 'Update-Catalog.ps1')
    & (Join-Path $PSScriptRoot 'Update-Coverage.ps1')
    & (Join-Path $PSScriptRoot 'Test-Models.ps1')

    $insideWorkTree = & git rev-parse --is-inside-work-tree 2>$null
    if ($LASTEXITCODE -ne 0 -or $insideWorkTree -ne 'true') {
        throw 'This folder is not an initialized Git repository.'
    }

    $remoteNames = @(& git remote)
    Assert-GitSuccess -Operation 'Reading repository remotes'
    if ($remoteNames -notcontains 'origin') {
        throw 'No origin remote is configured. Create an empty GitHub repository, then run: git remote add origin https://github.com/YOUR-USER/YOUR-REPOSITORY.git'
    }

    $remote = & git remote get-url origin
    Assert-GitSuccess -Operation 'Reading origin remote'

    $status = @(& git status --short)
    Assert-GitSuccess -Operation 'Reading repository status'

    if ($status.Count -eq 0) {
        Write-Host 'No workbook or catalog changes are waiting to be published.'
        return
    }

    Write-Host ''
    Write-Host 'Pending changes:'
    $status | ForEach-Object { Write-Host "  $_" }
    Write-Host ''

    if (-not $Yes) {
        $answer = Read-Host "Commit these changes and push to $remote? [y/N]"
        if ($answer -notmatch '^(y|yes)$') {
            Write-Host 'Publication cancelled; no files were staged or committed.'
            return
        }
    }

    & git add --all
    Assert-GitSuccess -Operation 'Staging changes'

    & git diff --cached --check
    Assert-GitSuccess -Operation 'Checking staged changes'

    & git commit -m $Message
    Assert-GitSuccess -Operation 'Creating commit'

    $branch = & git branch --show-current
    Assert-GitSuccess -Operation 'Reading current branch'

    $upstream = & git for-each-ref --format='%(upstream:short)' "refs/heads/$branch"
    Assert-GitSuccess -Operation 'Reading upstream branch'
    $hasUpstream = -not [string]::IsNullOrWhiteSpace($upstream)

    if ($hasUpstream) {
        & git push
    }
    else {
        & git push --set-upstream origin $branch
    }
    Assert-GitSuccess -Operation 'Pushing commit'

    Write-Host "Published '$Message' to $remote."
}
finally {
    Pop-Location
}
