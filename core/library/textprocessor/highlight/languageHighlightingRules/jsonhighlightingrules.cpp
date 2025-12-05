#include "jsonhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> jsonHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // JSON keys (e.g., "name", "age")
        rule.pattern = QRegularExpression("\"([^\"]+)\"(?=\\s*:)"); // Match strings before the colon (key)
        rule.format = (HighlightingCategory::Key);
        highlightingRules.append(rule);

        // JSON values (strings)
        rule.pattern = QRegularExpression("\"([^\"]*)\""); // Match string values
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numeric literals
        rule.pattern = QRegularExpression("-?\\b\\d+(\\.\\d+)?\\b"); // Match integers or decimals
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Boolean literals (true, false)
        rule.pattern = QRegularExpression("\\b(true|false)\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Null value
        rule.pattern = QRegularExpression("\\bnull\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Comments (in JSON files, comments are not officially supported, but they might appear in some variants)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Comments in block form (e.g., /* comment */)
        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
