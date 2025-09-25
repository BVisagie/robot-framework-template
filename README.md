# Robot Framework Template Repository

Welcome to the Robot Framework Template Repository! This repository provides a structured starting point for your
automated testing projects using Robot Framework and Python.

Official repository: [github.com/BVisagie/robot-framework-template](https://github.com/BVisagie/robot-framework-template)

## Table of Contents

- [Directory Structure](#directory-structure)
- [Sample Test Cases](#sample-test-cases)
- [Getting Started](#getting-started)
    - [Dependencies](#dependencies)
    - [Installing for local development](#installing-for-local-development)
    - [Quickstart Guides](#quickstart-guides)
    - [Configure the project to use a Python Virtual Environment](#configure-the-project-to-use-a-python-virtual-environment)
- [Notes and recommendations](#notes-and-recommendations)
- [Customization Options](#customization-options)
- [A word on Coding Style](#a-word-on-coding-style)
- [Authors](#authors)

## Directory Structure

The repository comes with a pre-configured directory structure to keep your project organized and to stick with
reference [Robot Framework Guidelines](https://docs.robotframework.org/docs):

```
├── .github
│   └── workflows
│       └── ci-cd.yml
├── data
│   ├── your_project
│   ├── shared_data
├── libraries
│   ├── robot_framework
│       └── common.resource
│       └── database_library.resource
│       └── requests_library.resource
│       └── web_testing_library.resource
├── resources
│   ├── common
│   ├── common_python
│   ├── your_project
│       └── your_project_keywords.resource
├── tests
│   ├── your_project
│       └── your_test_cases.robot
├── requirements.txt
├── .gitattributes
├── .gitignore
├── README.md
```

- **.github/workflows**: GitHub Actions workflows for CI/CD.
- **data**: Contains items like test data files, and other static data - like Python or Yaml Variable files and are
  organized in subfolders in the data/ folder.
- **libraries**: Stores references to libraries that might be used or referenced by various `.resource` files.
- **resources**: Stores resource files such as shared keywords and project specific keywords.
- **tests**: All test cases start here.
- **requirements.txt**: Lists all Python dependencies required for the project.

## Sample Test Cases

To help you get started, the repository includes example test cases. These examples demonstrate basic usage and can be
modified to suit your needs. They serve as a reference for creating your own test cases.

Currently, the sample test cases cover:

- Basic user interface testing using the web testing library powered by Playwright
    - This may be found in sections related to: `project_wikipedia`
- Basic API testing using the RequestsLibrary for Robot Framework
    - This may be found in sections related to: `project_json_placeholder`
- Basic Database testing using the DatabaseLibrary for Robot Framework
    - This may be found in sections related to: `project_database`
    - **Please note** that the database tests are not meant to be functional as including real database details and
      running real queries are beyond the scope of this template repository at this time.

## Getting Started

### Dependencies

* Python >= `3.13`
* Node.js >= `22`
* Robot Framework >= `7.1.1`
* Please see `requirements.txt` for all other Python and Robot Framework dependencies

### Installing for local development

For step-by-step setup on your OS (Python 3.13+, Node 22+, venv, Playwright deps, and Browser init), follow the Quickstart Guides:

- Linux: [docs/quickstart-linux.md](docs/quickstart-linux.md)
- Windows: [docs/quickstart-windows.md](docs/quickstart-windows.md)

### Quickstart commands

```sh
# Lint and format checks (Robocop v6+)
robocop check .
robocop format .

# Run API tests
robot --outputdir output tests/project_json_placeholder/api_tests

# Run UI tests (headless by default)
robot --outputdir output tests/project_wikipedia/ui_tests
```

### Quickstart Guides

- Linux: [docs/quickstart-linux.md](docs/quickstart-linux.md)
- Windows: [docs/quickstart-windows.md](docs/quickstart-windows.md)

Optional developer tooling:

```sh
# Install dev tools (pre-commit, Robocop v6+, Ruff)
pip install -r requirements-dev.txt
pre-commit install
```

### Configure the project to use a Python Virtual Environment

See the platform-specific Quickstart Guides for creating, activating, and using a virtual environment:

- Linux: [docs/quickstart-linux.md](docs/quickstart-linux.md)
- Windows: [docs/quickstart-windows.md](docs/quickstart-windows.md)

## Notes and recommendations

- IDE and plugins
  - Primary recommendation: [RobotCode](https://robotcode.io/) — multi‑IDE language server, debugger, analyzer, REPL, refactoring, profiles via `robot.toml`.
  - Alternative: [Hyper RobotFramework Support](https://plugins.jetbrains.com/plugin/16382-hyper-robotframework-support).
  - Editors: [VS Code](https://code.visualstudio.com/) or [JetBrains IDEs](https://www.jetbrains.com/pycharm/) both work well.
  - Tip: enable Robotidy/Robocop integration or use pre‑commit to keep quality consistent.
- Linting/formatting
  - [Robotidy](https://github.com/MarketSquare/robotframework-tidy) for formatting.
  - [Robocop](https://github.com/MarketSquare/robotframework-robocop) for static analysis.
  - This template includes basic configs and optional pre‑commit hooks.

## Customization Options

This template is designed to be flexible and easily extendable. You can:

- Add new test cases, resources, keywords, and variables to fit your specific requirements.
- Modify the GitHub Actions workflow to include additional steps or custom scripts.
- Update the requirements.txt file to include any additional dependencies.

### Environment variables
- `HEADLESS_BROWSER` (true/false) to control headless mode (defaults to true).
- `WIKIPEDIA_BASE_URL` to override the default Wikipedia base URL.
- Database-related variables (examples only): `DB_HOST`, `DB_PORT`, `DB_SERVICE_NAME`, `DB_USER`, `DB_PASSWORD`, `DB_API_MODULE`.

## A word on Coding Style

- Regarding Tabs or Spaces: **_four spaces are the preferred indentation method_** as set out by Python PEP 8 standards.
  If you are used to using TAB, just set TABBING to go four spaces in your IDE.
    - [Robot Framework User Guide - Space Separated Format](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#space-separated-format)
    - Official Python style guides regarding [Tabs or Spaces](https://peps.python.org/pep-0008/#tabs-or-spaces).

### RF-native first
- Prefer native Robot Framework syntax, libraries, and patterns. Use Python only when a clear gap exists.
- Examples here keep Python to a minimum (e.g., a single helper function) and showcase RF v7+ features.

### Database examples (non-functional by default)
- DB examples are placeholders, tagged to avoid accidental execution.
- You can optionally provide DB settings through environment variables and build a `&{db}` dictionary using the provided keyword.
- See the keywords in `resources/project_database/db_actions_and_verifications.resource` for details.

## Authors

* Bernard Visagie
