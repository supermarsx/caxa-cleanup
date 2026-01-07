# Configuration
$AutoItDir = "C:\Program Files (x86)\AutoIt3"
$Aut2Exe = Join-Path $AutoItDir "Aut2Exe\Aut2exe.exe"
$SrcDir = Join-Path $PSScriptRoot "..\src"
$DistDir = Join-Path $PSScriptRoot "..\dist"
$SourceFile = Join-Path $SrcDir "caxa-cleanup.au3"
$OutputFile = Join-Path $DistDir "caxa-cleanup.exe"

# Check requirements
if (-not (Test-Path $Aut2Exe)) {
    Write-Error "Aut2Exe not found at $Aut2Exe"
    exit 1
}

# Clean/Create Dist
if (Test-Path $DistDir) {
    Remove-Item $DistDir -Recurse -Force
}
New-Item -ItemType Directory -Path $DistDir -Force | Out-Null

Write-Host "Building $SourceFile..."

# Build Command
$ArgumentList = @(
    "/in", """$SourceFile"""
    "/out", """$OutputFile"""
    "/nopack"
    "/x64"
    "/gui"
)

$Process = Start-Process -FilePath $Aut2Exe -ArgumentList $ArgumentList -Wait -PassThru -NoNewWindow

if ($Process.ExitCode -eq 0) {
    Write-Host "Build successful: $OutputFile"
    
    # Copy commands.list
    Copy-Item (Join-Path $SrcDir "commands.list") $DistDir
    Write-Host "Copied commands.list to dist directory"
} else {
    Write-Error "Build failed with exit code $($Process.ExitCode)"
    exit $Process.ExitCode
}
