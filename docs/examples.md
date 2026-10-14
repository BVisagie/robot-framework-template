# Example guide

All commands below run from the repository root with the venv active and
`--pythonpath .`. The main suites use local fixtures. Install dependencies first
using the [Linux](quickstart-linux.md), [Windows](quickstart-windows.md), or
[Docker](quickstart-docker.md) guide.

## Local scenarios

| Suite | What it demonstrates | Dependencies |
| --- | --- | --- |
| [API catalog](../tests/api/catalog.robot) | Seeded responses, filters, create/update/delete, missing IDs, malformed JSON, invalid data, and quotes in names | Core |
| [Database catalog](../tests/database/catalog.robot) | DatabaseLibrary with SQLite, bound query parameters, concrete row checks, and rollback | Core |
| [Modern syntax](../tests/features/modern_syntax.robot) | Typed variables/user keywords, YAML, GROUP, metadata, Python aliases, exception handling, and Secrets | Core |
| [Executable Markdown](../tests/features/executable_guide.robot.md) | A 7.5 suite embedded in prose | Core |
| [Fixture lifecycle](../tests/features/fixture_lifecycle.robot) | Process and database cleanup, including failed startup | Core |
| [UI catalog](../tests/ui/catalog.robot) | Filter, create, literal text rendering, fresh contexts, and assertions that wait | UI |
| [Catalog journey](../tests/ui/catalog_journey.robot) | API creation, UI verification, SQLite assertion, and FINALLY cleanup | UI |

Run core examples:

```sh
python -m robot --pythonpath . --outputdir output/core tests/features tests/api tests/database
```

Run one area by replacing the paths with `tests/api`, `tests/database`, or
`tests/features`. After installing UI dependencies, run `tests/ui` or all of `tests`.
The core run has 21 tests; the UI run has four.

Tags are `features`, `api`, `database`, `ui`, `journey`, and `local`. For example:

```sh
python -m robot --pythonpath . --outputdir output/journey --include journey tests/ui
```

Metadata records feature/scenario/requirement references in the log. Tags select
tests. Use explicit Boolean operators for tag expressions, for example
`--include "local AND api"`.

## Robot Framework feature versions

| Introduced | Feature | Source |
| --- | --- | --- |
| 7.0 | `VAR` and intentional variable scope | [Fixture lifecycle resource](../resources/common/fixture.resource) |
| 7.2 | Named `GROUP` blocks | [Modern syntax suite](../tests/features/modern_syntax.robot) |
| 7.3 | Typed variables, typed lists/dictionaries, and typed user-keyword arguments | [Modern syntax suite](../tests/features/modern_syntax.robot) and [API keywords](../resources/catalog/api.resource) |
| 7.4 | Environment-backed `Secret` variables | [Modern syntax suite](../tests/features/modern_syntax.robot) and [Python boundary](../libraries/example_library.py) |
| 7.5 | Test `[Metadata]` | [API suite](../tests/api/catalog.robot) and [journey](../tests/ui/catalog_journey.robot) |
| 7.5 | `.robot.md` execution | [Executable guide](../tests/features/executable_guide.robot.md) |
| 7.5 | Python `type` alias conversion, Markdown/Google-style Libdoc docs, and Markdown output | [Extension library](../libraries/example_library.py) |
| 7.5 | Rebot `--console` support | [Result processing commands](contributing.md#execution-artifacts-and-secret-checks) |

See the official [7.0](https://github.com/robotframework/robotframework/blob/v7.0/doc/releasenotes/rf-7.0.rst),
[7.2](https://github.com/robotframework/robotframework/blob/v7.2/doc/releasenotes/rf-7.2.rst),
[7.3](https://github.com/robotframework/robotframework/blob/v7.3/doc/releasenotes/rf-7.3.rst),
[7.4](https://github.com/robotframework/robotframework/blob/v7.4/doc/releasenotes/rf-7.4.rst),
and [7.5](https://github.com/robotframework/robotframework/blob/v7.5/doc/releasenotes/rf-7.5.rst)
release notes for details. Native `TRY` and `RETURN` were introduced in
[5.0](https://github.com/robotframework/robotframework/blob/v5.0/doc/releasenotes/rf-5.0.rst).
YAML variable files are also older than 7.x.

Use GROUP to make a short section visible in the log; use keywords for reusable
behavior. Keep variable scope local unless a lifecycle resource must share suite
handles. The one scoped lint exception is explained in `pyproject.toml`.

## Fixture and test isolation

[The fixture resource](../resources/common/fixture.resource) starts
[the catalog application](../fixtures/catalog_app.py) using the same Python
interpreter as Robot. It selects an available loopback port and creates a temporary
database from [the shared YAML seed](../data/catalog.yaml).

Readiness is checked through an atomic JSON startup record and `/health`, with a
bounded retry. Each API, database, or UI suite owns its fixture. Each test resets
the seed. UI tests additionally create a new Browser context and close it during
teardown. Database and Browser teardown use FINALLY so fixture cleanup is still
attempted if another cleanup step fails.

Fixture logs stay under the run's `fixtures/` output directory; the temporary
database is removed. The journey uses one fixture instance for all three layers.
Its created item is deleted in FINALLY, and suite teardown removes any remaining
state even if the scenario fails earlier.

The database example connects using DatabaseLibrary's `sqlite3` driver. SQL uses
`?` placeholders with `parameters=${parameters}`. DatabaseLibrary normally commits
successful operations; the rollback scenario uses `no_transaction=${True}` to
control the transaction explicitly. See the
[DatabaseLibrary guidance](https://github.com/MarketSquare/Robotframework-Database-Library#commit-behavior)
for details.

## Secret example

The feature suite reads dummy tokens from environment variables into Secret
variables. Defaults are declared in the Variables table. The Python keyword
accepts a `Secret`, checks it internally, and returns no credential value. Its
failure message also omits the value.

Use the provided fake defaults for these examples. Do not unwrap a Secret with
`${token.value}` or `Evaluate` in Robot steps: returned ordinary values can be
logged. A Secret does not prevent an external client from logging values it receives.
Even a Secret VAR declaration can retain the original expression in execution
artifacts, so avoid putting a literal credential in its source expression.

[The artifact checker](../scripts/check_secret_artifacts.py) checks both the accepted
and rejected dummy tokens in TRACE-level output. See
[the validation commands](contributing.md#execution-artifacts-and-secret-checks).

## Optional public-service demos

These suites live under `examples/external/`, so `robot tests` never discovers
them. They require internet access and may fail if a public site changes or is
unavailable. Required PR jobs do not run them.

JSONPlaceholder, core dependencies only:

```sh
python -m robot --pythonpath . --outputdir output/external-api examples/external/jsonplaceholder
```

[The JSONPlaceholder suite](../examples/external/jsonplaceholder/posts.robot)
uses a fixed post ID and checks that each comment belongs to that post. Writes
to JSONPlaceholder are simulated and do not persist, so the persistent CRUD
example uses the local application.

Wikipedia, UI dependencies required:

```sh
python -m robot --pythonpath . --outputdir output/external-ui examples/external/wikipedia
```

[The Wikipedia suite](../examples/external/wikipedia/search.robot) searches the
English site and checks the article heading, then closes Browser. URLs and
headless mode can be overridden through [configuration](project-guide.md#configuration).

The CI workflow's manual **Run workflow** form optionally selects one of these
demos. Leave `external_demo` set to `none` for the normal local checks.
