# full_script.py
import os
import sys
import json
import re
import fitz
from sentence_transformers import SentenceTransformer
import torch
from sklearn.metrics.pairwise import cosine_similarity
import numpy as np

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


def extract_sections(pdf_path, password):
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

        if current:
            cleaned = stripped.strip()

            if cleaned.endswith("."):
                sections[current] += cleaned + "\n\n"
            else:
                sections[current] += cleaned + "\n"

    return sections, order


def count_words(text):
    return len([w for w in text.split() if w.strip()])


def semantic_paragraph_chunking(
    text,
    model,
    threshold,
    title,
    idx,
    chunk_words,
    min_chunk_length,
    query_emb=None,
    min_paragraph_similarity=0.5
):
    paragraphs = [p.strip() for p in re.split(r'\n\s*\n', text) if p.strip()]

    if len(paragraphs) == 0:
        paragraphs = [p.strip() for p in text.split('\n') if p.strip()]

    if len(paragraphs) == 0:
        return []

    # encode paragraphs
    para_embeddings = model.encode(paragraphs, show_progress_bar=False)
    para_embeddings = np.array(para_embeddings)

    # if query_emb provided, compute similarity per paragraph and filter
    para_sims = None
    kept_indices = list(range(len(paragraphs)))
    if query_emb is not None:
        q_emb = np.array(query_emb)
        sims = cosine_similarity([q_emb], para_embeddings)[0]  # shape (N,)
        para_sims = sims
        # Keep paragraphs with sim >= min_paragraph_similarity
        kept_indices = [i for i, s in enumerate(sims) if s >= min_paragraph_similarity]

    # If nothing kept, return empty
    if not kept_indices:
        return []

    # Build filtered paragraphs and their embeddings and similarity list
    filtered_paragraphs = []
    filtered_embeddings = []
    filtered_paragraph_sims = []
    for i in kept_indices:
        filtered_paragraphs.append(paragraphs[i])
        filtered_embeddings.append(para_embeddings[i])
        filtered_paragraph_sims.append(float(para_sims[i]) if para_sims is not None else None)

    # Now do semantic chunking on filtered_paragraphs
    chunks = []
    cidx = 0
    i = 0
    N = len(filtered_paragraphs)
    # ensure numpy array for embeddings
    filtered_embeddings = np.array(filtered_embeddings)

    while i < N:
        p = filtered_paragraphs[i]
        p_words = count_words(p)

        if p_words > chunk_words:
            # single large paragraph -> single chunk
            sim_pct = (filtered_paragraph_sims[i] * 100) if filtered_paragraph_sims[i] is not None else None
            chunks.append((p, {
                "section_title": title,
                "section_index": idx,
                "chunk_index": cidx,
                "word_count": p_words,
                "similarity_pct": sim_pct
            }))
            cidx += 1
            i += 1
            continue

        current_paras = [p]
        current_words = p_words
        last_emb = filtered_embeddings[i]
        sim_values = [filtered_paragraph_sims[i]] if filtered_paragraph_sims[i] is not None else []

        j = i + 1
        while j < N:
            candidate = filtered_paragraphs[j]
            cand_words = count_words(candidate)
            combined_words = current_words + cand_words

            if combined_words > chunk_words:
                break

            cand_emb = filtered_embeddings[j]
            sim = cosine_similarity([last_emb], [cand_emb])[0][0]

            if sim >= threshold:
                current_paras.append(candidate)
                current_words = combined_words
                last_emb = cand_emb
                # collect paragraph-level similarity
                if filtered_paragraph_sims[j] is not None:
                    sim_values.append(filtered_paragraph_sims[j])
                j += 1
                continue
            else:
                break

        chunk_text = "\n\n".join(current_paras)
        # compute mean similarity_pct for chunk (if available)
        sim_pct = None
        if sim_values:
            sim_pct = float(np.mean(sim_values) * 100.0)

        chunks.append((chunk_text, {
            "section_title": title,
            "section_index": idx,
            "chunk_index": cidx,
            "word_count": current_words,
            "similarity_pct": sim_pct
        }))
        cidx += 1

        if j == i + 1:
            i += 1
        else:
            i = j

    return chunks


def embed_chunks(chunks, model):
    texts = [c[0] for c in chunks]
    metas = [c[1] for c in chunks]

    if not texts:
        return []

    embeddings = model.encode(texts, show_progress_bar=True)
    result = []

    for t, m, e in zip(texts, metas, embeddings):
        # ensure similarity_pct is present in meta (could be None)
        result.append({
            "embedding": e.tolist(),
            "chunk": t,
            "meta": m
        })

    return result


