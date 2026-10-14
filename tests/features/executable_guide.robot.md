# An executable Robot Framework 7.5 guide

Robot Framework 7.5 discovers `.robot.md` files while executing a directory.
It executes only fenced `robotframework` blocks; surrounding prose documents the
scenario. This guide is part of the ordinary feature suite and needs no browser.

```robotframework
*** Settings ***
Documentation    A passing example embedded in Markdown, introduced in Robot Framework 7.5.
Library          libraries/example_library.py
Test Tags        features    local

*** Test Cases ***
An arriving shipment increases the stock quantity
    [Documentation]    Convert typed data and report this example's scenario reference.
    [Metadata]    Scenario    markdown-stock-example
    VAR    ${quantity: int}    5
    ${updated}    Calculate stock quantity    ${quantity}    shipment=2
    Should Be Equal As Integers    ${updated}    7
```

Run just this file from the repository root:

```sh
python -m robot --pythonpath . --outputdir output/markdown tests/features/executable_guide.robot.md
```

Ordinary `.md` documentation is not discovered by the default test command. Use
`.robot.md` only for documentation intended to run as a suite.
