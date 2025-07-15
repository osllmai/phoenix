import sys
from pathlib import Path
import logging
from docling.document_converter import DocumentConverter

logging.basicConfig(level=logging.INFO)
_log = logging.getLogger(__name__)

def main():
    if len(sys.argv) < 2:
        print("Usage: converter <input-file-path>")
        sys.exit(1)


    try:
        converter = DocumentConverter()
        print("[INFO] Initializing DocumentConverter...")

        doc_and_meta = converter.convert(Path(sys.argv[1]))
        print("[INFO] Conversion complete.")

        print("[INFO] Exporting to Markdown...")
        md_text = doc_and_meta.document.export_to_markdown()

        print("[INFO] Markdown Export complete.\n\n---- BEGIN MARKDOWN ----\n")
        print(md_text)
        print("\n---- END MARKDOWN ----")

    except Exception as e:
        print(f"[ERROR] Conversion failed: {e}")
        sys.exit(2)

if __name__ == "__main__":
    main()
