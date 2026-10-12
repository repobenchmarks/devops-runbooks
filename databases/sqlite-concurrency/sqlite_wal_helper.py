"""
Thread-safe, WAL-enabled SQLite database helper with busy timeouts.
Ref: https://www.repobenchmarks.com/2026/10/how-to-fix-sqlite3operationalerror.html
"""
import sqlite3
import threading

class SQLiteConcurrencyManager:
    def __init__(self, db_path: str, timeout: float = 30.0):
        self.db_path = db_path
        self.timeout = timeout
        self._local = threading.local()
        self._init_db()

    def _init_db(self):
        with sqlite3.connect(self.db_path, timeout=self.timeout) as conn:
            conn.execute("PRAGMA journal_mode = WAL;")
            conn.execute("PRAGMA synchronous = NORMAL;")
            conn.execute(f"PRAGMA busy_timeout = {int(self.timeout * 1000)};")
            conn.commit()

    def get_connection(self) -> sqlite3.Connection:
        if not hasattr(self._local, "conn") or self._local.conn is None:
            conn = sqlite3.connect(
                self.db_path,
                timeout=self.timeout,
                check_same_thread=True
            )
            conn.execute("PRAGMA busy_timeout = 30000;")
            self._local.conn = conn
        return self._local.conn