def save_json(path, data, auto_create):
    if auto_create:
        os.makedirs(os.path.dirname(path), exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        json.dump(data, f, indent=2, ensure_ascii=False)


def process_pdf_mode(config, model, query_emb):
    important = set(config["settings"]["filter_sections"])
    threshold = config["settings"]["semantic_threshold"]
    chunk_words = config["settings"].get("chunk_words", 200)
    min_chunk_length = config["settings"].get("min_chunk_length", 80)
    min_paragraph_similarity = config["settings"].get("min_paragraph_similarity", 0.5)

    for file in config["files"]:
        sections, order = extract_sections(file["pdf"], config["settings"]["pdf_password"])
        all_chunks = []
        per_file_paragraph_sims = []

        for idx, title in enumerate(order):
            if title not in important:
                continue

            text = sections[title]

            if config["settings"].get("lowercase", False):
                text = text.lower()

            if config["settings"].get("remove_newlines", False):
                text = text.replace("\r", "\n")

            ch = semantic_paragraph_chunking(
                text,
                model,
                threshold,
                title,
                idx,
                chunk_words,
                min_chunk_length,
                query_emb=query_emb,
                min_paragraph_similarity=min_paragraph_similarity
            )
            # ch: list of (chunk_text, meta) with meta["similarity_pct"] maybe set
            # collect similarity values for file-level metadata
            for chunk_text, meta in ch:
                if meta.get("similarity_pct") is not None:
                    per_file_paragraph_sims.append(meta["similarity_pct"] / 100.0)
            all_chunks.extend(ch)

        # embed chunks
        embedded_chunks = embed_chunks(all_chunks, model)

        # compute file-level similarity as mean of paragraph sims (if any)
        file_similarity = None
        if per_file_paragraph_sims:
            file_similarity = float(np.mean(per_file_paragraph_sims) * 100.0)

        # attach file-level info into saved structure
        out_obj = {
            "file": file["pdf"],
            "file_similarity_pct": file_similarity,
            "chunks": embedded_chunks
        }

        save_json(file["output"], out_obj, config["settings"]["output_dir_auto_create"])


def process_arxiv_mode(config, model, query_emb):
    arxiv_files = config.get("arxiv_files", [])
    if not arxiv_files:
        return

    out_path = config["arxiv_output"]
    settings = config["settings"]
    all_outputs = []

    # encode all summaries first
    summaries = [entry["summary"] for entry in arxiv_files]
    titles = [entry.get("title", "") for entry in arxiv_files]
    if not summaries:
        return

    summary_embeddings = model.encode(summaries, show_progress_bar=True)
    # compute similarity to query_emb
    sims = cosine_similarity([query_emb], summary_embeddings)[0]  # shape (M,)

    indexed = []
    for i, (t, s, emb) in enumerate(zip(titles, summaries, summary_embeddings)):
        indexed.append({
            "index": i,
            "title": t,
            "summary": s,
            "embedding": emb,
            "similarity": float(sims[i])
        })

    # sort by similarity desc and take top k
    top_k = min(10, len(indexed))
    indexed_sorted = sorted(indexed, key=lambda x: x["similarity"], reverse=True)[:top_k]

    # build output entries
    for entry in indexed_sorted:
        out = {
            "arxiv_title": entry["title"],
            "type": "summary",
            "chunk_index": 0,
            "word_count": count_words(entry["summary"]),
            "similarity_pct": float(entry["similarity"] * 100.0),
            "embedding": entry["embedding"].tolist(),
            "chunk": entry["summary"]
        }
        all_outputs.append(out)

    # Save a top-level object
    out_obj = {
        "query_text_present": True,
        "query_text_length": count_words(config["settings"]["query_text"]),
        "top_k": top_k,
        "results": all_outputs
    }

    save_json(out_path, out_obj, settings.get("output_dir_auto_create", True))


def main():
    if len(sys.argv) != 2:
        print("Error: config file required.")
        return

    config = json.load(open(sys.argv[1], "r", encoding="utf-8"))

    if "settings" not in config:
        print("Error: 'settings' missing in config.")
        return

    if "query_text" not in config["settings"]:
        print("Error: 'query_text' missing in config['settings']. Please add the text you want to compare to as 'query_text'.")
        return

    model = SentenceTransformer(config["settings"]["embedding_model"])

    if config["settings"].get("use_gpu", False) and torch.cuda.is_available():
        model = model.to("cuda")

    # Precompute query embedding
    query_text = config["settings"]["query_text"]
    query_emb = model.encode([query_text], show_progress_bar=False)[0]

    # run modes
    process_pdf_mode(config, model, query_emb)
    process_arxiv_mode(config, model, query_emb)


if __name__ == "__main__":
    main()
