# Quickstart (Docker)

This guide shows how to build and run the template’s Docker image to execute Robot Framework tests without installing Python/Node locally.

## Image overview
- Base: `mcr.microsoft.com/devcontainers/python:3.13`
- Installs Node.js 22, Playwright system dependencies, and project Python dependencies
- Initializes Robot Framework Browser (`rfbrowser init`)
- Build arg `INSTALL_DEV` controls whether dev tools (pre-commit, Robocop, Ruff) are installed

## Build

Build minimal runtime (no dev tools):
```sh
docker build --build-arg INSTALL_DEV=false -t rf-template:runtime .
```

Build developer image (includes dev tools from `requirements-dev.txt`):
```sh
docker build --build-arg INSTALL_DEV=true -t rf-template:dev .
```

## Run

The image defaults to running the sample API tests:
```sh
docker run --rm -e HEADLESS_BROWSER=true rf-template:runtime
```

Run the developer image similarly:
```sh
docker run --rm -e HEADLESS_BROWSER=true rf-template:dev
```

Override the command to run a different suite (e.g., UI tests):
```sh
docker run --rm -e HEADLESS_BROWSER=true rf-template:runtime \
  robot --outputdir output tests/project_wikipedia/ui_tests
```

Mount your local workspace (optional) to persist outputs to the host:
```sh
docker run --rm -e HEADLESS_BROWSER=true \
  -v "$(pwd)":/workspace \
  rf-template:runtime \
  robot --outputdir /workspace/output tests/project_json_placeholder/api_tests
```

## Environment variables
- `HEADLESS_BROWSER` (true/false, default true)
- `WIKIPEDIA_BASE_URL` (override default `https://www.wikipedia.org/`)

Example:
```sh
export HEADLESS_BROWSER=true
export WIKIPEDIA_BASE_URL=https://www.wikipedia.org/
```

## Troubleshooting
- If browsers fail to launch, rebuild the image to re-run `rfbrowser init` and Playwright deps.
- If you built only `rf-template:dev`, run that tag instead of `rf-template:runtime` (or build both).
