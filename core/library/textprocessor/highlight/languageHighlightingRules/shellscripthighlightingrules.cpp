#include "shellscripthighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> shellScriptHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Shell Script keywords (e.g., if, else, for, while, function, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\bfi\\b", "\\bthen\\b", "\\bfor\\b", "\\bwhile\\b", "\\bdo\\b",
            "\\bdone\\b", "\\bfunction\\b", "\\becho\\b", "\\bexit\\b", "\\breturn\\b", "\\bcase\\b",
            "\\bselect\\b", "\\buntil\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\btest\\b", "\\b[[\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function names (e.g., myFunction())
        rule.pattern = QRegularExpression("\\b[a-z_][a-zA-Z0-9_]*\\b(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Variable names (e.g., $var, $1, $HOME)
        rule.pattern = QRegularExpression("\\$[a-zA-Z_][a-zA-Z0-9_]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 10, 3.14, 0x10)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b|0x[0-9A-Fa-f]+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World", 'Shell')
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==, !=, &&, ||)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "!=", "\\&\\&", "\\|\\|", ">", "<", "=", "!", "\\.", "\\|"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Redirection symbols (e.g., >, <, >>, <<, 2>)
        QStringList redirectionSymbols = {
            "\\>", "\\<", ">>", "<<", "2>", "2>>"
        };
        for (const QString &pattern : redirectionSymbols) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Special variables (e.g., $?, $$, $!, $#, etc.)
        QStringList specialVars = {
            "\\$\\?", "\\$\\$", "\\$\\!", "\\$#", "\\$@", "\\$*"
        };
        for (const QString &pattern : specialVars) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::SpecialVariable);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
