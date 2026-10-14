# Contributing

Use Python 3.15 and an active `.venv`. Install developer tools from the repository
root; core dependencies are included automatically:

```sh
python -m pip install -r requirements-dev.txt
pre-commit install
```

Add UI dependencies, Node 26.11.1, and npm 12.2.0 only when working on Browser examples.

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

The dependency baseline was checked against PyPI and official runtime/action
releases on 14 October 2026. Python 3.15.0 and Node 26.11.1 (Current) are the latest
stable runtime releases. Direct Python pins and exact GitHub Action tags use the
latest stable releases:

| Dependency | Version |
| --- | --- |
| Robot Framework | 7.5 |
| RequestsLibrary / DatabaseLibrary | 0.9.7 / 2.5.0 |
| Browser / PyYAML | 20.6.0 / 6.0.3 |
| Robocop / Ruff | 9.1.0 / 0.17.0 |
| pre-commit / Markdown | 4.7.0 / 3.11.1 |
| npm | 12.2.0 |
| actions/checkout | v7.0.1 |
| actions/setup-python | v7.0.0 |
| actions/setup-node | v7.1.0 |
| actions/upload-artifact | v7.0.2 |

Transitive dependencies must satisfy upstream constraints. Browser 20.6.0
requires protobuf 7.35.1 even though a newer protobuf release
exists; keep that required version and verify resolution with `python -m pip check`.

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
   `python scripts/init_browser.py` if its version changes. On supported Linux,
   add `--with-deps` when OS dependencies need installation. Review any newly
   unapproved install scripts before updating the initializer's exact approvals.
5. Build and run both Docker targets for runtime changes.

Update runtime pins in Docker and CI together with the documented setup versions.
Validate the complete dependency set on Ubuntu, Windows, and both Docker targets
before claiming support for a newer runtime.

[The initializer](../scripts/init_browser.py) adds only `protobufjs@7.6.6` to
Browser's shipped `allowScripts` approvals. Browser 20.6.0's lockfile resolves that
version while its policy still names 7.6.5. The reviewed postinstall checks version
prefixes; it does not download binaries. The policy also explicitly denies
`@parcel/watcher@2.6.0`, an omitted development dependency that npm 12's strict
preflight checks in the lockfile. Its install script is never enabled.
The policy is written only in the active
Python environment's Browser wrapper, and strict npm policy rejects new
unapproved scripts. CI, Docker, and the quickstarts all use this initializer.
Rerun it after an upgrade replaces the wrapper metadata. Review the new package
version and script before updating the approval; avoid approvals covering every
package or future version. See [npm's policy documentation](https://docs.npmjs.com/cli/using-npm/config/#strict-allow-scripts).
