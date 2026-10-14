"""Check local Markdown links and heading anchors without contacting external sites."""

import re
from pathlib import Path
from urllib.parse import unquote, urlsplit

ROOT = Path(__file__).resolve().parents[1]


def prose(path: Path) -> str:
    """Ignore code fences when looking for links and headings."""
    return re.sub(r"```.*?```", "", path.read_text(encoding="utf-8"), flags=re.DOTALL)


def anchors(path: Path) -> set[str]:
    """Use GitHub's basic heading convention, including duplicate-heading suffixes."""
    seen: dict[str, int] = {}
    result = set()
    for title in re.findall(r"^#{1,6}\s+(.+)$", prose(path), flags=re.MULTILINE):
        slug = "-".join(re.sub(r"[^\w\- ]", "", title.lower()).split())
        count = seen.get(slug, 0)
        result.add(f"{slug}-{count}" if count else slug)
        seen[slug] = count + 1
    return result


def main() -> None:
    """Reject missing relative targets and anchors in maintained project documentation."""
    documents = [ROOT / "README.md", *sorted((ROOT / "docs").glob("*.md"))]
    documents.extend(sorted((ROOT / "tests").rglob("*.robot.md")))
    errors = []
    for document in documents:
        for link in re.findall(r"\[[^\]]+\]\(([^\s)]+)\)", prose(document)):
            parsed = urlsplit(link)
            if parsed.scheme or parsed.netloc:
                continue
            target = (document.parent / unquote(parsed.path)).resolve() if parsed.path else document
            if not target.exists():
                errors.append(f"{document.relative_to(ROOT)}: missing target {link}")
            elif parsed.fragment and target.suffix == ".md":
                if unquote(parsed.fragment) not in anchors(target):
                    errors.append(f"{document.relative_to(ROOT)}: missing heading {link}")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"Checked local links and anchors in {len(documents)} Markdown documents.")


if __name__ == "__main__":
    main()
