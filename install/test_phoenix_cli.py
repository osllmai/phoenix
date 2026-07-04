#!/usr/bin/env python3
"""Tests for phoenix configure (no network, uses tmp HOME)."""

from __future__ import annotations

import json
import os
import sys
import tempfile
import unittest
from pathlib import Path
from unittest import mock

ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(ROOT / "install"))

import phoenix_cli  # noqa: E402


class ConfigureTests(unittest.TestCase):
    def setUp(self) -> None:
        self._tmp = tempfile.TemporaryDirectory()
        self.home = Path(self._tmp.name)
        self.phoenix = self.home / ".phoenix"
        self.patcher = mock.patch.object(phoenix_cli, "PHOENIX_DIR", self.phoenix)
        self.patcher.start()
        phoenix_cli.ENV_FILE = self.phoenix / "env.sh"
        phoenix_cli.CONTINUE_SNIPPET = self.phoenix / "continue.phoenix.json"

    def tearDown(self) -> None:
        self.patcher.stop()
        self._tmp.cleanup()

    def test_write_env_claude_and_openai(self) -> None:
        phoenix_cli.write_env_file(24678, claude=True, openai=True)
        text = phoenix_cli.ENV_FILE.read_text(encoding="utf-8")
        self.assertIn("ANTHROPIC_BASE_URL=http://127.0.0.1:24678", text)
        self.assertIn("OPENAI_BASE_URL=http://127.0.0.1:24678/v1", text)

    def test_continue_snippet_shape(self) -> None:
        phoenix_cli.write_continue_snippet(24678)
        data = json.loads(phoenix_cli.CONTINUE_SNIPPET.read_text(encoding="utf-8"))
        self.assertEqual(data["models"][0]["apiBase"], "http://127.0.0.1:24678/v1")


if __name__ == "__main__":
    unittest.main()
