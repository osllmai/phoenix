from sentence_transformers import SentenceTransformer
from typing import List
import numpy as np


class EmbeddingGenerator:
    """Generates text embeddings using SentenceTransformer."""

    def __init__(self, model_path: str, use_gpu: bool = True):
        device = "cuda" if use_gpu else "cpu"
        self.model = SentenceTransformer(model_path, device=device)

    def embed(self, texts: List[str]) -> np.ndarray:
        return self.model.encode(
            texts,
            convert_to_numpy=True,
            show_progress_bar=True
        )
