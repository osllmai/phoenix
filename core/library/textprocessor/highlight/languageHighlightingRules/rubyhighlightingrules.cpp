#include "rubyhighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> rubyHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Ruby keywords (e.g., def, class, module, if, else, etc.)
        QStringList keywordPatterns = {
            "\\bdef\\b", "\\bclass\\b", "\\bmodule\\b", "\\bif\\b", "\\belse\\b",
            "\\belsif\\b", "\\bwhile\\b", "\\bfor\\b", "\\bdo\\b", "\\breturn\\b",
            "\\bbreak\\b", "\\bnext\\b", "\\bend\\b", "\\bbegin\\b", "\\brescue\\b",
            "\\bensure\\b", "\\bcase\\b", "\\bwhen\\b", "\\bunless\\b", "\\bdefined\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Method names (e.g., my_method(), to_s, etc.)
        rule.pattern = QRegularExpression("\\b[a-z_][a-zA-Z0-9_]*\\b(?=\\()");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class names (e.g., MyClass)
        rule.pattern = QRegularExpression("\\b[A-Z][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Variable names (e.g., x, @my_var, $global_var)
        rule.pattern = QRegularExpression("\\b(?:@?[a-z_][a-zA-Z0-9_]*|\\$[a-zA-Z0-9_]+)\\b");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 10, 3.14, 0b1010)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b|0b[01]+");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World", 'Ruby')
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==, !=, etc.)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "!=", "\\&\\&", "\\|\\|", ">", "<", "=", "!", "\\.", "\\[\\]", "\\{\\}"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Boolean literals (true, false)
        rule.pattern = QRegularExpression("\\btrue\\b|\\bfalse\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Built-in functions (e.g., puts(), print(), gets(), etc.)
        QStringList builtinFunctions = {
            "\\bputs\\b", "\\bprint\\b", "\\bgets\\b", "\\bsleep\\b", "\\brequire\\b", "\\bload\\b",
            "\\bdefined?\\b", "\\bdump\\b", "\\bcaller\\b"
        };
        for (const QString &pattern : builtinFunctions) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::BuiltinFunction);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
