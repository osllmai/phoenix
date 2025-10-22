#include "cpphighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> cppHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Keywords
        QStringList keywords = {
            "int", "float", "double", "char", "void", "bool", "short", "long",
            "signed", "unsigned", "namespace", "using", "class", "struct", "union",
            "if", "else", "switch", "case", "default", "for", "while", "do",
            "return", "break", "continue", "public", "private", "protected",
            "virtual", "override", "template", "typename", "const", "static",
            "inline", "new", "delete", "try", "catch", "throw", "this", "nullptr",
            "operator", "enum", "extern", "mutable", "volatile", "register",
            "explicit", "friend", "constexpr", "decltype", "noexcept", "static_cast",
            "reinterpret_cast", "dynamic_cast", "const_cast"
        };
        for (const QString &keyword : keywords) {
            rule.pattern = QRegularExpression(QString("\\b%1\\b").arg(keyword));
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Types and classes
        QStringList types = { "std::string", "std::vector", "std::map", "std::set" };
        for (const QString &type : types) {
            rule.pattern = QRegularExpression(QString("\\b%1\\b").arg(QRegularExpression::escape(type)));
            rule.format = (HighlightingCategory::ClassName);
            highlightingRules.append(rule);
        }

        // Functions
        rule.pattern = QRegularExpression(R"(\b(\w+)(?=\())");
        rule.format = (HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Strings (single and double quoted)
        rule.pattern = QRegularExpression(R"(".*?")");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression(R"('.*?')");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line and multi-line)
        rule.pattern = QRegularExpression(R"(//[^\n]*)");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression(R"(/\*[\s\S]*?\*/)");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Preprocessor directives
        rule.pattern = QRegularExpression(R"(#\s*\w+)");
        rule.format = (HighlightingCategory::Annotation);
        highlightingRules.append(rule);

        // Numbers
        rule.pattern = QRegularExpression(R"(\b\d+(\.\d+)?\b)");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators
        QStringList operators = {
            "\\+", "-", "\\*", "/", "%", "==", "!=", "<", "<=", ">", ">=", "&&", "\\|\\|", "!", "=", "::", "\\."
        };
        for (const QString &op : operators) {
            rule.pattern = QRegularExpression(op);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
