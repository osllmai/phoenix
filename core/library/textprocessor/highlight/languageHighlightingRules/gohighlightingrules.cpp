#include "gohighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> goHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Go keywords (e.g., func, package, var, import)
        QStringList keywords = {
            "\\bpackage\\b", "\\bimport\\b", "\\bfunc\\b", "\\bvar\\b", "\\bconst\\b",
            "\\btype\\b", "\\binterface\\b", "\\bstruct\\b", "\\bgo\\b", "\\bdefer\\b",
            "\\bselect\\b", "\\bcase\\b", "\\bchan\\b", "\\bbreak\\b", "\\bcontinue\\b",
            "\\bfallthrough\\b", "\\breturn\\b", "\\bif\\b", "\\belse\\b", "\\bfor\\b",
            "\\bswitch\\b", "\\bmap\\b", "\\bbool\\b", "\\bbyte\\b", "\\bstring\\b",
            "\\bint\\b", "\\bfloat64\\b", "\\bcomplex64\\b"
        };
        for (const QString &keyword : keywords) {
            rule.pattern = QRegularExpression(keyword);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function definitions (e.g., func myFunc)
        rule.pattern = QRegularExpression("\\bfunc\\s+\\w+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Variables and type declarations (e.g., var x int)
        rule.pattern = QRegularExpression("\\bvar\\s+\\w+\\s+[a-zA-Z0-9_]+\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Functions calls (e.g., myFunc())
        rule.pattern = QRegularExpression("\\b\\w+\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // String literals
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line and multi-line)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numeric literals
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
