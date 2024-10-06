# Robot Framework Template Repository

Welcome to the Robot Framework Template Repository! This repository provides a structured starting point for your
automated testing projects using Robot Framework and Python.

## Table of Contents

- [Directory Structure](#directory-structure)
- [Sample Test Cases](#sample-test-cases)
- [Getting Started](#getting-started)
    - [Dependencies](#dependencies)
    - [Installing for local development](#installing-for-local-development)
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

* Python >= `3.12`
* Node.js >= `22`
* Robot Framework >= `7.0.1`
* Please see `requirements.txt` for all other Python and Robot Framework dependencies

### Installing for local development

1. Install Python >= `3.12`: [Python.org -> Downloads](https://www.python.org/downloads/)
2. Install Node.js >= `22`: [Node.js -> Downloads](https://nodejs.org/en) (required to allow UI automation
   using [Playwright](https://playwright.dev/))
    1. If you are running a Python Virtual Environment in Linux, you will need something
       like: [Node.js virtual environment](https://pypi.org/project/nodeenv/)
        1. `pip install nodeenv`
        2. `npm install -g npm`
3. Restore all other Python dependencies within: [requirements.txt](requirements.txt)
    1. `pip install -r requirements.txt`
4. When running Python virtual environment you might need to set your Python language server to the correct
   `python.exe`, this should match your Python Virtual environment.
    1. For additional information on **IntelliJ Python**
       see [this link](https://www.jetbrains.com/help/idea/configuring-python-sdk.html#b631bcd6_38).
    2. For **Visual Studio code**, ensure that the following line is added to your `settings.json` file example:
        1. `"robot.language-server.python": "C:\\python312_virtual_env\\Scripts\\python.exe"`
5. Run: `rfbrowser init` to initialize your browser dependency libraries.

### Configure the project to use a Python Virtual Environment

Using a Python virtual environment (venv) is **recommended on Linux**. The simplest way to set this up, is to place the
virtual environment inside the project directory, following these steps:

1. **Navigate to the project directory**:
    ```sh
    cd /path/to/your/project
    ```

2. **Create a virtual environment**:
    ```sh
    python3 -m venv venv
    ```

3. **Activate the virtual environment**:
    ```sh
    source venv/bin/activate
    ```

4. **Update pip**:
    ```sh
    pip install --upgrade pip
    ```

5. **Install the required dependencies**:
    ```sh
    pip install -r requirements.txt
    ```

6. **(Optional - only needed for UI testing) Setup Node.js**:
    - Install curl: `sudo apt-get install curl`
    - Follow the steps published by Node.js [here](https://nodejs.org/en/download/package-manager).


7. **(Optional - only needed for UI testing) Install dependencies to run browsers**:
    ```sh
    sudo npx playwright install-deps
    ```

8. **(Optional) Deactivating the virtual environment**:
   When you are done working on the project, you can deactivate the virtual environment by running:
    ```sh
    deactivate
    ```

9. **(Optional) Deactivating the virtual environment**:
   When you are done working on the project, you can deactivate the virtual environment by running:
    ```sh
    deactivate
    ```

## Notes and recommendations

- If you do not yet have any preference in regard to which IDE and Plugin combination to use, I would strongly
  recommend: [IntelliJ IDEA](https://www.jetbrains.com/idea/) or [PyCharm](https://www.jetbrains.com/pycharm/) from
  JetBrains as an **IDE** and
  the [Hyper RobotFramework Support](https://plugins.jetbrains.com/plugin/16382-hyper-robotframework-support) **plugin**
  for Robot Framework development.
- Other utilities worth considering: [RoboTidy](https://github.com/MarketSquare/robotframework-tidy) is a tool for
  autoformatting Robot Framework code, [RoboCop](https://github.com/MarketSquare/robotframework-robocop) is a tool for
  static code analysis of Robot Framework language

## Customization Options

This template is designed to be flexible and easily extendable. You can:

- Add new test cases, resources, keywords, and variables to fit your specific requirements.
- Modify the GitHub Actions workflow to include additional steps or custom scripts.
- Update the requirements.txt file to include any additional dependencies.

## A word on Coding Style

- Regarding Tabs or Spaces: **_four spaces are the preferred indentation method_** as set out by Python PEP 8 standards.
  If you are used to using TAB, just set TABBING to go four spaces in your IDE.
    - [Robot Framework User Guide - Space Separated Format](https://robotframework.org/robotframework/latest/RobotFrameworkUserGuide.html#space-separated-format)
    - Official Python style guides regarding [Tabs or Spaces](https://peps.python.org/pep-0008/#tabs-or-spaces).

## Authors

* Bernard Visagie
