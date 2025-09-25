*** Settings ***
Documentation       The purpose of this file is to be an index of all page object resource files. Please note that this
...                 file is not designed for performance reasons, but rather overall project convenience as you will
...                 have less files to import or reference when creating your keyword functionality.


*** Variables ***
# Base URL for Wikipedia landing page
${WIKIPEDIA_BASE_URL}=              https://www.wikipedia.org/
# Optional environment override. If set, tests can use this instead of the default.
${WIKIPEDIA_BASE_URL_OVERRIDE}=     %{WIKIPEDIA_BASE_URL}

Resource                            landing_page.resource
Resource                            main_page.resource
Resource                            wiki_page.resource
