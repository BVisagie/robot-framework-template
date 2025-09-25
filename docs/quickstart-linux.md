# Quickstart (Linux)

This guide takes you from a fresh clone to running the sample tests locally.

## Prerequisites

- Python 3.13+
- Node.js 22+
- Git

### Where to run commands

- System-level installs (e.g., `sudo apt-get install ...`, Node setup, `sudo npx playwright install-deps`) can be run from any directory.
- Project-specific steps (e.g., `git clone`, `cd robot-framework-template`, creating/activating `venv`, `pip install -r requirements.txt`, `rfbrowser init`, `robot ...`) should be run from the project root directory unless noted otherwise.

## Installing Python 3.13+

If Python 3.13 is not installed, either install from the official downloads or use your distro's packages.

- Official downloads: https://www.python.org/downloads/
- Ubuntu/Debian example:

```sh
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa -y
sudo apt-get update
sudo apt-get install -y python3.13 python3.13-venv
python3.13 --version
```

## Installing Node.js 22+

Install the current LTS (22.x) from NodeSource and verify:

```sh
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
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

# rerun NodeSource setup and install Node.js 22
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
node -v && npm -v
```

Alternative: install Node.js via nvm (user‑space)

If you prefer to avoid apt entirely, use nvm and install Node 22 LTS into your user profile:

```sh
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install 22
nvm use 22
node -v && npm -v
```

## 1) Clone and enter the project

```sh
git clone https://github.com/BVisagie/robot-framework-template
cd robot-framework-template
```

## 2) Create and activate a virtual environment

```sh
python3 -m venv venv
source venv/bin/activate
python --version  # should be 3.13+
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

If Node 22+ is not yet installed, complete the steps in "Installing Node.js 22+" above. Then install Playwright system deps:

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

Initialize Robot Framework Browser (downloads browser engines for tests):

```sh
rfbrowser init
```

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

Headless mode is the default.

- API tests:

```sh
robot --outputdir output tests/project_json_placeholder/api_tests
```

- UI tests (Wikipedia demo):

```sh
robot --outputdir output tests/project_wikipedia/ui_tests
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

- If browsers fail to launch, re-run `rfbrowser init` after ensuring Node 22+ and `sudo npx playwright install-deps` are installed.
- For DB placeholders, tests are tagged `do_not_run` by default and are documentation-only.
