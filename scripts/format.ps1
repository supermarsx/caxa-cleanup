# Configuration
$AutoItDir = "C:\Program Files (x86)\AutoIt3"
$Tidy = Join-Path $AutoItDir "SciTE\Tidy\Tidy.exe"
$SrcDir = Join-Path $PSScriptRoot "..\src"
$SourceFile = Join-Path $SrcDir "caxa-cleanup.au3"

# Check requirements
if (-not (Test-Path $Tidy)) {
    Write-Warning "Tidy not found at $Tidy. Skipping format."
    exit 0
}

Write-Host "Formatting $SourceFile..."

$Process = Start-Process -FilePath $Tidy -ArgumentList """$SourceFile""" -Wait -PassThru -NoNewWindow

if ($Process.ExitCode -eq 0) {
    Write-Host "Formatting passed."
} else {
    Write-Error "Formatting failed with exit code $($Process.ExitCode)"
    exit $Process.ExitCode
}
