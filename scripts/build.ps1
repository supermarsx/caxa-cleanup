# Configuration
$AutoItDir = "C:\Program Files (x86)\AutoIt3"
$Aut2Exe = Join-Path $AutoItDir "Aut2Exe\Aut2exe.exe"
$SrcDir = Join-Path $PSScriptRoot "..\src"
$DistDir = Join-Path $PSScriptRoot "..\dist"
$SourceFile = Join-Path $SrcDir "caxa-cleanup.au3"
$CommandsFile = Join-Path $SrcDir "commands.list"
$IconFile = Join-Path $PSScriptRoot "..\assets\icon.ico"

# Outputs
$ExeStandard = Join-Path $DistDir "caxa-cleanup.exe"

$ExeUpx = Join-Path $DistDir "caxa-cleanup-upx.exe"
$ZipStandard = Join-Path $DistDir "caxa-cleanup.zip"
$ZipUpx = Join-Path $DistDir "caxa-cleanup-upx.zip"

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

# ---------------------------------------------------------
# Build Function
# ---------------------------------------------------------
function Build-Exe {
    param ($OutFile, $Pack)
    
    $PackArg = if ($Pack) { "/pack" } else { "/nopack" }
    
    Write-Host "Building $OutFile (Pack: $Pack)..."
    
    $Process = Start-Process -FilePath $Aut2Exe -ArgumentList @(
        "/in", """$SourceFile"""
        "/out", """$OutFile"""
        "/icon", """$IconFile"""
        "/x64"
        "/gui"
        $PackArg
    ) -Wait -PassThru -NoNewWindow

    if ($Process.ExitCode -ne 0) {
        Write-Error "Build failed for $OutFile with exit code $($Process.ExitCode)"
        exit $Process.ExitCode
    }
}

# 1. Build Standard
Build-Exe -OutFile $ExeStandard -Pack $false

# 2. Build UPX
# Note: UPX must be configured in AutoIt or available. If /pack fails in environment without upx, this might fail.
# Standard Aut2Exe tries to find UPX in specific locations.
Build-Exe -OutFile $ExeUpx -Pack $true

# Copy commands.list to dist (for raw artifacts)
Copy-Item $CommandsFile $DistDir

# 3. Create Zips
Write-Host "Creating Archives..."

# Zip Standard
Compress-Archive -Path $ExeStandard, $CommandsFile -DestinationPath $ZipStandard

# Zip UPX
Compress-Archive -Path $ExeUpx, $CommandsFile -DestinationPath $ZipUpx

Write-Host "Build Complete."
Write-Host " - Standard Exe: $ExeStandard"
Write-Host " - UPX Exe:      $ExeUpx"
Write-Host " - Standard Zip: $ZipStandard"
Write-Host " - UPX Zip:      $ZipUpx"

