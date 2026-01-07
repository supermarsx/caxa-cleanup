# caxa-cleanup

![GitHub Downloads (all assets, latest release)](https://img.shields.io/github/downloads/Caxa-Cleanup/caxa-cleanup/latest/total?style=flat-square)
![GitHub Actions Workflow Status](https://img.shields.io/github/actions/workflow/status/Caxa-Cleanup/caxa-cleanup/ci.yml?style=flat-square)
![GitHub stars](https://img.shields.io/github/stars/Caxa-Cleanup/caxa-cleanup?style=flat-square)
![GitHub forks](https://img.shields.io/github/forks/Caxa-Cleanup/caxa-cleanup?style=flat-square)
![GitHub watchers](https://img.shields.io/github/watchers/Caxa-Cleanup/caxa-cleanup?style=flat-square)
![GitHub License](https://img.shields.io/github/license/Caxa-Cleanup/caxa-cleanup?style=flat-square)

Caxa Binary JS Applications Cache Script.

When caxa generated binary gets stuck and app exits use this script to cleanup caxa's cache. For Windows only, written in AutoIt3.

## Structure

- `src/`: Source code (`.au3` script and commands list).
- `scripts/`: Helper scripts (e.g., icon generator, build, lint).
- `assets/`: Generated assets.

## Downloads

Check the [Releases](https://github.com/Caxa-Cleanup/caxa-cleanup/releases) page. Each release includes:
- `caxa-cleanup.zip`: Standard executable + `commands.list`.
- `caxa-cleanup-upx.zip`: UPX compressed executable + `commands.list`.
- `caxa-cleanup.exe`: Standalone binary.
- `caxa-cleanup-upx.exe`: Standalone UPX compressed binary.

## Development

### Prerequisites

- Node.js installed (optional, not used for build).
- Python 3.x installed (for icon generation).
- AutoIt3 installed (to compile or run the script).
- PowerShell 7+.

### Setup

No setup required for scripts, standard PowerShell environment.

### Scripts

- **Lint**: `pwsh ./scripts/Lint.ps1`
- **Format**: `pwsh ./scripts/Format.ps1`
- **Test**: `pwsh ./scripts/Test.ps1`
- **Build**: `pwsh ./scripts/Build.ps1` (Generates `dist/` with all artifacts).
- **Generate Icon**: `python scripts/generate_icon.py`

### CI/CD

This repository uses GitHub Actions for Continuous Integration and deployment.
- **Jobs**: Lint, Format, and Test run in parallel.
- **Build**: Runs only if all checks pass.
- **Release**: Automatically creates a release versioned `YY.N` (Year.RunNumber) on push to `main` with all artifacts attached.


## Usage

1. Compile `src/caxa-cleanup.au3`.
2. Place `commands.list` in the same directory as the executable.
3. Run as Administrator.
