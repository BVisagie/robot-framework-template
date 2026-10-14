"""Fail if the feature examples disclose their dummy secret values in Robot artifacts."""

import argparse
import os
from pathlib import Path


def main() -> None:
    """Inspect TRACE-level artifacts without printing the values being checked."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("directory", type=Path)
    args = parser.parse_args()
    artifacts = [
        path
        for path in args.directory.rglob("*")
        if path.suffix in {".xml", ".json", ".html"} and path.is_file()
    ]
    if not artifacts:
        raise SystemExit("No Robot execution artifacts found to inspect.")
    sentinels = [
        os.environ.get("RF_DEMO_TOKEN", "template-demo-token"),
        os.environ.get("RF_INVALID_DEMO_TOKEN", "incorrect-demo-token"),
    ]
    for path in artifacts:
        text = path.read_text(encoding="utf-8")
        if any(value and value in text for value in sentinels):
            raise SystemExit(f"A dummy secret was disclosed in {path}.")
    print(f"Checked {len(artifacts)} execution artifacts: dummy secrets remain masked.")


if __name__ == "__main__":
    main()
