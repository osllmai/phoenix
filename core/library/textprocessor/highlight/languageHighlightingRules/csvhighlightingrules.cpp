#include "csvhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> csvHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Values inside double quotes
        rule.pattern = QRegularExpression(R"(".*?")");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numbers
        rule.pattern = QRegularExpression(R"(\b\d+(\.\d+)?\b)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Separators (comma)
        rule.pattern = QRegularExpression(",");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
        highlightingRules.append(rule);

        // Headers (assuming first row or capitalized words)
        rule.pattern = QRegularExpression(R"(\b[A-Z_][A-Z0-9_]*\b)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
