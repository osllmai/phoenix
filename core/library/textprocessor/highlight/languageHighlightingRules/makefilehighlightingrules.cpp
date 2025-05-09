#include "makefilehighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> makefileHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Makefile variables (e.g., $(VAR))
        rule.pattern = QRegularExpression("\\$\\([a-zA-Z0-9_]+\\)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Makefile targets (e.g., target: dependencies)
        rule.pattern = QRegularExpression("^([a-zA-Z0-9_\\-]+):");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Target);
        highlightingRules.append(rule);

        // Makefile rules (e.g., <tab> command)
        rule.pattern = QRegularExpression("^\\t.*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Rule);
        highlightingRules.append(rule);

        // Makefile comments (e.g., # comment)
        rule.pattern = QRegularExpression("^#.*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Makefile built-in functions (e.g., all, clean, install)
        QStringList builtInFunctions = {
            "\\ball\\b", "\\bclean\\b", "\\binstall\\b", "\\btest\\b", "\\bbuild\\b"
        };
        for (const QString &pattern : builtInFunctions) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
            highlightingRules.append(rule);
        }

        // Makefile operators (e.g., =, +=, :=)
        QStringList operators = {
            "\\=", "\\\\+", ":="
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
