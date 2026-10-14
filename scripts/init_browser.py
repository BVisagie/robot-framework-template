"""Initialize Chromium with the reviewed npm install-script policy for Browser."""

import argparse
import json
import os
import subprocess
import sys
from pathlib import Path

import Browser

# Browser 20.6.0 approves protobufjs 7.6.5, but its lockfile installs 7.6.6.
# This postinstall only checks the version prefixes declared by parent packages.
# npm 12's strict preflight also checks this omitted development dependency.
INSTALL_SCRIPT_POLICY = {"protobufjs@7.6.6": True, "@parcel/watcher@2.6.0": False}


def main() -> None:
    """Add the exact approval in this environment and fail on unreviewed scripts."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--with-deps", action="store_true", help="Install Linux OS libraries.")
    args = parser.parse_args()

    package_file = Path(Browser.__file__).resolve().parent / "wrapper" / "package.json"
    package = json.loads(package_file.read_text(encoding="utf-8"))
    package.setdefault("allowScripts", {}).update(INSTALL_SCRIPT_POLICY)
    package_file.write_text(json.dumps(package, indent=2) + "\n", encoding="utf-8")

    command = [sys.executable, "-m", "Browser.entry", "init"]
    if args.with_deps:
        command.append("--with-deps")
    command.append("chromium")
    environment = dict(
        os.environ,
        npm_config_strict_allow_scripts="true",
        npm_config_ignore_scripts="false",
        npm_config_dangerously_allow_all_scripts="false",
    )
    subprocess.run(command, env=environment, check=True)


if __name__ == "__main__":
    main()
