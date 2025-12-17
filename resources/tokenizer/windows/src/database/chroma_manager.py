import chromadb
from typing import List, Dict, Any
import numpy as np
import hashlib
import os

# ============================================================
# Disable telemetry completely
# ============================================================
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


# ============================================================
# Utils
# ============================================================
def hash_text(text: str) -> str:
    return hashlib.sha256(text.encode("utf-8")).hexdigest()


def hash_list(data: List[str]) -> str:
    joined = "||".join(data)
    return hashlib.sha256(joined.encode("utf-8")).hexdigest()


# ============================================================
# PDF Vector Database
# ============================================================
class PDFVectorDatabase:
    """
    Manages:
    1. PDF summaries (one per PDF)
    2. PDF chunks (multiple per PDF)
    All operations are scoped by conversation_id
    """

    def __init__(self, db_path: str):
        self.client = chromadb.PersistentClient(
            path=db_path,
        )

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
    # Internal checks
    # ============================================================

    def _conversation_exists(self, collection, conversation_id: int) -> bool:
        res = collection.get(
            where={"conversation_id": conversation_id},
            limit=1
        )
        return len(res.get("ids", [])) > 0

    # ============================================================
    # SUMMARY MANAGEMENT
    # ============================================================

    def add_summary(
        self,
        summary_id: str,
        summary_text: str,
        summary_embedding: np.ndarray,
        metadata: Dict[str, Any]
    ):
        """
        metadata must include:
        {
            "title": str,
            "pdf_file": str,
            "conversation_id": int,
            "type": "summary"
        }
        """

        conversation_id = metadata["conversation_id"]
        text_hash = hash_text(summary_text)

        # Check if same summary already exists
        existing = self.summary_collection.get(
            where={
                "$and": [
                    {"conversation_id": conversation_id},
                    {"pdf_file": metadata.get("pdf_file", "")},
                    {"type": "summary"}
                ]
            }
        )


        if existing.get("ids"):
            old_hash = existing["metadatas"][0].get("hash")
            if old_hash == text_hash:
                print("✓ Summary already exists → skipped")
                return
            else:
                self.summary_collection.delete(ids=existing["ids"])

        metadata["hash"] = text_hash

        self.summary_collection.add(
            ids=[summary_id],
            embeddings=[summary_embedding.tolist()],
            documents=[summary_text],
            metadatas=[metadata]
        )

        print(f"✓ Summary stored for conversation {conversation_id}")

    def query_summary_vectors(
        self,
        conversation_id: int,
        query_embedding: np.ndarray,
        top_k: int
    ):
        return self.summary_collection.query(
            query_embeddings=[query_embedding.tolist()],
            n_results=top_k,
            where={"conversation_id": conversation_id}
        )

    # ============================================================
    # CHUNK MANAGEMENT
    # ============================================================

    def add_pdf_chunks(
        self,
        pdf_path: str,
        conversation_id: int,
        chunks: List[str],
        embeddings: np.ndarray
    ):
        """
        Prevents re-storing chunks if the same PDF was already stored
        """

        chunks_hash = hash_list(chunks)

        # Check if this PDF was already chunked
        existing = self.chunk_collection.get(
            where={
                "$and": [
                    {"conversation_id": conversation_id},
                    {"pdf_path": pdf_path}
                ]
            },
            limit=1
        )

        if existing.get("ids"):
            old_hash = existing["metadatas"][0].get("chunks_hash")
            if old_hash == chunks_hash:
                print("✓ PDF chunks already exist → skipped")
                return
            else:
                # Remove old chunks of this PDF
                self.chunk_collection.delete(
                    where={
                        "$and": [
                            {"conversation_id": conversation_id},
                            {"pdf_path": pdf_path}
                        ]
                    }
                )


        ids = [
            f"{conversation_id}_{os.path.basename(pdf_path)}_chunk_{i}"
            for i in range(len(chunks))
        ]

        metadatas = [
            {
                "conversation_id": conversation_id,
                "pdf_path": pdf_path,
                "chunk_index": i,
                "chunks_hash": chunks_hash,
                "type": "chunk"
            }
            for i in range(len(chunks))
        ]

        self.chunk_collection.add(
            ids=ids,
            embeddings=[e.tolist() for e in embeddings],
            documents=chunks,
            metadatas=metadatas
        )

        print(f"✓ {len(chunks)} chunks stored for PDF: {pdf_path}")

    def query_chunks_vectors(
        self,
        conversation_id: int,
        query_embedding: np.ndarray,
        top_k: int
    ):
        return self.chunk_collection.query(
            query_embeddings=[query_embedding.tolist()],
            n_results=top_k,
            where={
                "conversation_id": conversation_id
            }
        )
