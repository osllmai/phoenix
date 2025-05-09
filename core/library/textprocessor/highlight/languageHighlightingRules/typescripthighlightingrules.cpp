#include "typescripthighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> typescriptHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Function calls (e.g., myFunction())
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Function definitions (e.g., function myFunction)
        rule.pattern = QRegularExpression("\\bfunction\\s+(\\w+)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class names (e.g., class MyClass)
        rule.pattern = QRegularExpression("\\bclass\\s+(\\w+)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Type annotations (e.g., myVar: string)
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*:");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::TypeAnnotation);
        highlightingRules.append(rule);

        // TypeScript keywords
        QStringList keywordPatterns = {
            "\\bfunction\\b", "\\bclass\\b", "\\binterface\\b", "\\bextends\\b", "\\bimplements\\b",
            "\\bpublic\\b", "\\bprivate\\b", "\\bprotected\\b", "\\blet\\b", "\\bconst\\b", "\\bvar\\b",
            "\\bif\\b", "\\belse\\b", "\\bfor\\b", "\\bwhile\\b", "\\breturn\\b", "\\btry\\b", "\\bcatch\\b",
            "\\bthrow\\b", "\\bswitch\\b", "\\bcase\\b", "\\bdefault\\b", "\\basync\\b", "\\bawait\\b",
            "\\bimport\\b", "\\bexport\\b", "\\bfrom\\b", "\\bas\\b", "\\bdeclare\\b", "\\bnew\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Built-in constants: true, false, null
        QStringList builtinConstants = { "\\btrue\\b", "\\bfalse\\b", "\\bnull\\b" };
        for (const QString &pattern : builtinConstants) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Operator symbols (e.g., +, -, *, /, ==, &&, ||)
        QStringList operators = {
            "\\+", "\\-", "\\*", "\\/", "\\=", "\\==", "\\!=", "\\&\\&", "\\|\\|", "\\?", "\\:", "\\<", "\\>"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Numeric literals
        rule.pattern = QRegularExpression("\\b[0-9]*\\.?[0-9]+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (single and double quotes)
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Multi-line comments
        rule.pattern = QRegularExpression("/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
