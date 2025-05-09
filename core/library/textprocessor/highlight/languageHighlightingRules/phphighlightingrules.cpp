#include "phphighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> phpHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // PHP keywords (e.g., if, else, function, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\belseif\\b", "\\bfor\\b", "\\bforeach\\b", "\\bwhile\\b",
            "\\bdo\\b", "\\bswitch\\b", "\\bcase\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\breturn\\b",
            "\\bfunction\\b", "\\bclass\\b", "\\binterface\\b", "\\bextends\\b", "\\bimplements\\b",
            "\\bpublic\\b", "\\bprivate\\b", "\\bprotected\\b", "\\bstatic\\b", "\\bfinal\\b",
            "\\btry\\b", "\\bcatch\\b", "\\bthrow\\b", "\\bisset\\b", "\\bempty\\b", "\\binclude\\b",
            "\\brequire\\b", "\\binclude_once\\b", "\\brequire_once\\b", "\\bglobal\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // PHP variables (e.g., $variable, $$variable)
        rule.pattern = QRegularExpression("\\$\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // PHP functions (e.g., echo(), strlen())
        rule.pattern = QRegularExpression("\\b\\w+\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // PHP classes (e.g., class MyClass)
        rule.pattern = QRegularExpression("\\bclass\\s+\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Comments (single-line)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Comments (multi-line)
        rule.pattern = QRegularExpression("/\\*.*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Double-quoted strings (e.g., "string")
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Single-quoted strings (e.g., 'string')
        rule.pattern = QRegularExpression("'.*?'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numeric literals
        rule.pattern = QRegularExpression("\\b[0-9]+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "&&", "\\|\\|", "\\!", "=", "\\^", "\\%"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
