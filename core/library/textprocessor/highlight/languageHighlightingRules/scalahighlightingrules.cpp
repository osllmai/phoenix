#include "scalahighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> scalaHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Scala keywords (e.g., def, val, var, object, class, if, else, etc.)
        QStringList keywordPatterns = {
            "\\bdef\\b", "\\bval\\b", "\\bvar\\b", "\\bobject\\b", "\\bclass\\b", "\\btrait\\b",
            "\\bif\\b", "\\belse\\b", "\\bwhile\\b", "\\bfor\\b", "\\bmatch\\b", "\\breturn\\b",
            "\\bnew\\b", "\\bnull\\b", "\\btrue\\b", "\\bfalse\\b", "\\bcatch\\b", "\\bthrow\\b",
            "\\btry\\b", "\\bimport\\b", "\\bextends\\b", "\\bwith\\b", "\\bsealed\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function names (e.g., myFunction())
        rule.pattern = QRegularExpression("\\b[a-z_][a-zA-Z0-9_]*\\b(?=\\()");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class and object names (e.g., MyClass, MyObject)
        rule.pattern = QRegularExpression("\\b[A-Z][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Variable names (e.g., x, myVar)
        rule.pattern = QRegularExpression("\\b[a-z_][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 10, 3.14, 0x10)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b|0x[0-9A-Fa-f]+");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World", 'Scala')
        rule.pattern = QRegularExpression("\"[^\"]*\"|'[^']*'");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with //)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Block comments (multi-line comments starting with /* and ending with */)
        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., +, -, *, /, ==, !=, &&, ||)
        QStringList operators = {
            "\\+", "-", "\\*", "\\/", "==", "!=", "\\&\\&", "\\|\\|", ">", "<", "=", "!", "->", "=>"
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

        // Null literal
        rule.pattern = QRegularExpression("\\bnull\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Type annotations (e.g., String, Int, Boolean)
        rule.pattern = QRegularExpression("\\b[A-Z][a-zA-Z0-9_]*\\b(?=:)");
        rule.format = (HighlightingCategory::Type);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
