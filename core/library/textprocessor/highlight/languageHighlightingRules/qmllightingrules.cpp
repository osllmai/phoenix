#include "qmllightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> qmlHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // QML keywords (e.g., import, import, property, etc.)
        QStringList keywordPatterns = {
            "\\bimport\\b", "\\bproperty\\b", "\\bsignal\\b", "\\bslot\\b", "\\bfunction\\b",
            "\\bComponent\\b", "\\bConnections\\b", "\\bMouseArea\\b", "\\bRectangle\\b",
            "\\bListView\\b", "\\bText\\b", "\\bImage\\b", "\\bTimer\\b", "\\bTextInput\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // QML element names (e.g., Rectangle, Text, ListView)
        rule.pattern = QRegularExpression("\\b[A-Z][a-zA-Z0-9]*\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ElementName);
        highlightingRules.append(rule);

        // Property names (e.g., width, height, color)
        rule.pattern = QRegularExpression("\\b[A-Za-z][A-Za-z0-9_]*\\b(?=\\s*:)"); // Match only properties before ":"
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Property);
        highlightingRules.append(rule);

        // String literals (e.g., "Hello World")
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line comments starting with //)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Multi-line comments (/* comment */)
        rule.pattern = QRegularExpression("/\\*.*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers (e.g., 10, 3.14)
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

        // Boolean literals (true, false)
        QStringList booleanLiterals = {
            "\\btrue\\b", "\\bfalse\\b"
        };
        for (const QString &pattern : booleanLiterals) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Function names (e.g., onClicked, mouseAreaClicked)
        rule.pattern = QRegularExpression("\\bon[A-Za-z0-9_]+");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
