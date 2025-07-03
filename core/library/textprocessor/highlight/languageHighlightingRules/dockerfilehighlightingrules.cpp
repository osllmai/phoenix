#include "dockerfilehighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> dockerfileHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Dockerfile commands (e.g., FROM, RUN, COPY, ADD, etc.)
        QStringList commands = {
            "\\bFROM\\b", "\\bRUN\\b", "\\bCMD\\b", "\\bLABEL\\b", "\\bEXPOSE\\b",
            "\\bENV\\b", "\\bADD\\b", "\\bCOPY\\b", "\\bENTRYPOINT\\b", "\\bVOLUME\\b",
            "\\bWORKDIR\\b", "\\bUSER\\b", "\\bARG\\b", "\\bSHELL\\b"
        };
        for (const QString &command : commands) {
            rule.pattern = QRegularExpression(command);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Variables (e.g., $MY_VAR)
        rule.pattern = QRegularExpression("\\$[A-Za-z0-9_]+");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Strings (values after commands or in COPY paths)
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers (e.g., port numbers in EXPOSE)
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
