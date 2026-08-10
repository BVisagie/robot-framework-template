*** Settings ***
Documentation       The purpose of this file is to be an index of all page object resource files. Please note that this
...                 file is not designed for performance reasons, but rather overall project convenience as you will
...                 have less files to import or reference when creating your keyword functionality.

Resource            resources/project_wikipedia/page_objects/landing_page.resource
Resource            resources/project_wikipedia/page_objects/main_page.resource
Resource            resources/project_wikipedia/page_objects/wiki_page.resource


*** Variables ***
# Override with WIKIPEDIA_BASE_URL env var; falls back to the public Wikipedia homepage.
${WIKIPEDIA_BASE_URL}=      %{WIKIPEDIA_BASE_URL=https://www.wikipedia.org/}
