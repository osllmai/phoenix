#include "cmakehighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> cmakeHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // CMake commands (e.g., add_executable, find_package)
        QStringList commands = {
            "add_executable", "add_library", "target_link_libraries", "include_directories",
            "find_package", "set", "if", "elseif", "else", "endif", "message",
            "project", "cmake_minimum_required", "install", "file", "configure_file",
            "option", "foreach", "endforeach", "while", "endwhile", "function", "endfunction"
        };
        for (const QString &cmd : commands) {
            rule.pattern = QRegularExpression(QString("\\b%1\\b").arg(cmd), QRegularExpression::CaseInsensitiveOption);
            rule.format = (HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Variables: ${VAR_NAME}
        rule.pattern = QRegularExpression(R"(\$\{\w+\})");
        rule.format = (HighlightingCategory::Variable);
        highlightingRules.append(rule);

        // Strings
        rule.pattern = QRegularExpression(R"(".*?")");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments: starting with #
        rule.pattern = QRegularExpression(R"(#.*)");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Numbers
        rule.pattern = QRegularExpression("\\b\\d+\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Operators (e.g., EQUAL, AND, OR, NOT, STREQUAL, MATCHES)
        QStringList operators = {
            "\\bEQUAL\\b", "\\bAND\\b", "\\bOR\\b", "\\bNOT\\b",
            "\\bSTREQUAL\\b", "\\bMATCHES\\b", "\\bGREATER\\b", "\\bLESS\\b"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern, QRegularExpression::CaseInsensitiveOption);
            rule.format = (HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
