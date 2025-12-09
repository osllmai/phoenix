from PyInstaller.utils.hooks import collect_submodules

hiddenimports = []
hiddenimports += collect_submodules('chromadb')
hiddenimports += collect_submodules('chromadb.api')
hiddenimports += collect_submodules('chromadb.db')
hiddenimports += collect_submodules('chromadb.ingest')
hiddenimports += collect_submodules('chromadb.migrations')
hiddenimports += collect_submodules('chromadb.telemetry')
hiddenimports += collect_submodules('chromadb.telemetry.product')
hiddenimports += collect_submodules('chromadb.telemetry.product.posthog')
hiddenimports += collect_submodules('chromadb.utils')
