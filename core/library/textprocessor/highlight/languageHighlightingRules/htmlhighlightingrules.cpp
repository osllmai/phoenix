#include "htmlhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> htmlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // HTML tags (e.g., <html>, <body>, <div>, <p>, etc.)
        rule.pattern = QRegularExpression("</?\\w+>");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Tag);
        highlightingRules.append(rule);

        // HTML tag attributes (e.g., class="value", id="value")
        rule.pattern = QRegularExpression("\\b\\w+(?==\")");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Attribute);
        highlightingRules.append(rule);

        // Attribute values (e.g., "value" in class="value")
        rule.pattern = QRegularExpression("(?<=\\=\")[^\"]*(?=\")");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Value);
        highlightingRules.append(rule);

        // HTML comments (e.g., <!-- comment -->)
        rule.pattern = QRegularExpression("<!--[\\s\\S]*?-->");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // JavaScript within script tags (e.g., <script> ... </script>)
        rule.pattern = QRegularExpression("<script[\\s\\S]*?</script>");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Script);
        highlightingRules.append(rule);

        // CSS within style tags (e.g., <style> ... </style>)
        rule.pattern = QRegularExpression("<style[\\s\\S]*?</style>");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Style);
        highlightingRules.append(rule);

        // HTML Doctype declaration (e.g., <!DOCTYPE html>)
        rule.pattern = QRegularExpression("<!DOCTYPE[\\s\\S]*?>");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Doctype);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 123, 3.14)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
