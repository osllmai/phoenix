#include "haskellhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> haskellHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Haskell keywords (e.g., let, in, data, type, case, of)
        QStringList keywords = {
            "\\blet\\b", "\\bin\\b", "\\bdata\\b", "\\btype\\b", "\\bcase\\b", "\\bof\\b",
            "\\bif\\b", "\\bthen\\b", "\\belse\\b", "\\bdo\\b", "\\bmodule\\b",
            "\\bimport\\b", "\\bwhere\\b", "\\bnewtype\\b", "\\bclass\\b", "\\binstance\\b",
            "\\bdefault\\b", "\\bderiving\\b", "\\breturn\\b", "\\bforall\\b", "\\bunsafe\\b"
        };
        for (const QString &keyword : keywords) {
            rule.pattern = QRegularExpression(keyword);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function definitions (e.g., myFunction = ...)
        rule.pattern = QRegularExpression("\\b\\w+\\s*=\\s*[^=]+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Function calls (e.g., myFunction arg1 arg2)
        rule.pattern = QRegularExpression("\\b\\w+\\b(?=\\s*\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Variables (e.g., let x = ...)
        rule.pattern = QRegularExpression("\\b\\w+\\b(?=\\s*=)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello, World!")
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with --)
        rule.pattern = QRegularExpression("--[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Multi-line comments (between {- and -})
        rule.pattern = QRegularExpression("\\{-(.|\\n)*?-\\}");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 42, 3.14)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
