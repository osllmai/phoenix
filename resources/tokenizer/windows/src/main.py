import sys
import argparse

from src.config_loader import ConfigLoader
from src.pdf_summary.pdf_summary_database_builder import PDFSummaryDatabaseBuilder
from src.pdf_summary.pdf_summary_query_runner import PDFSummaryQueryRunner
from src.pdf_chunk.pdf_chunk_database_builder import PDFChunkDatabaseBuilder
from src.pdf_chunk.pdf_chunk_query_runner import PDFChunkQueryRunner


def main():
    # ---------------- ARGUMENT PARSING ----------------
    parser = argparse.ArgumentParser(
        description="PDF Processing Tool (Summary / Chunk / Both)"
    )
    parser.add_argument(
        "config",
        type=str,
        help="Path to config.json file"
    )

    args = parser.parse_args()
    config_path = args.config

    # ---------------- LOAD CONFIG ----------------
    try:
        config = ConfigLoader.load(config_path)
    except Exception as e:
        print(f"[ERROR] Failed to load config file: {e}")
        sys.exit(1)

    # ---------------- MODE HANDLING ----------------
    if config.mode == "summary":
        # STEP 1 → Build Summary Database
        builder = PDFSummaryDatabaseBuilder(config)
        builder.run()

        # STEP 2 → Run Query
        query_runner = PDFSummaryQueryRunner(config)
        query_runner.run()

    elif config.mode == "chunk":
        # STEP 1 → Build Chunk Database
        builder = PDFChunkDatabaseBuilder(config)
        builder.run()

        # STEP 2 → Run Query
        query_runner = PDFChunkQueryRunner(config)
        query_runner.run()

    elif config.mode == "both":
        print("[INFO] Mode 'both' is not implemented yet.")
    else:
        print(f"[ERROR] Unknown mode '{config.mode}'. Expected: summary | chunk | both.")
        sys.exit(1)


if __name__ == "__main__":
    main()
