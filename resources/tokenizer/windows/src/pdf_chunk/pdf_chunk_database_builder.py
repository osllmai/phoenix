import os
import json
import re
import numpy as np
import fitz  # PyMuPDF

from typing import List
from src.embedding.embedding_generator import EmbeddingGenerator
from src.database.chroma_manager import PDFVectorDatabase
from src.config_loader import AppConfig
from indoxArcg.splitter import SemanticTextSplitter

IMPORTANT_SECTIONS = [
    "abstract", "introduction", "methods", "materials and methods",
    "methodology", "results", "findings", "evaluation",
    "discussion", "results and discussion", "conclusion",
    "conclusions", "summary"
]

ALL_SECTIONS = IMPORTANT_SECTIONS + [
    "related work", "previous work", "literature review",
    "prior work", "theoretical background", "background", "state of the art",
    "problem statement", "problem definition",
    "research questions", "hypothesis", "aims", "objectives",
    "materials", "data", "dataset", "data collection",
    "data preparation", "data preprocessing",
    "analysis methods", "statistical analysis",
    "experimental procedure", "experimental design",
    "simulation", "procedure", "protocol",
    "performance", "observations", "measurements",
    "data analysis", "numerical results", "simulation results",
    "analysis and discussion", "interpretation",
    "implications", "discussion and implications",
    "validation", "verification", "benchmarks",
    "case study", "case studies", "comparative study",
    "closing remarks", "final comments",
    "outlook", "final summary",
    "future work", "future directions",
    "limitations", "study limitations", "challenges",
    "appendix", "appendices",
    "supplementary material", "acknowledgements",
    "references"
]

def build_section_regex(sections):
    escaped = [re.escape(s) for s in sections]
    joined = "|".join(escaped)

    pattern = rf"""
        ^\s*
        (?:[\#\*\-\_]+)?\s*                
        (?:\d+[\.\-\)\:]*\s+)?             
        (?:[IVXLCDM]+[\.\-\)\:]*\s+)?      
        ({joined})                          
        (?:\s*[\:\-\—\_]+)?                
        (?:[\#\*\-\_]+)?                    
        \s*$
    """
    return re.compile(pattern, re.IGNORECASE | re.VERBOSE)


def extract_sections(pdf_path, password=None):
    doc = fitz.open(pdf_path)
    if getattr(doc, "needs_pass", False) and password:
        doc.authenticate(password)

    text = "\n".join(page.get_text() for page in doc)
    lines = [l.rstrip() for l in text.split("\n")]
    pattern = build_section_regex(ALL_SECTIONS)

    sections = {}
    order = []
    current = None

    for line in lines:
        stripped = line.strip()
        if not stripped:
            continue

        match = pattern.match(stripped)
        if match:
            title = match.group(1).lower()
            current = title

            if title not in sections:
                sections[current] = ""
                order.append(title)

            continue

        if current and current in IMPORTANT_SECTIONS:
            cleaned = stripped.strip()
            if cleaned.endswith("."):
                sections[current] += cleaned + "\n\n"
            else:
                sections[current] += cleaned + "\n"

    return sections, order


class PDFChunkDatabaseBuilder:
    """
    Builds and updates the PDF chunks vector database.
    Uses collection: PDFChunksVectors
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

    # --------------------------------------------------------
    #                      RUN PROCESS
    # --------------------------------------------------------
    def run(self):
        print("-> Building PDF Chunk Vector Database...\n")

        files = self.config.local_files
        if not files:
            print("* No PDF files found in config.local_files.")
            return

        # Create splitter for chunking
        splitter = SemanticTextSplitter(
            chunk_size=self.config.chunking.chunk_words
        )

        conversation_id = str(self.config.database.conversation_id)

        for idx, file_obj in enumerate(files):
            pdf_path = file_obj["pdf"]
            if not os.path.exists(pdf_path):
                print(f"* File not found: {pdf_path}")
                continue

            print(f"\n--- [{idx+1}/{len(files)}] Reading PDF: {pdf_path} ---")

            # -----------------------------
            # 1) Read PDF Text
            # -----------------------------
            try:
                sections, order = extract_sections(pdf_path, password=None)
                content = "\n".join(sections[sec] for sec in order if sec in IMPORTANT_SECTIONS)
            except Exception as e:
                print(f"Error extracting sections from PDF: {pdf_path}")
                print(e)
                continue

            if not content.strip():
                print(f"* No important content extracted from: {pdf_path}")
                continue

            # -----------------------------
            # 2) Semantic Chunking
            # -----------------------------
            print("-> Splitting into chunks...")
            chunks = splitter.split_text(content)

            if not chunks:
                print("* No chunks produced.")
                continue

            print(f"- {len(chunks)} chunks generated.")

            # -----------------------------
            # 3) Embeddings
            # -----------------------------
            print("-> Generating embeddings...")
            embeddings = self.embedder.embed(chunks)
            embeddings = np.array(embeddings)

            # -----------------------------
            # 4) Store in ChromaDB
            # -----------------------------
            pdf_uid = f"{conversation_id}_file_{idx}"
            self.chroma.add_pdf_chunks(
                conversation_id=str(self.config.database.conversation_id),
                chunks=chunks,
                embeddings=embeddings
            )

            print(f"- Stored {len(chunks)} chunks for PDF: {pdf_path}")

            # -----------------------------
            # 5) Save chunks + vectors to JSON
            # -----------------------------
            json_path = os.path.join(
                os.path.dirname(pdf_path),
                os.path.splitext(os.path.basename(pdf_path))[0] + "_chunks.json"
            )

            json_data = {
                "pdf_path": pdf_path,
                "conversation_id": pdf_uid,
                "num_chunks": len(chunks),
                "chunks": chunks,
                "embeddings": embeddings.tolist()  # convert numpy → list
            }

            try:
                with open(json_path, "w", encoding="utf-8") as jf:
                    json.dump(json_data, jf, ensure_ascii=False, indent=4)

                print(f"✓ JSON saved: {json_path}")

            except Exception as e:
                print(f"* Failed to save JSON for {pdf_path}")
                print(e)

        print("\n- Chunk vector database updated successfully.\n")
