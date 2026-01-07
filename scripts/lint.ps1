# Configuration
$AutoItDir = "C:\Program Files (x86)\AutoIt3"
$Au3Check = Join-Path $AutoItDir "Au3Check.exe"
$SrcDir = Join-Path $PSScriptRoot "..\src"
$SourceFile = Join-Path $SrcDir "caxa-cleanup.au3"

# Check requirements
if (-not (Test-Path $Au3Check)) {
    Write-Warning "Au3Check not found at $Au3Check. Skipping lint."
    exit 0
}

Write-Host "Linting $SourceFile..."

$Process = Start-Process -FilePath $Au3Check -ArgumentList """$SourceFile""" -Wait -PassThru -NoNewWindow

if ($Process.ExitCode -eq 0) {
    Write-Host "Lint passed."
} else {
    Write-Error "Lint failed with exit code $($Process.ExitCode)"
    exit $Process.ExitCode
}
