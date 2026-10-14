# Robot Framework template

A starter project for **Robot Framework 7.5**, with runnable API, SQLite, and
Browser examples. The main tests use a disposable local catalog application.
No public website, database server, or credentials are needed to run them.

Use [this repository](https://github.com/BVisagie/robot-framework-template) as a
GitHub template, or clone it to explore the examples.

## Start with the Python-only examples

The tested Python release is **3.15.0**, the latest stable release at the dependency
refresh on 14 October 2026. From the repository root on Linux:

```sh
python3.15 -m venv .venv
source .venv/bin/activate
python -m pip install -r requirements.txt
python -m robot --pythonpath . --outputdir output/core tests/features tests/api tests/database
```

The core run executes 21 tests, including a Markdown suite, HTTP error cases,
database transactions, and fixture cleanup. Open `output/core/log.html` for
details or `output/core/report.html` for the result summary.

Follow the [Linux](docs/quickstart-linux.md), [Windows](docs/quickstart-windows.md),
or [Docker](docs/quickstart-docker.md) guide for platform setup.

## Add browser testing

UI tests additionally need **Node.js 26.11.1** (Current) and the optional Browser dependencies:

```sh
python -m pip install -r requirements-ui.txt
rfbrowser init chromium
python -m robot --pythonpath . --outputdir output/ui tests/ui
```

On supported Linux distributions, use `rfbrowser init --with-deps chromium` to
install the matching OS libraries as well. The [Linux guide](docs/quickstart-linux.md)
explains the supported path and Docker alternative.

After UI setup, run all 25 local examples with:

```sh
python -m robot --pythonpath . --outputdir output/all tests
```

Browsers run headless by default. Use
`--variable HEADLESS_BROWSER:false` before the suite path for a visible browser.

## What the examples teach

| Area | Examples |
| --- | --- |
| Modern Robot syntax | `VAR`, `GROUP`, typed variables/arguments, Secrets, 7.5 test metadata, and executable Markdown |
| API | Sessions, deterministic YAML data, CRUD, filtering, validation errors, and concrete response assertions |
| Database | Working SQLite connections, bound SQL parameters, updates/deletes, and rollback |
| UI | A small page resource, stable selectors, form submission, fresh contexts, and assertions that wait |
| Journey | Create through the API, find the item in the UI, verify SQLite, and clean up in `FINALLY` |
| Python extension | Type alias conversion and Markdown/Google-style keyword documentation for Libdoc |

The [example guide](docs/examples.md) maps features to their introduction versions
and links to the executable source files. Wikipedia and JSONPlaceholder remain
[optional public-service demos](docs/examples.md#optional-public-service-demos)
under `examples/external/`, outside default test discovery and required CI.

## Project layout

```text
data/           Shared YAML seed records and test cases
examples/       Explicitly selected public-service demos
fixtures/       Small local HTTP/SQLite application and HTML page
libraries/      Actual Python extension keywords
resources/      Fixture lifecycle, domain keywords, and page interactions
tests/          features/, api/, database/, and ui/ suites
scripts/        Documentation and secret-artifact checks
docs/           Platform quickstarts and project guidance
```

`requirements.txt` contains the core runtime. `requirements-ui.txt` adds Browser;
`requirements-dev.txt` adds development tools and Markdown for Libdoc. The direct
dependencies are pinned. Node and browser downloads are unnecessary for core tests.

Imports use root-relative paths and `--pythonpath .`. See the
[project guide](docs/project-guide.md) for configuration, adding tests, adapting
the fixture, and optional editor setup.

## Development and CI

```sh
python -m pip install -r requirements-dev.txt
robocop check .
robocop format --check .
ruff check .
ruff format --check .
python scripts/check_docs.py
```

CI runs the core examples on Ubuntu and Windows, the local UI/journey on Ubuntu,
and both Docker targets. It also checks TRACE-level secret masking and generates
Libdoc documentation. See [contributing](docs/contributing.md) for pre-commit,
formatting, dependency updates, and the full validation commands.

## License and author

[MIT](LICENSE), Bernard Visagie.
