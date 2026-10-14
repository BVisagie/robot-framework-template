"""Small local test target: an HTTP API, an HTML UI, and a seeded SQLite database."""

import argparse
import json
import sqlite3
from contextlib import closing
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from pathlib import Path
from urllib.parse import parse_qs, urlsplit

import yaml

PROJECT_ROOT = Path(__file__).resolve().parents[1]


def seed_database(database: Path, records: list[dict]) -> None:
    """Reset the database to the shared, deterministic seed data."""
    with closing(sqlite3.connect(database)) as connection, connection:
        connection.execute(
            "CREATE TABLE IF NOT EXISTS items "
            "(id INTEGER PRIMARY KEY, name TEXT NOT NULL, quantity INTEGER NOT NULL)"
        )
        connection.execute("DELETE FROM items")
        connection.executemany(
            "INSERT INTO items (id, name, quantity) VALUES (?, ?, ?)",
            [(record["id"], record["name"], record["quantity"]) for record in records],
        )


class CatalogServer(ThreadingHTTPServer):
    """Give request handlers access to this fixture's database and seed data."""

    def __init__(self, port: int, database: Path, records: list[dict]):
        self.database = database
        self.records = records
        super().__init__(("127.0.0.1", port), CatalogHandler)


class CatalogHandler(BaseHTTPRequestHandler):
    """Serve only the small catalog routes used by the example suites."""

    server: CatalogServer

    def _respond(self, status: int, body: bytes, content_type: str) -> None:
        self.send_response(status)
        self.send_header("Content-Type", content_type)
        self.send_header("Content-Length", str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def _json(self, status: int, payload: object) -> None:
        self._respond(
            status, json.dumps(payload).encode("utf-8"), "application/json; charset=utf-8"
        )

    def _item_id(self) -> int | None:
        parts = urlsplit(self.path).path.strip("/").split("/")
        if len(parts) == 3 and parts[:2] == ["api", "items"] and parts[2].isdecimal():
            item_id = int(parts[2])
            if 0 < item_id <= 2**63 - 1:
                return item_id
        return None

    def _read_item(self) -> dict | None:
        try:
            length = int(self.headers.get("Content-Length", "0"))
            if not 0 < length <= 65536:
                raise ValueError
            item = json.loads(self.rfile.read(length))
            if (
                not isinstance(item, dict)
                or not isinstance(item.get("name"), str)
                or not item["name"].strip()
                or type(item.get("quantity")) is not int
                or not 0 <= item["quantity"] <= 2**63 - 1
            ):
                raise ValueError
        except ValueError, UnicodeDecodeError:
            self._json(
                400, {"error": "Provide a non-empty name and a non-negative integer quantity."}
            )
            return None
        return {"name": item["name"].strip(), "quantity": item["quantity"]}

    def do_GET(self) -> None:
        """Serve the UI, readiness check, list/filter, and item lookup."""
        path = urlsplit(self.path).path
        if path == "/":
            self._respond(
                200,
                (PROJECT_ROOT / "fixtures/static/index.html").read_bytes(),
                "text/html; charset=utf-8",
            )
        elif path == "/health":
            self._json(200, {"status": "ready"})
        else:
            with closing(sqlite3.connect(self.server.database)) as connection:
                connection.row_factory = sqlite3.Row
                if path == "/api/items":
                    query = parse_qs(urlsplit(self.path).query).get("q", [""])[0].casefold()
                    rows = connection.execute("SELECT * FROM items ORDER BY id").fetchall()
                    self._json(200, [dict(row) for row in rows if query in row["name"].casefold()])
                elif (item_id := self._item_id()) is not None:
                    row = connection.execute(
                        "SELECT * FROM items WHERE id = ?", (item_id,)
                    ).fetchone()
                    if row is None:
                        self._json(404, {"error": "Item not found."})
                    else:
                        self._json(200, dict(row))
                else:
                    self._json(404, {"error": "Route not found."})

    def do_POST(self) -> None:
        """Create a record or reset this disposable fixture."""
        path = urlsplit(self.path).path
        if path == "/api/reset":
            seed_database(self.server.database, self.server.records)
            self._json(200, {"status": "reset"})
        elif path == "/api/items":
            if (item := self._read_item()) is None:
                return
            with closing(sqlite3.connect(self.server.database)) as connection, connection:
                cursor = connection.execute(
                    "INSERT INTO items (name, quantity) VALUES (?, ?)",
                    (item["name"], item["quantity"]),
                )
                item["id"] = cursor.lastrowid
            self._json(201, item)
        else:
            self._json(404, {"error": "Route not found."})

    def do_PUT(self) -> None:
        """Replace a record using bound SQL values."""
        if (item_id := self._item_id()) is None:
            self._json(404, {"error": "Route not found."})
            return
        if (item := self._read_item()) is None:
            return
        with closing(sqlite3.connect(self.server.database)) as connection, connection:
            cursor = connection.execute(
                "UPDATE items SET name = ?, quantity = ? WHERE id = ?",
                (item["name"], item["quantity"], item_id),
            )
        if cursor.rowcount == 0:
            self._json(404, {"error": "Item not found."})
        else:
            self._json(200, {**item, "id": item_id})

    def do_DELETE(self) -> None:
        """Delete a known record and return an empty 204 response."""
        if (item_id := self._item_id()) is None:
            self._json(404, {"error": "Route not found."})
            return
        with closing(sqlite3.connect(self.server.database)) as connection, connection:
            cursor = connection.execute("DELETE FROM items WHERE id = ?", (item_id,))
        if cursor.rowcount == 0:
            self._json(404, {"error": "Item not found."})
        else:
            self._respond(204, b"", "application/json")


def main() -> None:
    """Write readiness information after binding to an available loopback port."""
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--database", type=Path, required=True)
    parser.add_argument("--ready-file", type=Path, required=True)
    parser.add_argument("--port", type=int, default=0)
    parser.add_argument("--seed", type=Path, default=PROJECT_ROOT / "data/catalog.yaml")
    args = parser.parse_args()
    records = yaml.safe_load(args.seed.read_text(encoding="utf-8"))["CATALOG_SEED"]
    args.database.parent.mkdir(parents=True, exist_ok=True)
    seed_database(args.database, records)
    with CatalogServer(args.port, args.database, records) as server:
        ready = {"url": f"http://127.0.0.1:{server.server_port}", "database": str(args.database)}
        args.ready_file.parent.mkdir(parents=True, exist_ok=True)
        pending = args.ready_file.with_suffix(".tmp")
        pending.write_text(json.dumps(ready), encoding="utf-8")
        pending.replace(args.ready_file)
        try:
            server.serve_forever()
        except KeyboardInterrupt:
            pass


if __name__ == "__main__":
    main()
