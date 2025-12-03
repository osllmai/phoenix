import os
import sys
import json
import re
import fitz
from sentence_transformers import SentenceTransformer
import torch
from sklearn.metrics.pairwise import cosine_similarity

# ---------------------------------------------------------
# CONSTANTS
# ---------------------------------------------------------

IMPORTANT_SECTIONS = [
    "abstract", "introduction", "methods", "materials and methods",
    "methodology", "results", "findings", "evaluation",
    "discussion", "results and discussion", "conclusion",
    "conclusions", "summary"
]

ALL_SECTIONS = IMPORTANT_SECTIONS + [
    "background", "related work", "future work", "limitations"
]

# ---------------------------------------------------------
# BUILD SECTION REGEX
# ---------------------------------------------------------

def build_section_regex(sections):
    escaped = [re.escape(s) for s in sections]
    return re.compile(r"^\s*(\d+[\.\-]*)?\s*(" + "|".join(escaped) + r")\s*$", re.IGNORECASE)

# ---------------------------------------------------------
# PDF SECTION EXTRACTION
# ---------------------------------------------------------

def extract_sections(pdf_path, password):
    doc = fitz.open(pdf_path)
    if doc.needs_pass and password:
        doc.authenticate(password)

    text = "\n".join(page.get_text() for page in doc)
    lines = [l.strip() for l in text.split("\n") if l.strip()]
    pattern = build_section_regex(ALL_SECTIONS)

    sections = {}
    order = []
    current = None

    for line in lines:
        match = pattern.match(line.lower())
        if match:
            title = match.group(2).lower()
            current = title
            if title not in sections:
                sections[title] = ""
                order.append(title)
            continue

        if current:
            sections[current] += line + " "

    return sections, order

# ---------------------------------------------------------
# SEMANTIC PARAGRAPH CHUNKING
# ---------------------------------------------------------

def semantic_paragraph_chunking(text, model, threshold, title, idx):
    paragraphs = [p.strip() for p in text.split("\n\n") if p.strip()]

    if len(paragraphs) == 1:
        return [(paragraphs[0], {"section_title": title, "section_index": idx, "chunk_index": 0})]

    embeddings = model.encode(paragraphs)
    chunks = []
    current = [paragraphs[0]]
    cidx = 0

    for i in range(1, len(paragraphs)):
        sim = cosine_similarity([embeddings[i]], [embeddings[i - 1]])[0][0]

        if sim < threshold:
            chunks.append((" ".join(current), {
                "section_title": title,
                "section_index": idx,
                "chunk_index": cidx
            }))
            current = []
            cidx += 1

        current.append(paragraphs[i])

    if current:
        chunks.append((" ".join(current), {
            "section_title": title,
            "section_index": idx,
            "chunk_index": cidx
        }))

    return chunks

# ---------------------------------------------------------
# EMBEDDING
# ---------------------------------------------------------

def embed_chunks(chunks, model):
    texts = [c[0] for c in chunks]
    metas = [c[1] for c in chunks]

    embeddings = model.encode(texts, show_progress_bar=True)
    result = []

    for t, m, e in zip(texts, metas, embeddings):
        result.append({
            "embedding": e.tolist(),
            "chunk": t,
            "meta": m
        })

    return result

# ---------------------------------------------------------
# SAVE JSON
# ---------------------------------------------------------

def save_json(path, data, auto_create):
    if auto_create:
        os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)

# ---------------------------------------------------------
# MODE 1: PROCESS PDFs
# ---------------------------------------------------------

def process_pdf_mode(config, model):
    important = set(config["settings"]["filter_sections"])
    threshold = config["settings"]["semantic_threshold"]

    for file in config["files"]:
        sections, order = extract_sections(file["pdf"], config["settings"]["pdf_password"])
        chunks = []

        for idx, title in enumerate(order):
            if title not in important:
                continue

            text = sections[title]

            if config["settings"]["lowercase"]:
                text = text.lower()

            if config["settings"]["remove_newlines"]:
                text = text.replace("\n", " ")

            ch = semantic_paragraph_chunking(text, model, threshold, title, idx)
            chunks.extend(ch)

        embedded_chunks = embed_chunks(chunks, model)
        save_json(file["output"], embedded_chunks, config["settings"]["output_dir_auto_create"])

# ---------------------------------------------------------
# MODE 2: PROCESS ARXIV SUMMARIES
# ---------------------------------------------------------

def process_arxiv_mode(config, model):
    arxiv_files = config.get("arxiv_files", [])
    if not arxiv_files:
        return

    out_path = config["arxiv_output"]
    settings = config["settings"]
    all_outputs = []

    for entry in arxiv_files:
        title = entry["title"]
        summary = entry["summary"]

        # A single chunk = summary only
        chunks = [
            (summary, {
                "arxiv_title": title,
                "type": "summary",
                "chunk_index": 0
            })
        ]

        result = embed_chunks(chunks, model)
        all_outputs.extend(result)

    save_json(out_path, all_outputs, settings.get("output_dir_auto_create", True))

# ---------------------------------------------------------
# MAIN
# ---------------------------------------------------------

def main():
    if len(sys.argv) != 2:
        print("Error: config file required.")
        return

    config = json.load(open(sys.argv[1], "r", encoding="utf-8"))

    model = SentenceTransformer(config["settings"]["embedding_model"])

    if config["settings"]["use_gpu"] and torch.cuda.is_available():
        model = model.to("cuda")

    # Run PDF mode
    process_pdf_mode(config, model)

    # Run Arxiv Summary Mode
    process_arxiv_mode(config, model)


if __name__ == "__main__":
    main()
