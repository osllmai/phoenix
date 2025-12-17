from src.config_loader import ConfigLoader
from src.pdf_summary.pdf_summary_database_builder import PDFSummaryDatabaseBuilder
from src.pdf_summary.pdf_summary_query_runner import PDFSummaryQueryRunner
from src.pdf_chunk.pdf_chunk_database_builder import PDFChunkDatabaseBuilder
from src.pdf_chunk.pdf_chunk_query_runner import PDFChunkQueryRunner

def main():
    # Load config
    config = ConfigLoader.load("E:/ChromaDB/config/config.json")

    # --- MODE HANDLING ---
    if config.mode == "summary":
        # STEP 1 → Build Summary Database
        builder = PDFSummaryDatabaseBuilder(config)
        builder.run()

        # STEP 2 → Run Query
        query_runner = PDFSummaryQueryRunner(config)
        query_runner.run()

    elif config.mode == "chunk":
        # STEP 1 → Build Summary Database
        builder = PDFChunkDatabaseBuilder(config)
        builder.run()

        # STEP 2 → Run Query
        query_runner = PDFChunkQueryRunner(config)
        query_runner.run()

    elif config.mode == "both":
        print(f"Unknown mode '{config.mode}'. Expected: summary | chunk | both.")
    else:
        print(f"Unknown mode '{config.mode}'. Expected: summary | chunk | both.")


if __name__ == "__main__":
    main()
