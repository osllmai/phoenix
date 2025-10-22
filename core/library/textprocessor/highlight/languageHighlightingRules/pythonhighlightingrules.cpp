#include "pythonhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> pythonHighlightingRules(){
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for any unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Function calls (e.g., my_function())
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*(?=\\()");
        rule.format = (HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Function definitions (e.g., def my_function)
        rule.pattern = QRegularExpression("\\bdef\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class names (e.g., class MyClass)
        rule.pattern = QRegularExpression("\\bclass\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Built-in functions (e.g., print(), len())
        QStringList builtinFunctions = {
            "\\bprint\\b", "\\blen\\b", "\\brange\\b", "\\binput\\b", "\\bstr\\b",
            "\\bint\\b", "\\bfloat\\b", "\\blist\\b", "\\bdict\\b", "\\bset\\b"
        };
        for (const QString &pattern : builtinFunctions) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::BuiltinFunction);
            highlightingRules.append(rule);
        }

        // Operator (e.g., +, -, *, /, ==, and, or)
        QStringList operators = {
            "\\+","\\-","\\*","\\/","\\%","\\=\\=","\\!\\=","\\&\\&","\\|\\|"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Numeric literals
        rule.pattern = QRegularExpression("\\b[0-9]*\\.?[0-9]+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Python keywords
        QStringList keywordPatterns = {
            "\\bdef\\b", "\\bclass\\b", "\\bif\\b", "\\belse\\b", "\\belif\\b",
            "\\bwhile\\b", "\\bfor\\b", "\\breturn\\b", "\\bprint\\b", "\\bimport\\b",
            "\\bfrom\\b", "\\bas\\b", "\\btry\\b", "\\bexcept\\b", "\\braise\\b",
            "\\bwith\\b", "\\bfinally\\b", "\\bcontinue\\b", "\\bbreak\\b", "\\bpass\\b",
            "\\bglobal\\b", "\\blambda\\b", "\\bassert\\b", "\\byield\\b", "\\bdel\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Built-in constants: True, False, None
        QStringList builtinConstants = { "\\bTrue\\b", "\\bFalse\\b", "\\bNone\\b" };
        for (const QString &pattern : builtinConstants) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Decorators (e.g., @staticmethod)
        rule.pattern = QRegularExpression("@\\w+");
        rule.format = (HighlightingCategory::Annotation);
        highlightingRules.append(rule);

        // Single-line double-quoted strings
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Single-line single-quoted strings
        rule.pattern = QRegularExpression("'.*?'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Multi-line triple-quoted strings (both """ and ''')
        rule.pattern = QRegularExpression("\"\"\"[\\s\\S]*?\"\"\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("'''[\\s\\S]*?'''");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (starting with #)
        rule.pattern = QRegularExpression("#[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
