#include "jsonhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> jsonHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // JSON keys (e.g., "name", "age")
        rule.pattern = QRegularExpression("\"([^\"]+)\"(?=\\s*:)"); // Match strings before the colon (key)
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Key);
        highlightingRules.append(rule);

        // JSON values (strings)
        rule.pattern = QRegularExpression("\"([^\"]*)\""); // Match string values
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numeric literals
        rule.pattern = QRegularExpression("-?\\b\\d+(\\.\\d+)?\\b"); // Match integers or decimals
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Boolean literals (true, false)
        rule.pattern = QRegularExpression("\\b(true|false)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Null value
        rule.pattern = QRegularExpression("\\bnull\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Comments (in JSON files, comments are not officially supported, but they might appear in some variants)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Comments in block form (e.g., /* comment */)
        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
