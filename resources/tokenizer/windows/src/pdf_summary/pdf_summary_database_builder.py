from typing import List
from src.embedding.embedding_generator import EmbeddingGenerator
from src.database.chroma_manager import PDFVectorDatabase
from src.config_loader import AppConfig


class PDFSummaryDatabaseBuilder:
    """
    Builds and updates the summary database.
    Uses collection: PDFSummaryVectors
    """

    def __init__(self, config: AppConfig):
        self.config = config
        self.embedder = EmbeddingGenerator(
            config.embedding.embedding_model,
            config.embedding.use_gpu
        )
        # Always use PDFSummaryVectors collection
        self.chroma = PDFVectorDatabase(
            db_path=config.database.chroma_db_path
        )

    def run(self):
        print("Building summary vector database...")

        for idx, paper in enumerate(self.config.papers):
            summary = paper.get("summary", "").strip()

            if not summary:
                print(f"No summary found for paper: {paper.get('title', 'UNKNOWN')}. Skipped embedding.")
                continue

            summary_embedding = self.embedder.embed([summary])[0]

            summary_id = f"summary_{self.config.database.conversation_id}_{idx}"

            metadata = {
                "title": paper.get("title", ""),
                "pdf_file": paper.get("pdf") or "",
                "conversation_id": self.config.database.conversation_id,
                "type": "summary"
            }

            self.chroma.add_summary(
                summary_id=summary_id,
                summary_text=summary,
                summary_embedding=summary_embedding,
                metadata=metadata
            )

        print("Summary database updated successfully.\n")
