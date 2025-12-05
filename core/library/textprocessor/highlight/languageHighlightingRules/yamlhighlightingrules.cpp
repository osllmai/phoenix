#include "yamlhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> yamlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // YAML Keys (e.g., key: value)
        rule.pattern = QRegularExpression("^\\s*\\w+\\s*:");
        rule.format = (HighlightingCategory::Key);
        highlightingRules.append(rule);

        // YAML String values (e.g., "value" or value)
        rule.pattern = QRegularExpression("\"[^\"]*\"|[^:\\n\\r]+");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // YAML Comments (e.g., # This is a comment)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // YAML Lists (e.g., - item1, - item2)
        rule.pattern = QRegularExpression("^\\s*-\\s+[^:]+");
        rule.format = (HighlightingCategory::ListItem);
        highlightingRules.append(rule);

        // YAML Boolean values (e.g., true, false)
        rule.pattern = QRegularExpression("\\b(true|false)\\b");
        rule.format = (HighlightingCategory::Boolean);
        highlightingRules.append(rule);

        // YAML Null values (e.g., null, ~)
        rule.pattern = QRegularExpression("\\b(null|~)\\b");
        rule.format = (HighlightingCategory::Null);
        highlightingRules.append(rule);

        // YAML Numbers (e.g., 123, 3.14)
        rule.pattern = QRegularExpression("\\b\\d+\\.?\\d*\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
