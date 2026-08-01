#!/usr/bin/env python3
"""Build Phoenix release artifacts (CLI gateway + desktop bundle).

Used locally and in CI. Pure Python — no shell scripts required.
"""

from __future__ import annotations

import argparse
import hashlib
import json
import os
import platform
import shutil
import subprocess
import sys
import tarfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
ENGINE_SRC = ROOT / "engine" / "local_provider" / "linux_llama"
SERVER_DIR = ROOT / "packages" / "phoenix_server"
MOBILE_DIR = ROOT / "mobile"
BUILD_ROOT = ROOT / "build" / "release"
LLAMA_CPP_DIR = BUILD_ROOT / "llama.cpp"


def run(cmd: list[str], *, cwd: Path | None = None, env: dict[str, str] | None = None) -> None:
    merged = os.environ.copy()
    if env:
        merged.update(env)
    print(f"  $ {' '.join(cmd)}", flush=True)
    subprocess.run(cmd, cwd=cwd or ROOT, env=merged, check=True)


def git_version() -> str:
    try:
        out = subprocess.check_output(
            ["git", "describe", "--tags", "--always", "--dirty"],
            cwd=ROOT,
            text=True,
        ).strip()
        return out.lstrip("v")
    except (subprocess.CalledProcessError, FileNotFoundError):
        return "0.0.0-dev"


def host_platform() -> str:
    system = platform.system().lower()
    machine = platform.machine().lower()
    if machine in ("x86_64", "amd64"):
        arch = "x64"
    elif machine in ("arm64", "aarch64"):
        arch = "arm64"
    else:
        raise SystemExit(f"Unsupported architecture: {machine}")
    os_name = {"linux": "linux", "darwin": "darwin", "windows": "windows"}.get(system)
    if not os_name:
        raise SystemExit(f"Unsupported OS: {system}")
    return f"{os_name}-{arch}"


def ensure_llama_cpp() -> None:
    if (LLAMA_CPP_DIR / "include" / "llama.h").exists():
        return
    BUILD_ROOT.mkdir(parents=True, exist_ok=True)
    if LLAMA_CPP_DIR.exists():
        shutil.rmtree(LLAMA_CPP_DIR)
    run(
        ["git", "clone", "--depth", "1", "https://github.com/ggml-org/llama.cpp.git", str(LLAMA_CPP_DIR)],
        cwd=BUILD_ROOT,
    )
    llama_build = LLAMA_CPP_DIR / "build"
    run(
        [
            "cmake",
            "-S",
            str(LLAMA_CPP_DIR),
            "-B",
            str(llama_build),
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_C_COMPILER=clang",
            "-DCMAKE_CXX_COMPILER=clang++",
            "-DBUILD_SHARED_LIBS=ON",
            "-DLLAMA_CURL=OFF",
            "-DLLAMA_BUILD_EXAMPLES=OFF",
            "-DLLAMA_BUILD_TESTS=OFF",
            "-DLLAMA_BUILD_TOOLS=OFF",
            "-DLLAMA_BUILD_SERVER=OFF",
        ],
    )
    run(["cmake", "--build", str(llama_build), "-j", "--target", "llama", "ggml", "ggml-cpu"])


def build_engine(staging_engine: Path) -> bool:
    if platform.system().lower() != "linux":
        print("  engine: skipped (linux-only build in this release pipeline)")
        return False
    ensure_llama_cpp()
    engine_build = ENGINE_SRC / "build"
    if engine_build.exists():
        shutil.rmtree(engine_build)
    run(
        [
            "cmake",
            "-S",
            str(ENGINE_SRC),
            "-B",
            str(engine_build),
            f"-DLLAMA_CPP_DIR={LLAMA_CPP_DIR}",
        ],
    )
    run(["cmake", "--build", str(engine_build), "-j"])
    staging_engine.mkdir(parents=True, exist_ok=True)
    shutil.copy2(engine_build / "applocal_provider", staging_engine / "applocal_provider")
    llama_bin = LLAMA_CPP_DIR / "build" / "bin"
    for name in ("libllama.so", "libggml.so", "libggml-base.so", "libggml-cpu.so"):
        src = llama_bin / name
        if src.exists():
            shutil.copy2(src, staging_engine / name)
    os.chmod(staging_engine / "applocal_provider", 0o755)
    return True


def compile_gateway(out_path: Path) -> None:
    run(["dart", "pub", "get"], cwd=SERVER_DIR)
    out_path.parent.mkdir(parents=True, exist_ok=True)
    run(["dart", "compile", "exe", "bin/server.dart", "-o", str(out_path)], cwd=SERVER_DIR)


def write_cli_launcher(dest: Path) -> None:
    src = Path(__file__).resolve().parent / "phoenix_cli.py"
    dest.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(src, dest)
    dest.chmod(0o755)


