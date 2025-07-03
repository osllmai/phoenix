#include "rusthighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> rustHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Rust keywords (e.g., fn, let, struct, enum, if, else, etc.)
        QStringList keywordPatterns = {
            "\\bfn\\b", "\\blet\\b", "\\bmut\\b", "\\bstruct\\b", "\\benum\\b", "\\bif\\b",
            "\\belse\\b", "\\bmatch\\b", "\\bwhile\\b", "\\bfor\\b", "\\breturn\\b",
            "\\bmod\\b", "\\buse\\b", "\\bconst\\b", "\\bunsafe\\b", "\\btrait\\b",
            "\\bimpl\\b", "\\bpub\\b", "\\basync\\b", "\\bawait\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Function names (e.g., my_function())
        rule.pattern = QRegularExpression("\\b[a-z_][a-zA-Z0-9_]*\\b(?=\\()");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Struct and Enum names (e.g., MyStruct, MyEnum)
        rule.pattern = QRegularExpression("\\b[A-Z][a-zA-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Variable names (e.g., x, my_var)
        rule.pattern = QRegularExpression("\\b(?:[a-z_][a-zA-Z0-9_]*|\\$[a-zA-Z0-9_]+)\\b");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Numeric literals (e.g., 10, 3.14, 0b1010)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b|0b[01]+");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World", 'Rust')
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

        // Constants (e.g., PI, MAX)
        rule.pattern = QRegularExpression("\\b[A-Z][A-Z0-9_]*\\b");
        rule.format = (HighlightingCategory::Constant);
        highlightingRules.append(rule);

        // Keywords for async/await (async, await, etc.)
        rule.pattern = QRegularExpression("\\basync\\b|\\bawait\\b");
        rule.format = (HighlightingCategory::Keyword);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
