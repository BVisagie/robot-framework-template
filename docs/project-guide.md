# Project guide

The template keeps Robot test cases, reusable Robot resources, fixture code, data,
and Python extension keywords in separate directories with direct imports.

## Where files belong

| Directory or file | Purpose |
| --- | --- |
| `tests/` | Runnable local examples grouped by feature or interface |
| `resources/catalog/` | Domain actions and assertions reused by suites |
| `resources/catalog/pages/` | Page selectors and UI interactions |
| `resources/common/fixture.resource` | Shared local fixture startup/reset/cleanup |
| `data/catalog.yaml` | Shared seed records, search cases, and invalid payloads |
| `fixtures/` | The minimal application under test and its HTML page |
| `libraries/example_library.py` | Actual Python extension keywords, explicitly exposed with decorators |
| `examples/external/` | Optional demonstrations that contact public services |
| `scripts/` | Small documentation and artifact validation commands |
| `pyproject.toml` | Robocop and Ruff configuration |
| `.editorconfig`, `.gitattributes` | Editor-independent spacing and text line endings |

Import a library where it is used instead of creating a resource whose only job
is importing it. BuiltIn is automatically available. Import page resources
directly; a separate index adds little to a small template.

Root-relative imports such as `Resource    resources/catalog/api.resource` rely
on running Robot from the project root with `--pythonpath .`.

## Add a new scenario

1. Put the test in the appropriate directory under `tests/`.
2. Write domain keywords in `resources/` when an action is reused or makes the
   scenario clearer. Call simple standard-library keywords directly.
3. Import libraries, resources, and variable files explicitly. Keep target-specific
   actions out of shared lifecycle resources.
4. Use deterministic input and assert specific outcomes. Use templates or data
   rows when they clarify meaningful variants.
5. Add setup/teardown so the test can run alone or with the other tests. Keep waits
   bounded and prefer Browser assertions over fixed sleeps.
6. Assign useful selection tags and, where helpful, 7.5 metadata. Update
   [the examples guide](examples.md) and run [the checks](contributing.md).

A `.robot.md` file belongs under `tests/` only if it is intended to execute.
Ordinary `.md` guides remain under `docs/`.

## Configuration

Public settings follow Robot CLI override, environment override, then the default.
The Browser resource converts headless input to a typed boolean before use.

| Robot CLI variable / environment name | Default | Accepted use |
| --- | --- | --- |
| `HEADLESS_BROWSER` | `true` | `true` or `false`; local and Wikipedia UI |
| `JSONPLACEHOLDER_BASE_URL` | `https://jsonplaceholder.typicode.com` | Base URL for the optional JSONPlaceholder demo |
| `WIKIPEDIA_BASE_URL` | `https://en.wikipedia.org/wiki/Main_Page` | English Wikipedia-compatible page for the optional UI demo |

Bash environment override:

```sh
export HEADLESS_BROWSER=true
```

PowerShell environment override:

```powershell
$env:HEADLESS_BROWSER = "true"
```

CLI override, which wins over that environment value:

```sh
python -m robot --pythonpath . --outputdir output/ui --variable HEADLESS_BROWSER:false tests/ui
```

Fixture `CATALOG_URL`, `CATALOG_DB`, and process handles are suite-owned outputs of
startup, not user configuration. Every default run creates its own data and port.
To test a different application, replace the lifecycle resource and domain
keywords rather than changing one URL while keeping an unrelated local database.

The Secret feature uses `RF_DEMO_TOKEN` and `RF_INVALID_DEMO_TOKEN` from the
environment, defaulting to `template-demo-token` and `incorrect-demo-token`.
These are illustrative values; the passing feature scenario expects the former
to be accepted and the latter rejected. Leave them unset for ordinary runs.

## Adapt database testing

The runnable template uses SQLite, which ships with Python. For a real database,
install only its driver, provide connection details to DatabaseLibrary, and keep
the same domain assertions with the driver's parameter-binding syntax.
SQLite's `?` placeholder is not universal across database drivers.

Keep credentials in environment-backed Secret variables and consume them inside
an appropriate client boundary. Verify that the selected client supports that
boundary without disclosing credentials; do not interpolate passwords into
Robot expressions or custom connection strings. The template does not install
Oracle or PostgreSQL drivers or contain fake connection settings.

## Coding style and optional editor setup

Use four spaces between Robot cells and for keyword indentation. Python uses four
spaces; YAML/HTML use two. Robot keywords use sentence case and variables use
snake_case. Returned-value assignments omit the optional `=`. The shared tooling
configuration enforces this style.

Prefer native Robot syntax and standard libraries. Python extensions are useful
for an actual integration boundary or domain calculation; the
[example library](../libraries/example_library.py) demonstrates explicit keywords,
type aliases, and documented arguments/returns/errors.

Any editor can be used. For VS Code, optional local setup includes
[RobotCode](https://robotcode.io/) and Ruff. Select `.venv` as the Python environment
and configure root-relative imports locally if needed:

```json
{
  "robotcode.robot.pythonPath": ["."],
  "[robotframework]": {
    "editor.defaultFormatter": "d-biehl.robotcode",
    "editor.tabSize": 4,
    "editor.insertSpaces": true
  }
}
```

Save personal settings under `.vscode/`, which is ignored. Use the command-line
Robocop formatter or pre-commit for the project's canonical formatting.
