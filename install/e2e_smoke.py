#!/usr/bin/env python3
"""End-to-end HTTP smoke test for the Phoenix gateway (mock engine).

Starts packages/phoenix_server/bin/e2e_serve.dart, then exercises:
  health → add model → select → chat → stream
"""

from __future__ import annotations

import json
import os
import subprocess
import sys
import time
import urllib.error
import urllib.request
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
SERVER_DIR = ROOT / "packages" / "phoenix_server"
PORT = int(os.environ.get("PHOENIX_E2E_PORT", "24779"))
BASE = f"http://127.0.0.1:{PORT}"


def request(method: str, path: str, body: dict | None = None) -> tuple[int, dict | str]:
    data = None if body is None else json.dumps(body).encode("utf-8")
    req = urllib.request.Request(
        f"{BASE}{path}",
        data=data,
        method=method,
        headers={"Content-Type": "application/json"} if body else {},
    )
    with urllib.request.urlopen(req, timeout=30) as resp:
        raw = resp.read().decode("utf-8")
        code = resp.status
    try:
        return code, json.loads(raw)
    except json.JSONDecodeError:
        return code, raw


def wait_for_server(proc: subprocess.Popen[str], timeout: float = 30.0) -> None:
    deadline = time.time() + timeout
    while time.time() < deadline:
        if proc.poll() is not None:
            raise SystemExit(f"e2e server exited early (code {proc.returncode})")
        try:
            with urllib.request.urlopen(f"{BASE}/health", timeout=2) as resp:
                if resp.status == 200:
                    return
        except (urllib.error.URLError, TimeoutError):
            time.sleep(0.2)
    raise SystemExit("e2e server did not become ready in time")


def main() -> None:
    env = os.environ.copy()
    env["PHOENIX_E2E_PORT"] = str(PORT)
    proc = subprocess.Popen(
        ["dart", "run", "bin/e2e_serve.dart"],
        cwd=SERVER_DIR,
        env=env,
        stdout=subprocess.PIPE,
        stderr=subprocess.STDOUT,
        text=True,
    )
    try:
        wait_for_server(proc)

        code, health = request("GET", "/health")
        assert code == 200 and health == {"ok": True}, health

        code, created = request(
            "POST",
            "/v1/models",
            {"name": "E2E", "path": "/tmp/e2e-model.gguf"},
        )
        assert code == 201, created
        model_id = created["id"]

        code, _ = request("POST", f"/v1/models/{model_id}/select")
        assert code == 200

        code, chat = request(
            "POST",
            "/v1/chat/completions",
            {"messages": [{"role": "user", "content": "Capital of France?"}]},
        )
        assert code == 200, chat
        content = chat["choices"][0]["message"]["content"]
        assert "Paris" in content, content

        code, stream = request(
            "POST",
            "/v1/chat/completions",
            {"stream": True, "messages": [{"role": "user", "content": "Hi"}]},
        )
        assert code == 200, stream
        assert isinstance(stream, str) and "Paris" in stream and "[DONE]" in stream

        code, msg = request(
            "POST",
            "/v1/messages",
            {
                "model": "E2E",
                "max_tokens": 64,
                "messages": [{"role": "user", "content": "Capital of France?"}],
            },
        )
        assert code == 200, msg
        assert "Paris" in msg["content"][0]["text"], msg

        code, msg_stream = request(
            "POST",
            "/v1/messages",
            {
                "model": "E2E",
                "max_tokens": 64,
                "stream": True,
                "messages": [{"role": "user", "content": "Hi"}],
            },
        )
        assert code == 200, msg_stream
        assert isinstance(msg_stream, str) and "content_block_delta" in msg_stream

        print("✓ e2e smoke passed (health, models, chat, stream, messages)")
    finally:
        proc.terminate()
        try:
            proc.wait(timeout=5)
        except subprocess.TimeoutExpired:
            proc.kill()


if __name__ == "__main__":
    try:
        main()
    except (AssertionError, urllib.error.URLError) as exc:
        print(f"✗ e2e smoke failed: {exc}", file=sys.stderr)
        sys.exit(1)
