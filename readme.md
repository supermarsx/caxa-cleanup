# caxa-cleanup

Caxa Binary JS Applications Cache Script.

When caxa generated binary gets stuck and app exits use this script to cleanup caxa's cache. For Windows only, written in AutoIt3.

## Structure

- `src/`: Source code (`.au3` script and commands list).
- `scripts/`: Helper scripts (e.g., icon generator).
- `assets/`: Generated assets.

## Development

### Prerequisites

- Node.js installed.
- Python 3.x installed.
- AutoIt3 installed (to compile or run the script).

### Setup

```bash
npm install
```

### Generate Icon

To generate the carton box icon:

```bash
npm run generate-icon
```

This will create `assets/icon.svg`.

### CI/CD

This repository uses GitHub Actions for Continuous Integration and deployment.
- On push to `main`, it runs the icon generator and performs a semantic release.

## Usage

1. Compile `src/caxa-cleanup.au3`.
2. Place `commands.list` in the same directory as the executable.
3. Run as Administrator.
