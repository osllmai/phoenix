#include "inihighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> iniHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Sections (e.g., [section])
        rule.pattern = QRegularExpression("\\[.*?\\]");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Section);
        highlightingRules.append(rule);

        // Keys (e.g., key= value)
        rule.pattern = QRegularExpression("^\\s*\\w+\\s*(?==)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Key);
        highlightingRules.append(rule);

        // Values (e.g., key=value)
        rule.pattern = QRegularExpression("(?<=\\=).*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Value);
        highlightingRules.append(rule);

        // Comments (e.g., ; comment or # comment)
        rule.pattern = QRegularExpression("^[;#].*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
