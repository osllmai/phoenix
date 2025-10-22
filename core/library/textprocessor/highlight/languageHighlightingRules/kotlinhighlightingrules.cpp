#include "kotlinhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> kotlinHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Function calls (e.g., myFunction())
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*(?=\\()");
        rule.format = (HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Function definitions (e.g., fun myFunction)
        rule.pattern = QRegularExpression("\\bfun\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class names (e.g., class MyClass)
        rule.pattern = QRegularExpression("\\bclass\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Kotlin keywords
        QStringList keywordPatterns = {
            "\\bfun\\b", "\\bclass\\b", "\\bif\\b", "\\belse\\b", "\\bwhen\\b",
            "\\bfor\\b", "\\breturn\\b", "\\bval\\b", "\\bvar\\b", "\\bnull\\b",
            "\\btrue\\b", "\\bfalse\\b", "\\btry\\b", "\\bcatch\\b", "\\bfinally\\b",
            "\\bthrow\\b", "\\bcontinue\\b", "\\bbreak\\b", "\\bimport\\b", "\\bpackage\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Data types (e.g., Int, String, Boolean)
        QStringList dataTypes = {
            "\\bInt\\b", "\\bString\\b", "\\bBoolean\\b", "\\bFloat\\b", "\\bDouble\\b",
            "\\bLong\\b", "\\bShort\\b", "\\bByte\\b", "\\bChar\\b"
        };
        for (const QString &pattern : dataTypes) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Type);
            highlightingRules.append(rule);
        }

        // Numeric literals
        rule.pattern = QRegularExpression("\\b\\d+\\.?\\d*\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello, World!")
        rule.pattern = QRegularExpression("\"([^\"]*)\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line, starting with //)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Multi-line comments (starting with /* and ending with */)
        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
