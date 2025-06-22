#include "swifthighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> swiftHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Swift keywords (e.g., func, class, struct, let, var, etc.)
        QStringList keywordPatterns = {
            "\\bfunc\\b", "\\bclass\\b", "\\bstruct\\b", "\\blet\\b", "\\bvar\\b", "\\bif\\b",
            "\\belse\\b", "\\bfor\\b", "\\bwhile\\b", "\\bswitch\\b", "\\bcase\\b", "\\breturn\\b",
            "\\bbreak\\b", "\\bcontinue\\b", "\\bdo\\b", "\\bdefer\\b", "\\bguard\\b", "\\bthrow\\b",
            "\\btry\\b", "\\bcatch\\b", "\\bimport\\b", "\\bprotocol\\b", "\\benum\\b", "\\bextension\\b",
            "\\bprivate\\b", "\\bpublic\\b", "\\binternal\\b", "\\blateinit\\b", "\\bfinal\\b", "\\boverride\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // String literals (e.g., "This is a string")
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Number literals (e.g., 123, 45.67)
        rule.pattern = QRegularExpression("\\b[0-9]+(?:\\.[0-9]+)?\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with // and multi-line comments using /* */)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("/\\*[^*]*\\*+(?:[^/*][^*]*\\*+)*/");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Operators (e.g., =, ==, !=, +, -, *, /, etc.)
        QStringList operators = {
            "\\=", "\\!\\=", "\\=\\=", "\\+","\\-","\\*","\\/","\\%","\\<","\\>","\\&","\\|","\\^"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }

        // Function names (e.g., func myFunction())
        rule.pattern = QRegularExpression("\\bfunc\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Type annotations (e.g., let x: Int)
        rule.pattern = QRegularExpression(":\\s*\\w+");
        rule.format = (HighlightingCategory::TypeAnnotation);
        highlightingRules.append(rule);

        // Struct and Class names (e.g., struct MyStruct, class MyClass)
        rule.pattern = QRegularExpression("\\b(class|struct)\\s+(\\w+)\\b");
        rule.format = (HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Constants (e.g., true, false, nil)
        QStringList constants = {
            "\\btrue\\b", "\\bfalse\\b", "\\bnil\\b"
        };
        for (const QString &pattern : constants) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
