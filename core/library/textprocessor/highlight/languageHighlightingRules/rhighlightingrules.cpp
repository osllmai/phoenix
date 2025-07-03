#include "rhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> rHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // R keywords (e.g., if, else, function, for, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\bfor\\b", "\\bwhile\\b", "\\brepeat\\b",
            "\\bfunction\\b", "\\breturn\\b", "\\bbreak\\b", "\\bnext\\b", "\\btry\\b",
            "\\belse\\b", "\\bstop\\b", "\\bprint\\b", "\\blibrary\\b", "\\brequire\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function names (e.g., mean(), sum())
        rule.pattern = QRegularExpression("\\b[a-zA-Z_][a-zA-Z0-9_]*\\b(?=\\()");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Variable names (e.g., x, y, result)
        rule.pattern = QRegularExpression("\\b[a-zA-Z_][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 10, 3.14)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World")
        rule.pattern = QRegularExpression("\".*?\"|'.*?'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==, etc.)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "=", "&&", "\\|\\|", "<", ">", "!=", "<=", ">="
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Boolean literals (TRUE, FALSE)
        rule.pattern = QRegularExpression("\\bTRUE\\b|\\bFALSE\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Built-in functions (e.g., c(), mean(), sum(), etc.)
        QStringList builtinFunctions = {
            "\\bc\\b", "\\bmean\\b", "\\bsum\\b", "\\bmin\\b", "\\bmax\\b", "\\bplot\\b"
        };
        for (const QString &pattern : builtinFunctions) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::BuiltinFunction);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
