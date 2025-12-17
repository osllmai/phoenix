import json
from src.embedding.embedding_generator import EmbeddingGenerator
from src.database.chroma_manager import PDFVectorDatabase
from src.config_loader import AppConfig


class PDFChunkQueryRunner:

    def __init__(self, config: AppConfig):
        self.config = config
        self.embedder = EmbeddingGenerator(
            model_path=config.embedding.embedding_model,
            use_gpu=config.embedding.use_gpu
        )
        self.chroma = PDFVectorDatabase(
            db_path=config.database.chroma_db_path
        )

    def run(self):
        print("-> Running summary search query...")

        # --- Embed Query ---
        query_embedding = self.embedder.embed(
            [self.config.database.query_text]
        )[0]

        # --- Query Summary Vectors ---
        results = self.chroma.query_chunks_vectors(
            conversation_id=self.config.database.conversation_id,
            query_embedding=query_embedding,
            top_k=self.config.database.top_k_results
        )

        # --- Save Output ---
        with open(self.config.output_file, "w", encoding="utf-8") as f:
            json.dump(results, f, indent=4, ensure_ascii=False)

        print(f"- Query results saved to: {self.config.output_file}\n")
