# Minimal container for running Robot Framework tests (API + headless UI)
FROM mcr.microsoft.com/devcontainers/python:3.13

# Build-time toggle to include dev tools inside the image (pre-commit, robocop, ruff)
ARG INSTALL_DEV=false

# Reasonable Python defaults for containers
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1

# Install Node and Playwright deps
RUN apt-get update \
    && apt-get install -y --no-install-recommends curl \
    && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update \
    && apt-get install -y --no-install-recommends nodejs \
    && npm -g i npm \
    # Install Playwright system dependencies (needed for RF Browser in Linux)
    && npx playwright install-deps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

# Install Python dependencies first for better layer caching
COPY requirements*.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && if [ "$INSTALL_DEV" = "true" ]; then pip install --no-cache-dir -r requirements-dev.txt; fi \
    # Download browser engines for Robot Framework Browser
    && rfbrowser init

COPY . .

# Default vars
ENV HEADLESS_BROWSER=true

CMD ["bash", "-lc", "robot --outputdir output tests/project_json_placeholder/api_tests"]

