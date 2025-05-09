#include "perlhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> perlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Perl keywords (e.g., if, else, sub, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\belsif\\b", "\\bwhile\\b", "\\bfor\\b", "\\bforeach\\b",
            "\\bsub\\b", "\\breturn\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\bdo\\b", "\\bpackage\\b",
            "\\bmy\\b", "\\buse\\b", "\\brequire\\b", "\\bimport\\b", "\\bundef\\b", "\\bBEGIN\\b", "\\bEND\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Perl variables (e.g., $variable, @array, %hash)
        rule.pattern = QRegularExpression("\\$\\w+|@\\w+|%\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Perl subroutines (e.g., sub my_subroutine)
        rule.pattern = QRegularExpression("\\bsub\\s+\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Comments (starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
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
            "\\+", "-", "\\*", "\\/", "\\=\\=", "==", "&&", "\\|\\|", "\\!", "\\^", "\\%","\\&"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
