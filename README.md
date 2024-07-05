# Robot Framework Template Repository

Welcome to the Robot Framework Template Repository! This repository provides a structured starting point for your automated testing projects using Robot Framework and Python.

## Table of Contents

- [Directory Structure](#directory-structure)
- [Sample Test Cases](#sample-test-cases)
- [CI/CD Integration](#cicd-integration)
- [Getting Started](#getting-started)
- [Customization Options](#customization-options)
- [A word on Coding Style](#a-word-on-coding-style)
- [Authors](#authors)

## Directory Structure

The repository comes with a pre-configured directory structure to keep your project organized and to stick with reference [Robot Framework Guidelines](https://docs.robotframework.org/docs):

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
- **data**: Contains items like test data files, and other static data - like Python or Yaml Variable files and are organized in subfolders in the data/ folder.
- **libraries**: Stores references to libraries that might be used or referenced by various `.resource` files.
- **resources**: Stores resource files such as shared keywords and project specific keywords.
- **tests**: All test cases start here.
- **requirements.txt**: Lists all Python dependencies required for the project.

## Sample Test Cases

To help you get started, the repository includes example test cases. These examples demonstrate basic usage and can be modified to suit your needs. They serve as a reference for creating your own test cases.

Currently, the sample test cases cover:
- Basic user interface testing using the web testing library powered by Playwright
  - This may be found in sections related to: `project_wikipedia`
- Basic API testing using the RequestsLibrary for Robot Framework
  - This may be found in sections related to: `project_json_placeholder`
- Basic Database testing using the DatabaseLibrary for Robot Framework
    - This may be found in sections related to: `db_tests`
    - **Please note** that the database tests are not meant to be functional as including real database details and running real queries are beyond the scope of this template repository at this time.

## CI/CD Integration
### :building_construction: Currently under construction. :construction:

## Getting Started
### Dependencies
* Python >= 3.12
* Robot Framework >= 7.0.1
* Please see `requirements.txt` for all other Python and Robot Framework dependencies

### Installing for local development

1. Install Python >= 3.12: [Python.org -> Downloads](https://www.python.org/downloads/)
2. Restore all other Python dependencies within: [requirements.txt](requirements.txt)
   1. ``pip install -r requirements.txt`` 
3. When running Python virtual environment you might need to set your Python language server to the correct `python.exe`, this should match your Python Virtual environment.
    1. For additional information on **IntelliJ Python** see [this link](https://www.jetbrains.com/help/idea/configuring-python-sdk.html#b631bcd6_38).
    2. For **Visual Studio code**, ensure that the following line is added to your `settings.json` file example:
        1. `"robot.language-server.python": "C:\\python312_virtual_env\\Scripts\\python.exe"`
4. Run: `rfbrowser init` to initialize your browser dependency libraries.

### Special note on Zscaler on Windows environments

_If you encounter any errors when trying to install packages, open **Zscaler** and turn it off._

## Customization Options
This template is designed to be flexible and easily extendable. You can:

- Add new test cases, resources, keywords, and variables to fit your specific requirements.
- Modify the GitHub Actions workflow to include additional steps or custom scripts.
- Update the requirements.txt file to include any additional dependencies.

## A word on Coding Style
- Regarding Tabs or Spaces: **_two spaces are the preferred indentation method_** as set out by Python standards. If you are used to using TAB, just set TABBING to go two spaces in your IDE.
    - Official Python style guides regarding [Tabs or Spaces](https://peps.python.org/pep-0008/#tabs-or-spaces).

## Authors

* Bernard Visagie
