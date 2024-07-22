*** Settings ***
Documentation       This is a location for storing common web testing related configuration data.
...                 Playwright is the chosen UI automation framework https://playwright.dev/


*** Variables ***
# Playwright runs browsers in headless mode by default.
# To change this behavior,
# use headless: false as a launch option.
# https://playwright.dev/docs/debug#headed-mode
${HEADLESS_BROWSER}=             ${False}    # default = true

# The viewport is included in the device but you can override
# it for some tests with page.setViewportSize().
# https://playwright.dev/docs/emulation#viewport
${BROWSER_VIEWPORT_WIDTH}=       1920
${BROWSER_VIEWPORT_HEIGHT}=      1080

# You can also use the slowMo option
# to slow down execution (by N milliseconds per operation)
# and follow along while debugging.
# https://playwright.dev/docs/debug#headed-mode
${SLOW_MO}=                      0
