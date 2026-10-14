# Shared Python runtime; the last stage is the lightweight default build.
FROM python:3.15.0-slim-trixie AS base

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    HEADLESS_BROWSER=true

WORKDIR /workspace
COPY requirements.txt ./
RUN python -m pip install --no-cache-dir -r requirements.txt

COPY data ./data
COPY fixtures ./fixtures
COPY libraries ./libraries
COPY resources ./resources
COPY tests ./tests
COPY examples ./examples

ENTRYPOINT ["python", "-m", "robot", "--pythonpath", ".", "--outputdir", "/workspace/output"]
CMD ["tests/features", "tests/api", "tests/database"]

# Browser's own Playwright version installs its matching Chromium and OS dependencies.
FROM base AS ui
COPY --from=node:26.11.1-trixie-slim /usr/local/ /usr/local/
COPY requirements-ui.txt ./
RUN apt-get update \
    && apt-get install -y --no-install-recommends libatomic1 \
    && npm install --global npm@12.2.0 \
    && python -m pip install --no-cache-dir -r requirements-ui.txt \
    && rfbrowser init --with-deps chromium \
    && rm -rf /var/lib/apt/lists/*
CMD ["tests"]

# A plain `docker build .` includes only the core dependencies.
FROM base AS core