def write_desktop_launcher(dest: Path, os_name: str) -> None:
    dest.parent.mkdir(parents=True, exist_ok=True)
    if os_name == "darwin":
        exe_expr = "bundle / 'phoenix.app' / 'Contents' / 'MacOS' / 'phoenix'"
    elif os_name == "windows":
        exe_expr = "bundle / 'phoenix.exe'"
    else:
        exe_expr = "bundle / 'phoenix'"
    dest.write_text(
        f"""#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parent.parent
bundle = ROOT / "bundle"
engine_dir = ROOT / "engine"
exe = {exe_expr}
env = os.environ.copy()
if engine_dir.exists():
    env["PHOENIX_ENGINE_DIR"] = str(engine_dir)
if not exe.exists():
    sys.exit(f"Phoenix desktop binary not found: {{exe}}")
sys.exit(subprocess.run([str(exe), *sys.argv[1:]], env=env).returncode)
""",
        encoding="utf-8",
    )
    dest.chmod(0o755)


def build_cli(staging: Path, version: str, os_name: str) -> None:
    staging.mkdir(parents=True, exist_ok=True)
    (staging / "VERSION").write_text(version + "\n", encoding="utf-8")
    has_engine = build_engine(staging / "engine")
    server_bin = staging / "bin" / "phoenix-server"
    compile_gateway(server_bin)
    write_cli_launcher(staging / "bin" / "phoenix")
    meta = {"version": version, "target": "cli", "engine": has_engine}
    (staging / "manifest.json").write_text(json.dumps(meta, indent=2) + "\n", encoding="utf-8")


def flutter_build(os_name: str) -> Path:
    run(["flutter", "pub", "get"], cwd=MOBILE_DIR)
    if os_name == "linux":
        run(["flutter", "build", "linux", "--release"], cwd=MOBILE_DIR)
        return MOBILE_DIR / "build" / "linux" / "x64" / "release" / "bundle"
    if os_name == "darwin":
        run(["flutter", "build", "macos", "--release"], cwd=MOBILE_DIR)
        return MOBILE_DIR / "build" / "macos" / "Build" / "Products" / "Release"
    if os_name == "windows":
        run(["flutter", "build", "windows", "--release"], cwd=MOBILE_DIR)
        return MOBILE_DIR / "build" / "windows" / "x64" / "runner" / "Release"
    raise SystemExit(f"Unsupported desktop OS: {os_name}")


def build_desktop(staging: Path, version: str, os_name: str) -> None:
    staging.mkdir(parents=True, exist_ok=True)
    (staging / "VERSION").write_text(version + "\n", encoding="utf-8")
    bundle_src = flutter_build(os_name)
    bundle_dest = staging / "bundle"
    if bundle_dest.exists():
        shutil.rmtree(bundle_dest)
    shutil.copytree(bundle_src, bundle_dest)
    has_engine = build_engine(staging / "engine")
    write_desktop_launcher(staging / "bin" / "phoenix-desktop", os_name)
    meta = {"version": version, "target": "desktop", "engine": has_engine}
    (staging / "manifest.json").write_text(json.dumps(meta, indent=2) + "\n", encoding="utf-8")


def sha256_file(path: Path) -> str:
    digest = hashlib.sha256()
    with path.open("rb") as fh:
        for chunk in iter(lambda: fh.read(1024 * 1024), b""):
            digest.update(chunk)
    return digest.hexdigest()


def make_tarball(staging: Path, artifact: Path) -> str:
    artifact.parent.mkdir(parents=True, exist_ok=True)
    with tarfile.open(artifact, "w:gz") as tar:
        tar.add(staging, arcname=staging.name)
    return sha256_file(artifact)


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Build Phoenix CLI/desktop release artifacts.")
    parser.add_argument(
        "--target",
        choices=("cli", "desktop", "all"),
        default="all",
        help="Artifact to build (default: all)",
    )
    parser.add_argument(
        "--platform",
        default=None,
        help="Platform slug for the artifact name, e.g. linux-x64 (default: autodetect)",
    )
    parser.add_argument("--version", default=None, help="Release version (default: git describe)")
    parser.add_argument("--output-dir", type=Path, default=ROOT / "dist", help="Output directory")
    return parser.parse_args()


def main() -> None:
    args = parse_args()
    version = args.version or git_version()
    plat = args.platform or host_platform()
    os_name = plat.split("-", 1)[0]
    targets = ("cli", "desktop") if args.target == "all" else (args.target,)
    checksums: list[str] = []

    for target in targets:
        staging = BUILD_ROOT / f"phoenix-{target}-{version}"
        if staging.exists():
            shutil.rmtree(staging)
        print(f"\n▸ Building {target} for {plat} (v{version})")
        if target == "cli":
            build_cli(staging, version, os_name)
        else:
            build_desktop(staging, version, os_name)
        artifact = args.output_dir / f"phoenix-{target}-{plat}.tar.gz"
        digest = make_tarball(staging, artifact)
        checksums.append(f"{digest}  {artifact.name}")
        print(f"  ✓ {artifact.name}  sha256={digest[:16]}…")

    sums_path = args.output_dir / "SHA256SUMS"
    sums_path.write_text("\n".join(checksums) + "\n", encoding="utf-8")
    print(f"\n✓ Checksums written to {sums_path}")


if __name__ == "__main__":
    main()
