from typing import List
from src.embedding.embedding_generator import EmbeddingGenerator
from src.database.chroma_manager import PDFVectorDatabase
from src.config_loader import AppConfig


# -----------------------------
#       PDF SUMMARY DATABASE BUILDER
# -----------------------------
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
        self.chroma = PDFVectorDatabase(
            db_path=config.database.chroma_db_path
        )

    def run(self):
        print("-> Building summary vector database...")

        for idx, paper in enumerate(self.config.papers):
            summary = paper.get("summary", "").strip()
            title = paper.get("title", f"untitled_{idx}")

            if not summary:
                print(f"+ No summary found for paper: {title}. Skipped embedding.")
                continue

            summary_embedding = self.embedder.embed([summary])[0]

            summary_id = f"summary_{self.config.database.conversation_id}_{idx}"

            metadata = {
                "title": title,
                "pdf_file": paper.get("pdf", ""),
                "conversation_id": self.config.database.conversation_id,
                "type": "summary"
            }

            self.chroma.add_summary(
                summary_id=summary_id,
                summary_text=summary,
                summary_embedding=summary_embedding,
                metadata=metadata
            )

        print("- Summary database updated successfully.\n")
