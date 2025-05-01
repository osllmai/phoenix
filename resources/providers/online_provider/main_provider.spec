# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['main_provider.py'],
    pathex=[],
    binaries=[],
    datas=[('..\\..\\models\\online_models\\mistral.json', 'models/online_models'), ('..\\..\\models\\online_models\\deepseek.json', 'models/online_models'), ('..\\..\\models\\online_models\\openai.json', 'models/online_models'), ('..\\..\\models\\company.json', 'models')],
    hiddenimports=[],
    hookspath=[],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[],
    noarchive=False,
    optimize=0,
)
pyz = PYZ(a.pure)

exe = EXE(
    pyz,
    a.scripts,
    a.binaries,
    a.datas,
    [],
    name='main_provider',
    debug=False,
    bootloader_ignore_signals=False,
    strip=False,
    upx=True,
    upx_exclude=[],
    runtime_tmpdir=None,
    console=True,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
)
