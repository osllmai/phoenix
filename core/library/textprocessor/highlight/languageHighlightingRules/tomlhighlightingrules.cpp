#include "tomlhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> tomlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // TOML keys (e.g., key = value)
        rule.pattern = QRegularExpression("^\\w+\\s*=");
        rule.format = (HighlightingCategory::Key);
        highlightingRules.append(rule);

        // Strings (e.g., "some value" or 'some value')
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numbers (e.g., 123, 45.67)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Dates (e.g., 1979-05-27T07:32:00Z)
        rule.pattern = QRegularExpression("\\d{4}-\\d{2}-\\d{2}T\\d{2}:\\d{2}:\\d{2}Z");
        rule.format = (HighlightingCategory::Date);
        highlightingRules.append(rule);

        // Booleans (e.g., true, false)
        rule.pattern = QRegularExpression("\\b(true|false)\\b");
        rule.format = (HighlightingCategory::Boolean);
        highlightingRules.append(rule);

        // Comments (e.g., # this is a comment)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
