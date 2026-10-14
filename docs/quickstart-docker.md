# Quickstart with Docker

The images run tests without installing Python or Node on the host. Install Docker
with Linux container support, then run commands from the repository root.

## Build targets

| Target | Runtime | Default run |
| --- | --- | --- |
| `core` | Python 3.15.0 and core dependencies | 21 feature/API/SQLite tests |
| `ui` | Core plus Node 26.11.1, npm 12.2.0, Browser, and Chromium with matching OS libraries | All 25 local tests |

```sh
docker build --target core -t rf-template:core .
docker build --target ui -t rf-template:ui .
```

A build without `--target` also produces the core image. The runtime uses
`python:3.15.0-slim-trixie`; the UI stage copies Node from `node:26.11.1-trixie-slim`.
Both use Debian 13. The UI stage also installs Node's required `libatomic` library
and npm 12.2.0 before initializing Browser.
The runtime tags pin the tested Python and Node releases. CI builds and runs
both targets. The build context excludes environments, editor files,
Git metadata, and generated artifacts through `.dockerignore`.

## Run

```sh
docker run --rm rf-template:core
docker run --rm rf-template:ui
```

No external test service is needed. Each suite starts its fixture inside the
container. The UI runs headless.

The entrypoint already supplies `python -m robot --pythonpath . --outputdir
/workspace/output`. Pass Robot options and suite paths as command arguments:

```sh
docker run --rm rf-template:core tests/api
docker run --rm rf-template:ui tests/ui
docker run --rm rf-template:core --loglevel TRACE tests/features
```

Supplying arguments replaces the default suite list, so include the desired paths.
To execute a different program, explicitly override `--entrypoint`.

## Keep reports on the host

Mount only the result directory. Bash:

```sh
mkdir -p output/docker-core output/docker-ui
docker run --rm -v "${PWD}/output/docker-core:/workspace/output" rf-template:core
docker run --rm -v "${PWD}/output/docker-ui:/workspace/output" rf-template:ui
```

PowerShell with Docker Desktop in Linux-container mode:

```powershell
New-Item -ItemType Directory -Force output/docker-core, output/docker-ui | Out-Null
docker run --rm -v "${PWD}/output/docker-core:/workspace/output" rf-template:core
docker run --rm -v "${PWD}/output/docker-ui:/workspace/output" rf-template:ui
```

Open the mounted directory's `report.html` or `log.html` after execution.
On Linux the default container user may create root-owned files; use a Docker
volume or adjust the ownership of your result directory if your local workflow needs it.

## Troubleshooting

- A Browser import error in the core image means you selected a UI suite; use
  `rf-template:ui`.
- Browser launch problems after dependency changes: rebuild the UI target, which
  initializes the browser using Browser's own Playwright version.
- Check the mounted `fixtures/` stderr logs for fixture startup failures.
- Docker uses the selected image's copied source. Rebuild after editing tests;
  no full-workspace bind mount is needed to preserve reports.

See [examples](examples.md) for the scenario list and
[contributing](contributing.md) for checks run outside these runtime images.
