#!/usr/bin/env python3
"""Run all Phoenix gateway + install verification checks."""

from __future__ import annotations

import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
INSTALL = ROOT / "install"


def run(label: str, cmd: list[str], *, cwd: Path | None = None) -> None:
    print(f"▸ {label}")
    subprocess.run(cmd, cwd=cwd or ROOT, check=True)


def main() -> None:
    for script in sorted(INSTALL.glob("*.py")):
        print(f"▸ Python syntax ({script.name})")
        subprocess.run([sys.executable, "-m", "py_compile", str(script)], check=True)
    run("phoenix_core tests", ["dart", "test"], cwd=ROOT / "packages/phoenix_core")
    run("phoenix_server tests", ["dart", "test"], cwd=ROOT / "packages/phoenix_server")
    run("phoenix configure tests", [sys.executable, str(INSTALL / "test_phoenix_cli.py")])
    run("gateway e2e smoke", [sys.executable, str(INSTALL / "e2e_smoke.py")])
    print("\n✓ all verification checks passed")


if __name__ == "__main__":
    try:
        main()
    except subprocess.CalledProcessError as exc:
        print(f"\n✗ verification failed (exit {exc.returncode})", file=sys.stderr)
        sys.exit(exc.returncode)
