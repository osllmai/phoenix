#include "markdownhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> markdownHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Headers (e.g., # Header, ## Subheader)
        rule.pattern = QRegularExpression("^#.*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);  // Can be customized to Header category
        highlightingRules.append(rule);

        // Links (e.g., [Link Text](http://example.com))
        rule.pattern = QRegularExpression("\\[.*?\\]\\(.*?\\)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Link);
        highlightingRules.append(rule);

        // Bold text (e.g., **bold text** or __bold text__)
        rule.pattern = QRegularExpression("\\*\\*.*?\\*\\*|__.*?__");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Bold);
        highlightingRules.append(rule);

        // Italics text (e.g., *italic text* or _italic text_)
        rule.pattern = QRegularExpression("\\*.*?\\*|_.*?_");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Italic);
        highlightingRules.append(rule);

        // Lists (e.g., - Item or * Item)
        rule.pattern = QRegularExpression("^[-*]\\s+.*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::List);
        highlightingRules.append(rule);

        // Code blocks (e.g., ``` code block ```
        rule.pattern = QRegularExpression("```.*```");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::CodeBlock);
        highlightingRules.append(rule);

        // Inline code (e.g., `code`)
        rule.pattern = QRegularExpression("`.*?`");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Code);
        highlightingRules.append(rule);

        // Comments (e.g., <!-- comment -->)
        rule.pattern = QRegularExpression("<!--.*?-->");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
