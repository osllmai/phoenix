#include "dockerfilehighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> dockerfileHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Dockerfile commands (e.g., FROM, RUN, COPY, ADD, etc.)
        QStringList commands = {
            "\\bFROM\\b", "\\bRUN\\b", "\\bCMD\\b", "\\bLABEL\\b", "\\bEXPOSE\\b",
            "\\bENV\\b", "\\bADD\\b", "\\bCOPY\\b", "\\bENTRYPOINT\\b", "\\bVOLUME\\b",
            "\\bWORKDIR\\b", "\\bUSER\\b", "\\bARG\\b", "\\bSHELL\\b"
        };
        for (const QString &command : commands) {
            rule.pattern = QRegularExpression(command);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Variables (e.g., $MY_VAR)
        rule.pattern = QRegularExpression("\\$[A-Za-z0-9_]+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Strings (values after commands or in COPY paths)
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers (e.g., port numbers in EXPOSE)
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
