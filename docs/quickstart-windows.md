# Quickstart (Windows)

This guide takes you from a fresh clone to running the sample tests locally.

## Prerequisites

- Python 3.13+
- Node.js 22+
- Git

### Where to run commands

- System-level installs (e.g., Python installer, Node installer) can be run from any directory.
- Project-specific steps (e.g., `git clone`, `cd robot-framework-template`, creating/activating `.venv`, `pip install -r requirements.txt`, `rfbrowser init`, `robot ...`) should be run from the project root directory unless noted otherwise.

## Installing Python 3.13+

Download and install the latest Python 3.13 for Windows (be sure to check “Add python.exe to PATH” during installation):

- Official downloads: https://www.python.org/downloads/windows/

Verify installation:

```powershell
py -3.13 --version
python --version
```

## Installing Node.js 22+

Download and install the latest LTS (22.x) from Node.js for Windows:

- Node.js downloads: https://nodejs.org/en/download

Verify installation:

```powershell
node -v
npm -v
```

## 1) Clone and enter the project

```powershell
git clone https://github.com/BVisagie/robot-framework-template
cd robot-framework-template
```

## 2) Create and activate a virtual environment (PowerShell)

```powershell
py -3.13 -m venv .venv
.\.venv\Scripts\Activate.ps1
python --version  # should be 3.13+
```

Upgrade pip:

```powershell
python -m pip install --upgrade pip
```

## 3) Install Python dependencies

```powershell
pip install -r requirements.txt
# Optional dev tools
pip install -r requirements-dev.txt
```

## 4) Initialize Robot Framework Browser

On Windows, Playwright system dependencies are handled differently. Initialize the Browser library:

```powershell
rfbrowser init
```

## 5) (Optional) Pre-commit hooks

```powershell
pre-commit install
```

Notes:

- Ensure your virtual environment is active (`.\.venv\Scripts\Activate.ps1` if you used `.venv`).
- Install dev tools first: `pip install -r requirements-dev.txt`.
- If you see "pre-commit: command not found", try: `python -m pre_commit install`.
- Verify: `pre-commit --version`.

Run lint/format checks:

```powershell
robocop check .
robocop format .
```

## 6) Run the tests

Headless mode is the default.

- API tests:

```powershell
robot --outputdir output tests/project_json_placeholder/api_tests
```

- UI tests (Wikipedia demo):

```powershell
robot --outputdir output tests/project_wikipedia/ui_tests
```

## 7) Useful environment variables

- HEADLESS_BROWSER=true|false (default true)
- WIKIPEDIA_BASE_URL to override the default https://www.wikipedia.org/
- Database (examples only): DB_HOST, DB_PORT, DB_SERVICE_NAME, DB_USER, DB_PASSWORD, DB_API_MODULE

Example (PowerShell):

```powershell
$env:HEADLESS_BROWSER = "true"
$env:WIKIPEDIA_BASE_URL = "https://www.wikipedia.org/"
```

## 8) Troubleshooting

- If browsers fail to launch, re-run `rfbrowser init` after ensuring Node 22+ is installed.
- For DB placeholders, tests are tagged `do_not_run` by default and are documentation-only.
