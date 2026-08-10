# Quickstart (Linux)

This guide takes you from a fresh clone to running the sample tests locally.

Examples below cover both **Ubuntu/Debian (`apt`)** and **Fedora (`dnf`)**. Use the section that matches your distribution.

Important for UI tests: Playwright only officially supports Debian/Ubuntu on Linux
([system requirements](https://playwright.dev/docs/intro#system-requirements)).
`npx playwright install-deps` uses `apt-get` and **will fail on Fedora**. Fedora is fully fine for
API tests and general Robot Framework work; for local UI runs on Fedora use the
[Docker quickstart](quickstart-docker.md) (recommended) or the best-effort Fedora notes in section 4.

## Prerequisites

- Python 3.14+ (latest bugfix release line)
- Node.js 24+ (Active LTS)
- Git

### Where to run commands

- System-level installs (package manager, Node setup, Playwright OS deps on Ubuntu/Debian) can be run from any directory.
- Project-specific steps (e.g., `git clone`, `cd robot-framework-template`, creating/activating `venv`, `pip install -r requirements.txt`, `rfbrowser init`, `robot ...`) should be run from the project root directory unless noted otherwise.

## Installing Python 3.14+

If Python 3.14 is not installed, either install from the official downloads or use your distro's packages.

- Official downloads: https://www.python.org/downloads/
- Status of Python versions: https://devguide.python.org/versions/

### Ubuntu / Debian (`apt`)

```sh
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.14 python3.14-venv
python3.14 --version
```

### Fedora (`dnf`)

```sh
sudo dnf install -y python3.14
python3.14 --version
```

If your Fedora release does not yet ship `python3.14` in the default repos, install the newest available 3.x line from Fedora (or use the official python.org installer) and ensure it is 3.14+:

```sh
sudo dnf install -y python3
python3 --version
```

## Installing Node.js 24+

Install the Active LTS (24.x / Krypton) and verify with `node -v` / `npm -v`.

### Ubuntu / Debian (`apt` + NodeSource)

```sh
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v
npm -v
```

If `apt-get update` fails due to a third‑party PPA

Some systems have extra PPAs that break `apt-get update` during the NodeSource setup. If you see errors like "does not have a Release file", disable the offending PPA and retry:

```sh
# example: remove deadsnakes PPA if it is invalid for your Ubuntu codename
sudo add-apt-repository -r ppa:deadsnakes/ppa || true
sudo rm -f /etc/apt/sources.list.d/deadsnakes-ubuntu-ppa*.list
sudo apt-get update

# rerun NodeSource setup and install Node.js 24 Active LTS
curl -fsSL https://deb.nodesource.com/setup_24.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v && npm -v
```

### Fedora (`dnf` + NodeSource)

```sh
curl -fsSL https://rpm.nodesource.com/setup_24.x | sudo bash -
sudo dnf install -y nodejs
node -v
npm -v
```

### Alternative on any distro: nvm (user‑space)

If you prefer to avoid system packages, use nvm and install Node 24 Active LTS into your user profile:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.6/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 24
nvm use 24
node -v && npm -v
```

## 1) Clone and enter the project

Install Git first if needed:

```sh
# Ubuntu / Debian
sudo apt-get install -y git

# Fedora
sudo dnf install -y git
```

```sh
git clone https://github.com/BVisagie/robot-framework-template
cd robot-framework-template
```

## 2) Create and activate a virtual environment

```sh
python3.14 -m venv venv
source venv/bin/activate
python --version  # should be 3.14+
```

Upgrade pip:

```sh
pip install --upgrade pip
```

## 3) Install Python dependencies

```sh
pip install -r requirements.txt
# Optional dev tools
pip install -r requirements-dev.txt
```

## 4) Install Node.js and Playwright browser deps

If Node 24+ is not yet installed, complete the steps in "Installing Node.js 24+" above.

### Ubuntu / Debian (officially supported by Playwright)

Install Playwright OS dependencies, then initialize Robot Framework Browser:

- If Node was installed system-wide (NodeSource):

```sh
sudo npx playwright install-deps
```

If you see "sudo: npx: command not found", ensure npm/npx is available for root:

```sh
sudo apt-get install -y nodejs || true
sudo apt-get install -y npm || true
# open a new shell or re-login, then retry
sudo npx playwright install-deps
```

- If Node was installed via nvm (user-space), preserve PATH when using sudo:

```sh
sudo -E env "PATH=$PATH" npx playwright install-deps
```

```sh
rfbrowser init
```

### Fedora (UI path not officially supported by Playwright)

Do **not** run `npx playwright install-deps` on Fedora. Playwright detects a non-Ubuntu OS, falls back to
`ubuntu24.04` packages, and then fails with `apt-get: command not found`.

Recommended options:

1. **Supported for UI:** use the [Docker quickstart](quickstart-docker.md) (Ubuntu-based image with Browser/Playwright deps).
2. **API-only on the host:** skip this section’s OS-deps step and run the API samples in section 6.
3. **Best-effort local Chromium UI (unsupported):** skip `install-deps`, initialize browsers only, then try the Wikipedia suite.
   This template launches Chromium only; community reports often show Chromium working on recent Fedora without
   `install-deps`, but this is outside Playwright’s supported matrix and may break across Fedora releases.

```sh
# Fedora best-effort local UI only — skip install-deps
rfbrowser init
robot --pythonpath . --outputdir output tests/project_wikipedia/ui_tests
```

If Chromium fails to start, prefer Docker rather than chasing distro-specific shared libraries.

## 5) (Optional) Pre-commit hooks

```sh
pre-commit install
```

Notes:

- Ensure your virtual environment is active (`source venv/bin/activate`).
- Install dev tools first: `pip install -r requirements-dev.txt`.
- If you see "pre-commit: command not found", try: `python -m pre_commit install`.
- Verify: `pre-commit --version`.

Run lint/format checks:

```sh
robocop check .
robocop format .
```

## 6) Run the tests

Headless mode is the default. Always pass `--pythonpath .` from the project root so root-relative
`Resource` / `Library` / `Variables` imports resolve (see the official
[project structure guide](https://docs.robotframework.org/docs/examples/project_structure)).

- API tests:

```sh
robot --pythonpath . --outputdir output tests/project_json_placeholder/api_tests
```

- UI tests (Wikipedia demo):

```sh
robot --pythonpath . --outputdir output tests/project_wikipedia/ui_tests
```

- All runnable samples (excludes placeholder DB examples):

```sh
robot --pythonpath . --outputdir output --exclude do_not_run tests
```

## 7) Useful environment variables

- HEADLESS_BROWSER=true|false (default true)
- WIKIPEDIA_BASE_URL to override the default https://www.wikipedia.org/
- Database (examples only): DB_HOST, DB_PORT, DB_SERVICE_NAME, DB_USER, DB_PASSWORD, DB_API_MODULE

Example:

```sh
export HEADLESS_BROWSER=true
export WIKIPEDIA_BASE_URL=https://www.wikipedia.org/
```

## 8) Troubleshooting

- Ubuntu/Debian UI: re-run `rfbrowser init` after Node 24+ and `sudo npx playwright install-deps` are installed.
- Fedora UI: if you saw `apt-get: command not found` from `playwright install-deps`, that is expected — Playwright does not
  officially support Fedora. Use [Docker](quickstart-docker.md) for a supported UI path, or try the best-effort
  `rfbrowser init` flow in section 4.
- For DB placeholders, tests are tagged `do_not_run` by default and are documentation-only.
