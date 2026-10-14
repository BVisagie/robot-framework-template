# Contributing

Use Python 3.14 and an active `.venv`. Install developer tools from the repository
root; core dependencies are included automatically:

```sh
python -m pip install -r requirements-dev.txt
pre-commit install
```

Add UI dependencies and Node 24 only when working on Browser examples.

## Read-only checks

```sh
robocop check .
robocop format --check .
ruff check .
ruff format --check .
python scripts/check_docs.py
python -m pip check
```

Robocop checks `.robot` and `.resource` files. The `.robot.md` example is parsed
and executed by the core Robot run; the prose around it is preserved. The
documentation checker validates local file links and headings, without making
external HTTP requests.

To apply formatting or safe lint fixes:

```sh
robocop format .
ruff check --fix .
ruff format .
```

The optional pre-commit hooks run the same Robocop/Ruff versions and may edit
files. Stage the changes, then check all tracked files with:

```sh
pre-commit run --all-files
```

Robocop's naming exceptions reflect the sentence-case keyword and snake_case
variable style. Its suite-variable exception is limited to the fixture resource,
which must keep handles available to setup and teardown.

## Test commands

Core examples, with no Node or Browser requirement:

```sh
python -m robot --pythonpath . --loglevel TRACE --outputdir output/core --xunit xunit.xml tests/features tests/api tests/database
```

After optional UI setup:

```sh
python -m robot --pythonpath . --outputdir output/ui tests/ui
python -m robot --pythonpath . --outputdir output/all tests
```

Only `tests/` participates in default discovery. External demos require explicit
paths and are never used to gate a PR. Keep local examples deterministic and
independently runnable; include an expected failure response when it demonstrates
real behavior rather than adding an unrelated example.

## Execution artifacts and secret checks

Robot creates `output.xml`, `log.html`, and `report.html` in the selected directory.
The core CI command additionally produces `xunit.xml`. Fixture logs live below
that directory's `fixtures/` folder. All generated output stays ignored.

Robot 7.5 lets Rebot configure its console logger. JSON output can be produced
from the same run without another test execution:

```sh
python -m robot.rebot --console dotted --output output/core/results.json --log NONE --report NONE output/core/output.xml
python scripts/check_secret_artifacts.py output/core
```

Run the Secret feature at TRACE level, as the core command does. The checker
looks for both dummy sentinel values in XML, JSON, and HTML artifacts, including
the controlled rejection path. It fails when no artifacts exist so a missing
test run cannot pass silently. It prints file locations, not secret values.

## Generate keyword documentation

The developer requirements include Python-Markdown, needed to render Markdown
keyword documentation as HTML. Generate HTML and the 7.5 Markdown output format:

```sh
python -m robot.libdoc libraries/example_library.py output/libdoc/example_library.html
python -m robot.libdoc libraries/example_library.py output/libdoc/example_library.md
```

Libdoc creates the output directory. The extension declares its documentation
format explicitly and uses Google-style Args, Returns, and Raises sections.
Generated docs are CI artifacts and are not committed to the template.

## CI and dependency changes

The workflow checks lint/formatting, local documentation links, and Libdoc;
executes the core suite on Ubuntu 24.04 and Windows Server 2025; executes the UI
and journey on Ubuntu; and builds/runs the core and UI Docker targets.
Artifacts upload even after a test failure. The optional manual public-demo job
does not run on push or pull-request events.

Direct dependency versions are pinned in the three requirements files. Transitive
dependencies are resolved by pip. When updating a dependency:

1. Resolve/install it in a fresh environment, and run `python -m pip check`.
2. Align developer-tool versions with `.pre-commit-config.yaml` and test the hooks.
3. Run the appropriate core/UI checks and update documentation for behavior changes.
4. Reinitialize Browser with `rfbrowser clean-node` followed by
   `rfbrowser init chromium` if its version changes. On supported Linux, use
   `rfbrowser init --with-deps chromium` when OS dependencies need installation.
5. Build and run both Docker targets for runtime changes.

Keep Python 3.14 and Node 24 as the documented/tested lines until the complete
dependency set and CI cover another line. Robot Framework's support for another
Python version alone does not establish support for this project's other tools.
