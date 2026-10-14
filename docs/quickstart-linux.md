# Quickstart on Linux

Start with the Python-only examples. Browser setup is an additional step.
Run project commands from the repository root.

## Prerequisites

- Git and Python **3.15**, including the `venv` module and pip.
- Node.js **26.11.1** only if you want UI tests.

Install Python using your distribution's supported packages or the
[official Python installation guidance](https://docs.python.org/3.15/using/unix.html).
Check that `python3.15 --version` works. On Debian/Ubuntu, install the corresponding
venv package if your Python installation does not include it. Package availability
depends on the distribution release; this template does not require adding a PPA.

## Clone and create an environment

```sh
git clone https://github.com/BVisagie/robot-framework-template.git
cd robot-framework-template
python3.15 -m venv .venv
source .venv/bin/activate
python --version
python -m pip install -r requirements.txt
```

If you used GitHub's template button, clone your new repository instead.

## Run the core examples

```sh
python -m robot --pythonpath . --outputdir output/core tests/features tests/api tests/database
```

Expect 21 passing tests. The fixture starts automatically on an available loopback
port, uses a temporary SQLite database, and stops after each suite. Test execution
does not need internet access. Dependency installation does.

Open `output/core/report.html` or `output/core/log.html` in your browser.
Fixture stdout/stderr are retained under `output/core/fixtures/` for diagnosis.

## Optional UI setup

Install Node.js 26.11.1 from [Node.js](https://nodejs.org/en/download/current) or an existing
runtime manager, and verify `node --version` and `npm --version`.

On a [Playwright-supported Linux distribution](https://playwright.dev/docs/intro#system-requirements):

```sh
python -m pip install -r requirements-ui.txt
rfbrowser init --with-deps chromium
python -m robot --pythonpath . --outputdir output/ui tests/ui
```

The `--with-deps` step uses the distribution package manager and may request sudo
for OS libraries. Run the command in your active venv as your normal user; Browser
initialization and downloaded binaries belong to that environment/user.
If OS dependencies are already installed, use `rfbrowser init chromium`.

Ubuntu 24.04 is the CI UI platform. On Fedora, Arch, or another distribution outside
Playwright's supported matrix, use the [Docker UI target](quickstart-docker.md).
Core tests still need only Python. Avoid running the apt-based `--with-deps` path
on an unsupported distribution.

Expect four passing UI tests. Run everything after installing Browser with:

```sh
python -m robot --pythonpath . --outputdir output/all tests
```

For a visible browser on a graphical desktop:

```sh
python -m robot --pythonpath . --outputdir output/ui --variable HEADLESS_BROWSER:false tests/ui
```

## Optional developer tools

```sh
python -m pip install -r requirements-dev.txt
pre-commit install
robocop check .
robocop format --check .
ruff check .
ruff format --check .
python scripts/check_docs.py
```

See [contributing](contributing.md) for full checks and formatting commands.

## Troubleshooting

- A missing `robot` executable usually means the venv is inactive. Activate it and
  use `python -m robot` so the interpreter and dependencies stay together.
- Import errors: run from the repository root and include `--pythonpath .`.
- Browser launch errors: verify Node 26.11.1, run `rfbrowser init chromium` again after
  a Browser upgrade, and check supported OS dependencies or use Docker.
- Fixture startup errors: inspect the suite's `stderr.log` under the selected
  output directory. A startup failure has a bounded timeout and still runs cleanup.

See [examples](examples.md) for individual suites and optional external demos, or
[project configuration](project-guide.md#configuration) for environment overrides.
