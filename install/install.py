#!/usr/bin/env python3
"""Install Phoenix CLI gateway and/or desktop app from GitHub Releases.

Usage:
  curl -fsSL https://raw.githubusercontent.com/osllmai/phoenix/production/install/install.py | python3 -
  curl -fsSL …/install.py | python3 - --cli
  curl -fsSL …/install.py | python3 - --desktop
  python3 install.py --cli --desktop --version v0.1.0

Install layout:
  ~/.local/share/phoenix/versions/<version>/{cli,desktop}/
  ~/.local/bin/phoenix
  ~/.local/bin/phoenix-desktop
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import platform
import shutil
import ssl
import sys
import tarfile
import tempfile
import urllib.error
import urllib.request
from pathlib import Path

DEFAULT_REPO = "osllmai/phoenix"
INSTALL_ROOT = Path.home() / ".local" / "share" / "phoenix"
BIN_DIR = Path.home() / ".local" / "bin"
DATA_DIR = Path.home() / ".local" / "share" / "phoenix" / "data"


def _say_ok(msg: str) -> None:
    print(f"✓ {msg}")


def _say_step(msg: str) -> None:
    print(f"▸ {msg}")


def _say_err(msg: str) -> None:
    print(f"✗ {msg}", file=sys.stderr)


def detect_platform() -> tuple[str, str]:
    system = platform.system().lower()
    machine = platform.machine().lower()
    if machine in ("x86_64", "amd64"):
        arch = "x64"
    elif machine in ("arm64", "aarch64"):
        arch = "arm64"
    else:
        raise SystemExit(f"Unsupported architecture: {machine}")
    os_map = {"linux": "linux", "darwin": "darwin", "windows": "windows"}
    os_name = os_map.get(system)
    if not os_name:
        raise SystemExit(f"Unsupported operating system: {system}")
    return os_name, arch


def _ssl_context() -> ssl.SSLContext:
    ctx = ssl.create_default_context()
    for cert_path in (
        "/etc/ssl/cert.pem",
        "/private/etc/ssl/cert.pem",
        "/opt/homebrew/etc/openssl@3/cert.pem",
        "/usr/local/etc/openssl@3/cert.pem",
        "/etc/pki/tls/certs/ca-bundle.crt",
    ):
        if os.path.isfile(cert_path):
            try:
                ctx.load_verify_locations(cert_path)
            except ssl.SSLError:
                pass
    return ctx


def http_get(url: str) -> bytes:
    req = urllib.request.Request(url, headers={"User-Agent": "phoenix-installer"})
    with urllib.request.urlopen(req, timeout=120, context=_ssl_context()) as resp:
        return resp.read()


def http_get_json(url: str) -> dict:
    return json.loads(http_get(url).decode("utf-8"))


def resolve_version(repo: str, version: str | None) -> str:
    if version:
        return version.lstrip("v")
    data = http_get_json(f"https://api.github.com/repos/{repo}/releases/latest")
    tag = data.get("tag_name")
    if not tag:
        raise SystemExit("Could not resolve latest release tag from GitHub.")
    return tag.lstrip("v")


def release_assets(repo: str, version: str) -> dict[str, dict]:
    tag = f"v{version.lstrip('v')}"
    data = http_get_json(f"https://api.github.com/repos/{repo}/releases/tags/{tag}")
    out: dict[str, dict] = {}
    for asset in data.get("assets", []):
        out[asset["name"]] = asset
    if not out:
        raise SystemExit(
            f"No release assets found for {tag}. "
            "Wait for the release_binaries workflow to finish, or pick another --version."
        )
    return out


def download_asset(asset: dict, dest: Path) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    req = urllib.request.Request(asset["browser_download_url"], headers={"User-Agent": "phoenix-installer"})
    with urllib.request.urlopen(req, timeout=600, context=_ssl_context()) as resp, dest.open("wb") as fh:
        shutil.copyfileobj(resp, fh)


def verify_sha256(path: Path, expected: str | None) -> None:
    if not expected:
        return
    digest = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            digest.update(chunk)
    if digest.hexdigest() != expected.strip():
        raise SystemExit(f"Checksum mismatch for {path.name}")


def load_checksums(assets: dict[str, dict], repo: str, version: str) -> dict[str, str]:
    name = "SHA256SUMS"
    if name not in assets:
        return {}
    tmp = Path(tempfile.mkdtemp(prefix="phoenix-install-"))
    try:
        download_asset(assets[name], tmp / name)
        mapping: dict[str, str] = {}
        for line in (tmp / name).read_text(encoding="utf-8").splitlines():
            line = line.strip()
            if not line or line.startswith("#"):
                continue
            parts = line.split(None, 1)
            if len(parts) == 2:
                mapping[parts[1]] = parts[0]
        return mapping
    finally:
        shutil.rmtree(tmp, ignore_errors=True)


def extract_tarball(archive: Path, dest: Path) -> Path:
    dest.mkdir(parents=True, exist_ok=True)
    with tarfile.open(archive, "r:gz") as tar:
        if hasattr(tarfile, "data_filter"):
            tar.extractall(dest, filter="data")
        else:
            tar.extractall(dest)
    children = [p for p in dest.iterdir() if p.is_dir()]
    if len(children) == 1:
        return children[0]
    raise SystemExit(f"Unexpected archive layout in {archive.name}")


def ensure_bin_dir() -> None:
    BIN_DIR.mkdir(parents=True, exist_ok=True)


def symlink_force(link: Path, target: Path) -> None:
    if link.exists() or link.is_symlink():
        link.unlink()
    link.symlink_to(target)


def install_target(
    *,
    target: str,
    os_name: str,
    arch: str,
    version: str,
    repo: str,
    assets: dict[str, dict],
    checksums: dict[str, str],
) -> Path | None:
    artifact_name = f"phoenix-{target}-{os_name}-{arch}.tar.gz"
    if artifact_name not in assets:
        _say_err(f"{artifact_name} not available for this platform — skipped")
        return None

    version_dir = INSTALL_ROOT / "versions" / version
    final_dir = version_dir / target
    if final_dir.exists():
        shutil.rmtree(final_dir)

    _say_step(f"Downloading {artifact_name}…")
    tmp = Path(tempfile.mkdtemp(prefix="phoenix-install-"))
    try:
        archive = tmp / artifact_name
        download_asset(assets[artifact_name], archive)
        verify_sha256(archive, checksums.get(artifact_name))
        extracted = extract_tarball(archive, tmp / "extract")
        extracted.rename(final_dir)
        _say_ok(f"Installed {target} → {final_dir}")
    finally:
        shutil.rmtree(tmp, ignore_errors=True)

    DATA_DIR.mkdir(parents=True, exist_ok=True)
    ensure_bin_dir()

    if target == "cli":
        launcher = final_dir / "bin" / "phoenix"
        if not launcher.exists():
            raise SystemExit(f"CLI launcher missing in {artifact_name}")
        symlink_force(BIN_DIR / "phoenix", launcher.resolve())
        _say_ok("Linked ~/.local/bin/phoenix")
    else:
        launcher = final_dir / "bin" / "phoenix-desktop"
        if not launcher.exists():
            raise SystemExit(f"Desktop launcher missing in {artifact_name}")
        symlink_force(BIN_DIR / "phoenix-desktop", launcher.resolve())
        _say_ok("Linked ~/.local/bin/phoenix-desktop")

    manifest_path = final_dir / "manifest.json"
    if manifest_path.exists():
        meta = json.loads(manifest_path.read_text(encoding="utf-8"))
        if not meta.get("engine"):
            print(
                f"  note: {target} bundle has no on-device engine for this platform yet; "
                "inference may require a manual engine build."
            )
    return final_dir


def path_hint() -> None:
    bin_str = str(BIN_DIR)
    path = os.environ.get("PATH", "")
    if f"{bin_str}:" in path or path.endswith(bin_str):
        return
    shell = Path(os.environ.get("SHELL", "/bin/bash")).name
    print("\nAdd Phoenix to your PATH:")
    if shell == "fish":
        print(f"  fish_add_path {bin_str}")
    elif shell == "zsh":
        print(f'  echo \'export PATH="{bin_str}:$PATH"\' >> ~/.zshrc && source ~/.zshrc')
    else:
        print(f'  echo \'export PATH="{bin_str}:$PATH"\' >> ~/.bashrc && source ~/.bashrc')


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Install Phoenix CLI and/or desktop app.")
    parser.add_argument("--cli", action="store_true", help="Install the phoenix CLI gateway")
    parser.add_argument("--desktop", action="store_true", help="Install the Phoenix desktop app")
    parser.add_argument("--version", default=None, help="Release tag, e.g. v0.1.0 (default: latest)")
    parser.add_argument("--repo", default=DEFAULT_REPO, help=f"GitHub repo (default: {DEFAULT_REPO})")
    parser.add_argument("--dry-run", action="store_true", help="Show what would be installed")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    install_cli = args.cli or not (args.cli or args.desktop)
    install_desktop = args.desktop or not (args.cli or args.desktop)

    os_name, arch = detect_platform()
    _say_step(f"Detected {os_name}/{arch}")

    version = resolve_version(args.repo, args.version)
    _say_step(f"Release v{version}")

    try:
        assets = release_assets(args.repo, version)
    except SystemExit as exc:
        if not args.dry_run:
            raise
        assets = {}
        print(f"  note: {exc}")

    checksums = load_checksums(assets, args.repo, version) if assets else {}

    planned = []
    if install_cli:
        planned.append(f"phoenix-cli-{os_name}-{arch}.tar.gz")
    if install_desktop:
        planned.append(f"phoenix-desktop-{os_name}-{arch}.tar.gz")

    if args.dry_run:
        for name in planned:
            status = "available" if name in assets else "MISSING"
            print(f"  {name}: {status}")
        return

    installed = 0
    if install_cli:
        if install_target(
            target="cli",
            os_name=os_name,
            arch=arch,
            version=version,
            repo=args.repo,
            assets=assets,
            checksums=checksums,
        ):
            installed += 1
    if install_desktop:
        if install_target(
            target="desktop",
            os_name=os_name,
            arch=arch,
            version=version,
            repo=args.repo,
            assets=assets,
            checksums=checksums,
        ):
            installed += 1

    if installed == 0:
        raise SystemExit("Nothing was installed — no artifacts matched your platform.")

    print("\n✨ Phoenix installation complete!\n")
    if install_cli:
        print("  CLI:     phoenix")
    if install_desktop:
        print("  Desktop: phoenix-desktop")
    path_hint()


if __name__ == "__main__":
    try:
        main()
    except urllib.error.HTTPError as exc:
        _say_err(f"Download failed: HTTP {exc.code} {exc.reason}")
        sys.exit(1)
    except urllib.error.URLError as exc:
        _say_err(f"Network error: {exc.reason}")
        sys.exit(1)
