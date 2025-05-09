#include "tomlhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> tomlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // TOML keys (e.g., key = value)
        rule.pattern = QRegularExpression("^\\w+\\s*=");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Key);
        highlightingRules.append(rule);

        // Strings (e.g., "some value" or 'some value')
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numbers (e.g., 123, 45.67)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Dates (e.g., 1979-05-27T07:32:00Z)
        rule.pattern = QRegularExpression("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Date);
        highlightingRules.append(rule);

        // Booleans (e.g., true, false)
        rule.pattern = QRegularExpression("\\b(true|false)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Boolean);
        highlightingRules.append(rule);

        // Comments (e.g., # this is a comment)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
