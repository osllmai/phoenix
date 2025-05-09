#include "powershellhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> powershellHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // PowerShell keywords (e.g., if, else, function, etc.)
        QStringList keywordPatterns = {
            "\\bif\\b", "\\belse\\b", "\\belseif\\b", "\\bfor\\b", "\\bforeach\\b", "\\bwhile\\b",
            "\\bdo\\b", "\\bswitch\\b", "\\bcase\\b", "\\bbreak\\b", "\\bcontinue\\b", "\\breturn\\b",
            "\\bfunction\\b", "\\bclass\\b", "\\btry\\b", "\\bcatch\\b", "\\bfinally\\b",
            "\\bthrow\\b", "\\btrap\\b", "\\bexit\\b", "\\bnull\\b", "\\btrue\\b", "\\bfalse\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // PowerShell variables (e.g., $variable)
        rule.pattern = QRegularExpression("\\$\\w+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // PowerShell functions (e.g., Get-Command, Set-Item)
        rule.pattern = QRegularExpression("\\b\\w+(-\\w+)*\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // PowerShell comments (single-line)
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

        // Numeric literals (e.g., 123, 12.34)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "&&", "\\|\\|", "!", "="
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // PowerShell cmdlets (e.g., Get-Help, Set-Location)
        QStringList cmdletPatterns = {
            "\\bGet-\\w+\\b", "\\bSet-\\w+\\b", "\\bNew-\\w+\\b", "\\bTest-\\w+\\b"
        };
        for (const QString &pattern : cmdletPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Cmdlet);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
