import json
from dataclasses import dataclass
from typing import Any, Dict, List, Optional


# -----------------------------
#       DATA MODELS
# -----------------------------

@dataclass
class EmbeddingSettings:
    embedding_model: str
    use_gpu: bool
    language: str
    lowercase: bool
    remove_newlines: bool


@dataclass
class ChunkingSettings:
    chunk_words: int
    chunk_overlap: int
    min_chunk_length: int
    chunking_mode: str
    min_paragraph_similarity: float
    semantic_threshold: float


@dataclass
class DatabaseSettings:
    chroma_db_path: str
    conversation_id: int
    top_k_results: int
    query_text: str


@dataclass
class AppConfig:
    embedding: EmbeddingSettings
    chunking: ChunkingSettings
    database: DatabaseSettings
    papers: List[Dict[str, Any]]
    output_file: str
    pdf_password: Optional[str]
    filter_sections: List[str]
    output_dir_auto_create: bool
    mode: str
    local_files: List[Dict[str, str]]


# -----------------------------
#       CONFIG LOADER
# -----------------------------

class ConfigLoader:
    """Loads and validates application config."""

    @staticmethod
    def load(path: str) -> AppConfig:
        with open(path, "r", encoding="utf-8") as f:
            raw = json.load(f)

        settings = raw["settings"]

        # -------------------------------
        # Embedding settings
        # -------------------------------
        embedding = EmbeddingSettings(
            embedding_model=settings["embedding_model"],
            use_gpu=settings["use_gpu"],
            language=settings.get("language", "en"),
            lowercase=settings.get("lowercase", True),
            remove_newlines=settings.get("remove_newlines", True),
        )

        # -------------------------------
        # Chunk settings
        # -------------------------------
        chunking = ChunkingSettings(
            chunk_words=settings["chunk_words"],
            chunk_overlap=settings["chunk_overlap"],
            min_chunk_length=settings["min_chunk_length"],
            chunking_mode=settings.get("chunking_mode", "semantic"),
            min_paragraph_similarity=settings.get("min_paragraph_similarity", 0.7),
            semantic_threshold=settings.get("semantic_threshold", 0.70)
        )

        # -------------------------------
        # Database settings
        # -------------------------------
        database = DatabaseSettings(
            chroma_db_path=settings["chroma_db_path"],
            conversation_id=settings.get("conversation_id", 0),
            top_k_results=settings.get("top_k_results", 5),
            query_text=settings.get("query_text", ""),
        )

        # -------------------------------
        # Paper list (Arxiv files)
        # -------------------------------
        papers = raw.get("arxiv_files", [])

        # -------------------------------
        # Local file list (files section)
        # -------------------------------
        local_files = raw.get("files", [])

        # -------------------------------
        # Return final validated config
        # -------------------------------
        return AppConfig(
            embedding=embedding,
            chunking=chunking,
            database=database,
            papers=papers,
            output_file=raw.get("output", "output.json"),
            pdf_password=settings.get("pdf_password"),
            filter_sections=settings.get("filter_sections", []),
            output_dir_auto_create=settings.get("output_dir_auto_create", True),
            mode=settings.get("mode", "summary"),
            local_files=local_files
        )
