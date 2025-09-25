# Minimal container for running Robot Framework tests (API + headless UI)
FROM mcr.microsoft.com/devcontainers/python:3.13

# Install Node and Playwright deps
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/* \
    && curl -fsSL https://deb.nodesource.com/setup_22.x | bash - \
    && apt-get update && apt-get install -y nodejs \
    && npm -g i npm

WORKDIR /workspace
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt \
    && rfbrowser init

COPY . .

# Default vars
ENV HEADLESS_BROWSER=true

CMD ["bash", "-lc", "robot --outputdir output tests/project_json_placeholder/api_tests"]

