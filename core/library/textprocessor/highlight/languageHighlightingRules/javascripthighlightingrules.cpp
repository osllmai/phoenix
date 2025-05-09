#include "javascripthighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> javascriptHighlightingRules() {
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

        // Variable declarations (e.g., var x = 10)
        rule.pattern = QRegularExpression("\\b(var|let|const)\\s+(\\w+)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // JavaScript keywords
        QStringList keywordPatterns = {
            "\\bvar\\b", "\\blet\\b", "\\bconst\\b", "\\bfunction\\b", "\\bif\\b", "\\belse\\b",
            "\\breturn\\b", "\\bfor\\b", "\\bwhile\\b", "\\bswitch\\b", "\\bcase\\b", "\\bbreak\\b",
            "\\bcontinue\\b", "\\btry\\b", "\\bcatch\\b", "\\bfinally\\b", "\\bthrow\\b", "\\bnew\\b",
            "\\bthis\\b", "\\binstanceof\\b", "\\btypeof\\b", "\\bdelete\\b", "\\bnull\\b", "\\bundefined\\b",
            "\\btrue\\b", "\\bfalse\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Built-in functions (e.g., alert(), console.log())
        QStringList builtinFunctions = {
            "\\bconsole\\.(log|warn|error|info)\\b", "\\balert\\b", "\\bprompt\\b", "\\bconfirm\\b"
        };
        for (const QString &pattern : builtinFunctions) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::BuiltinFunction);
            highlightingRules.append(rule);
        }

        // String literals (single and double quotes)
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("'[^']*'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line and multi-line)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
