#include "bashhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> bashHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Keywords (if, then, else, fi, for, while, in, do, done, function, etc.)
        QStringList keywords = {
            "\\bif\\b", "\\bthen\\b", "\\belse\\b", "\\bfi\\b",
            "\\bfor\\b", "\\bwhile\\b", "\\bin\\b", "\\bdo\\b", "\\bdone\\b",
            "\\bcase\\b", "\\besac\\b", "\\bfunction\\b", "\\bselect\\b",
            "\\buntil\\b", "\\btime\\b", "\\breturn\\b", "\\bcontinue\\b", "\\bbreak\\b"
        };
        for (const QString &pattern : keywords) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Built-in commands (cd, echo, read, etc.)
        QStringList builtins = {
            "\\bcd\\b", "\\becho\\b", "\\bread\\b", "\\bexit\\b", "\\bexport\\b",
            "\\blocal\\b", "\\bshift\\b", "\\btrap\\b", "\\bunset\\b", "\\benum\\b"
        };
        for (const QString &pattern : builtins) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::BuiltinFunction);
            highlightingRules.append(rule);
        }

        // Variables (e.g., $VAR, ${VAR})
        rule.pattern = QRegularExpression("\\$\\w+|\\$\\{[^}]+\\}");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Strings (single and double quoted)
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("'.*?'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (# ...)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators
        QStringList operators = { "\\|\\|", "&&", ";", "&", "\\|", "<", ">", ">>", "<<" };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Command substitution: $(...)
        rule.pattern = QRegularExpression("\\$\\([^\\)]+\\)");
        rule.format = (HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
