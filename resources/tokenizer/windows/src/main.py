import sys
from src.config_loader import ConfigLoader
from src.pdf_summary.pdf_summary_database_builder import PDFSummaryDatabaseBuilder
from src.pdf_summary.pdf_summary_query_runner import PDFSummaryQueryRunner
from src.pdf_chunk.pdf_chunk_database_builder import PDFChunkDatabaseBuilder
from src.pdf_chunk.pdf_chunk_query_runner import PDFChunkQueryRunner

def main():
    # ------------------------------
    # Read config.json from argument
    # ------------------------------
    if len(sys.argv) < 2:
        print("Error: No config.json provided.\nUsage: tokenizer.exe <config_path>")
        return

    config_path = sys.argv[1]
    print(f"Loading config: {config_path}")

    # Load config
    config = ConfigLoader.load(config_path)

    # --- MODE HANDLING ---
    if config.mode == "summary":
        builder = PDFSummaryDatabaseBuilder(config)
        builder.run()

        query_runner = PDFSummaryQueryRunner(config)
        query_runner.run()

    elif config.mode == "chunk":
        builder = PDFChunkDatabaseBuilder(config)
        builder.run()

        query_runner = PDFChunkQueryRunner(config)
        query_runner.run()

    elif config.mode == "both":
        print(f"Unknown mode '{config.mode}'. Expected: summary | chunk | both.")
    else:
        print(f"Unknown mode '{config.mode}'. Expected: summary | chunk | both.")


if __name__ == "__main__":
    main()
