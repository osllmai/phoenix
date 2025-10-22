#include "perlhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> perlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Perl keywords (e.g., if, else, sub, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\belsif\\b", "\\bwhile\\b", "\\bfor\\b", "\\bforeach\\b",
            "\\bsub\\b", "\\breturn\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\bdo\\b", "\\bpackage\\b",
            "\\bmy\\b", "\\buse\\b", "\\brequire\\b", "\\bimport\\b", "\\bundef\\b", "\\bBEGIN\\b", "\\bEND\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Perl variables (e.g., $variable, @array, %hash)
        rule.pattern = QRegularExpression("\\$\\w+|@\\w+|%\\w+");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Perl subroutines (e.g., sub my_subroutine)
        rule.pattern = QRegularExpression("\\bsub\\s+\\w+");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Comments (starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Double-quoted strings (e.g., "string")
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Single-quoted strings (e.g., 'string')
        rule.pattern = QRegularExpression("'.*?'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Numeric literals
        rule.pattern = QRegularExpression("\\b[0-9]+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "\\=\\=", "==", "&&", "\\|\\|", "\\!", "\\^", "\\%","\\&"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
