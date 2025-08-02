import sys
from pathlib import Path
from markitdown import MarkItDown

def main():
    if len(sys.argv) < 2:
        print("Usage: convert_pdf <input-file.pdf>")
        sys.exit(1)

    input_path = Path(sys.argv[1])
    if not input_path.exists():
        print(f"[ERROR] File not found: {input_path}")
        sys.exit(1)

    try:
        md = MarkItDown(docintel_endpoint="<your_https_document_intelligence_endpoint>")
        result = md.convert(str(input_path))

        output_path = input_path.with_suffix(".md")
        output_path.write_text(result.text_content, encoding="utf-8")

        print(f"[INFO] Markdown saved to: {output_path}")

    except Exception as e:
        print(f"[ERROR] Conversion failed: {e}")
        sys.exit(2)

if __name__ == "__main__":
    main()
 