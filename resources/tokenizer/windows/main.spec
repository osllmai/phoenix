# -*- mode: python ; coding: utf-8 -*-


a = Analysis(
    ['src\\main.py'],
    pathex=[],
    binaries=[],
    datas=[('E:\\phoenix\\resources\\tokenizer\\windows\\venv\\Lib\\site-packages\\chromadb\\migrations', 'chromadb/migrations'), ('E:\\phoenix\\resources\\tokenizer\\windows\\venv\\Lib\\site-packages\\chromadb\\ingest\\impl', 'chromadb/ingest/impl'), ('E:\\phoenix\\resources\\tokenizer\\windows\\venv\\Lib\\site-packages\\chromadb\\segment\\impl', 'chromadb/segment/impl')],
    hiddenimports=['chromadb.api', 'chromadb.api.client', 'chromadb.api.fastapi', 'chromadb.api.segment', 'chromadb.api.types', 'chromadb.app', 'chromadb.auth', 'chromadb.auth.authz', 'chromadb.auth.basic', 'chromadb.auth.fastapi', 'chromadb.auth.fastapi_utils', 'chromadb.auth.providers', 'chromadb.auth.registry', 'chromadb.auth.token', 'chromadb.cli', 'chromadb.cli.cli', 'chromadb.config', 'chromadb.db', 'chromadb.db.base', 'chromadb.db.impl', 'chromadb.db.impl.sqlite', 'chromadb.db.impl.sqlite_pool', 'chromadb.db.migrations', 'chromadb.db.system', 'chromadb.errors', 'chromadb.ingest', 'chromadb.migrations', 'chromadb.proto', 'chromadb.proto.chroma_pb2', 'chromadb.proto.chroma_pb2_grpc', 'chromadb.proto.convert', 'chromadb.proto.coordinator_pb2', 'chromadb.proto.coordinator_pb2_grpc', 'chromadb.segment', 'chromadb.segment.distributed', 'chromadb.server', 'chromadb.server.fastapi', 'chromadb.server.fastapi.types', 'chromadb.telemetry', 'chromadb.telemetry.opentelemetry', 'chromadb.telemetry.opentelemetry.fastapi', 'chromadb.telemetry.product', 'chromadb.telemetry.product.events', 'chromadb.telemetry.product.posthog', 'chromadb.types', 'chromadb.utils', 'chromadb.utils.batch_utils', 'chromadb.utils.data_loaders', 'chromadb.utils.delete_file', 'chromadb.utils.distance_functions', 'chromadb.utils.embedding_functions', 'chromadb.utils.lru_cache', 'chromadb.utils.messageid', 'chromadb.utils.read_write_lock', 'chromadb.utils.rendezvous_hash'],
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
    name='main',
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
