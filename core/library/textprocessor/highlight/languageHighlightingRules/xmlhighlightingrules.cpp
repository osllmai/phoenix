#include "xmlhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> xmlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // XML Tags (e.g., <tag>)
        rule.pattern = QRegularExpression("<\\/?\\w+>");
        rule.format = (HighlightingCategory::Tag);
        highlightingRules.append(rule);

        // XML Attributes (e.g., key="value")
        rule.pattern = QRegularExpression("\\b\\w+\\s*=\\s*\"[^\"]*\"");
        rule.format = (HighlightingCategory::Attribute);
        highlightingRules.append(rule);

        // XML String values (e.g., "value")
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // XML Comments (e.g., <!-- comment -->)
        rule.pattern = QRegularExpression("<!--[^>]*-->");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // XML Prolog (e.g., <?xml version="1.0" encoding="UTF-8"?>)
        rule.pattern = QRegularExpression("<\\?xml[^>]*\\?>");
        rule.format = (HighlightingCategory::Prolog);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
