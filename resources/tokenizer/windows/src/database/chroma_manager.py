import chromadb
from chromadb.config import Settings
from typing import List, Dict, Any
import numpy as np
import hashlib
import os

# Disable telemetry completely
os.environ["CHROMADB_TELEMETRY"] = "FALSE"
try:
    chromadb.telemetry = None
except AttributeError:
    pass
try:
    chromadb.utils.telemetry = None
except AttributeError:
    pass
try:
    chromadb.config.telemetry = None
except AttributeError:
    pass

def hash_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


class PDFVectorDatabase:
    """
    Manages two collections:
    1. PDFSummaryVectors — stores vector of each PDF summary
    2. PDFChunksVectors — stores vector of user-generated chunks
    """

    def __init__(self, db_path: str):
        # Create persistent client
        self.client = chromadb.PersistentClient(
            path=db_path,
            settings=Settings()
        )

        # --- Create collections ---
        self.summary_collection = self.client.get_or_create_collection(
            name="PDFSummaryVectors",
            embedding_function=None,
            metadata={"hnsw:space": "cosine"},
        )

        self.chunk_collection = self.client.get_or_create_collection(
            name="PDFChunksVectors",
            embedding_function=None,
            metadata={"hnsw:space": "cosine"},
        )

    # ============================================================
    #                     SUMMARY MANAGEMENT
    # ============================================================

    def add_summary(self, summary_id: str, summary_text: str,
                    summary_embedding: np.ndarray, metadata: Dict[str, Any]):
        text_hash = hash_text(summary_text)
        existing = self.summary_collection.get(ids=[summary_id])
        if existing.get("ids"):
            old_hash = existing["metadatas"][0].get("hash")
            if old_hash == text_hash:
                print(f"✓ Summary unchanged → Skipped: {summary_id}")
                return
            self.summary_collection.delete(ids=[summary_id])

        metadata["hash"] = text_hash
        self.summary_collection.add(
            ids=[summary_id],
            embeddings=[summary_embedding.tolist()],
            metadatas=[metadata],
            documents=[summary_text]
        )
        print(f"✓ Summary stored: {summary_id}")

    def query_summary_vectors(self, query_embedding: np.ndarray, top_k: int):
        return self.summary_collection.query(
            query_embeddings=[query_embedding.tolist()],
            n_results=top_k
        )

    # ============================================================
    #                       CHUNK MANAGEMENT
    # ============================================================

    def add_pdf_chunks(self, conversation_id: str,
                       chunks: List[str],
                       embeddings: np.ndarray):
        ids = [f"{conversation_id}_chunk_{i}" for i in range(len(chunks))]
        metadatas = [{"conversation_id": conversation_id,
                      "chunk_index": i} for i in range(len(chunks))]

        embeddings_list = [emb.tolist() for emb in embeddings]

        self.chunk_collection.add(
            ids=ids,
            embeddings=embeddings_list,
            metadatas=metadatas,
            documents=chunks
        )
        print(f"- {len(chunks)} chunks stored for PDF {conversation_id}.")

    def query_chunks_vectors(self, conversation_id: str,
                             query_embedding: np.ndarray,
                             top_k: int):
        embedding_list = query_embedding.tolist()
        return self.chunk_collection.query(
            query_embeddings=[embedding_list],
            n_results=top_k,
            where={"conversation_id": conversation_id}
        )
