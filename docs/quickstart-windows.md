# Quickstart on Windows

Use PowerShell for the commands below and run project commands from the repository
root. The core examples need no Node installation or browser download.

## Prerequisites

- Git and Python **3.15**, with the Python launcher, pip, and venv support.
- Node.js **26.11.1** only for optional UI tests.

Install Python using the [official Windows guidance](https://docs.python.org/3.15/using/windows.html)
and verify `py -3.15 --version`. Install Git from [Git for Windows](https://git-scm.com/downloads/win).
The CI core job uses Windows Server 2025; local desktop Windows must also meet
the installed browser's requirements if you run UI tests.

## Clone and create an environment

```powershell
git clone https://github.com/BVisagie/robot-framework-template.git
cd robot-framework-template
py -3.15 -m venv .venv
.\.venv\Scripts\Activate.ps1
python --version
python -m pip install -r requirements.txt
```

If you used GitHub's template button, clone your new repository instead.
If your PowerShell policy prevents activation, use `.\.venv\Scripts\python.exe`
in place of `python`; use full paths for other venv tools as well.

## Run the core examples

```powershell
python -m robot --pythonpath . --outputdir output/core tests/features tests/api tests/database
```

Expect 21 passing tests. HTTP fixtures use available loopback ports and temporary
SQLite files, and clean up automatically. Open `output/core/report.html` or
`output/core/log.html`. Fixture logs are under `output/core/fixtures/`.

## Optional UI setup

Install Node.js 26.11.1 from [Node.js](https://nodejs.org/en/download/current). Open a new
PowerShell session if needed, reactivate `.venv`, and verify `node --version`.

```powershell
python -m pip install -r requirements-ui.txt
rfbrowser init chromium
python -m robot --pythonpath . --outputdir output/ui tests/ui
```

Expect four passing UI tests. If `rfbrowser` is not on PATH, use
`python -m Browser.entry init chromium`.

Run all 25 local tests after UI setup:

```powershell
python -m robot --pythonpath . --outputdir output/all tests
```

For a visible browser:

```powershell
python -m robot --pythonpath . --outputdir output/ui --variable HEADLESS_BROWSER:false tests/ui
```

## Optional developer tools

```powershell
python -m pip install -r requirements-dev.txt
pre-commit install
robocop check .
robocop format --check .
ruff check .
ruff format --check .
python scripts/check_docs.py
```

See [contributing](contributing.md) for artifact verification and Libdoc commands.

## Configuration and troubleshooting

Set an environment override with PowerShell syntax:

```powershell
$env:HEADLESS_BROWSER = "true"
```

A Robot CLI variable takes precedence over the environment. See
[configuration](project-guide.md#configuration) for accepted values and defaults.

- Import errors: use the repository root and `--pythonpath .`.
- Missing packages: verify `python --version` and that the venv is active.
- Browser launch errors: verify Node 26.11.1 and repeat `rfbrowser init chromium` after
  upgrading Browser.
- Fixture errors: inspect `stderr.log` in the selected output directory.

The [Docker guide](quickstart-docker.md) provides an alternative using Linux containers.
Public-service examples are [explicitly selected demos](examples.md#optional-public-service-demos).
