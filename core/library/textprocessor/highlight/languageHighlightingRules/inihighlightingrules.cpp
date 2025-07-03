#include "inihighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> iniHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Sections (e.g., [section])
        rule.pattern = QRegularExpression("\\[.*?\\]");
        rule.format = (HighlightingCategory::Section);
        highlightingRules.append(rule);

        // Keys (e.g., key= value)
        rule.pattern = QRegularExpression("^\\s*\\w+\\s*(?==)");
        rule.format = (HighlightingCategory::Key);
        highlightingRules.append(rule);

        // Values (e.g., key=value)
        rule.pattern = QRegularExpression("(?<=\\=).*");
        rule.format = (HighlightingCategory::Value);
        highlightingRules.append(rule);

        // Comments (e.g., ; comment or # comment)
        rule.pattern = QRegularExpression("^[;#].*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
