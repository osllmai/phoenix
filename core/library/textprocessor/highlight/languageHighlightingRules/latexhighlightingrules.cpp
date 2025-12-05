#include "latexhighlightingrules.h"
#include "../HighlightingCategory.h"

QVector<HighlightingRule> latexHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = (HighlightingCategory::Default);
        highlightingRules.append(rule);

        // LaTeX commands (e.g., \textbf, \section)
        rule.pattern = QRegularExpression("\\\\[a-zA-Z]+");
        rule.format = (HighlightingCategory::Command);
        highlightingRules.append(rule);

        // LaTeX math mode (e.g., $...$ for inline math, \[...\] for display math)
        rule.pattern = QRegularExpression("\\$.*?\\$|\\\\\\[.*?\\\\\\]");
        rule.format = (HighlightingCategory::Math);
        highlightingRules.append(rule);

        // LaTeX environment (e.g., \begin{itemize}, \end{itemize})
        rule.pattern = QRegularExpression("\\\\begin\\{.*?\\}|\\\\end\\{.*?\\}");
        rule.format = (HighlightingCategory::Environment);
        highlightingRules.append(rule);

        // LaTeX comments (e.g., % This is a comment)
        rule.pattern = QRegularExpression("%[^\n]*");
        rule.format = (HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // LaTeX sections (e.g., \section{Introduction})
        rule.pattern = QRegularExpression("\\\\section\\{.*?\\}|\\\\subsection\\{.*?\\}|\\\\subsubsection\\{.*?\\}");
        rule.format = (HighlightingCategory::Section);
        highlightingRules.append(rule);

        // Strings inside curly braces (e.g., \textbf{Hello World})
        rule.pattern = QRegularExpression("\\{[^}]*\\}");
        rule.format = (HighlightingCategory::String);
        highlightingRules.append(rule);

        // LaTeX special characters (e.g., %, $, &, #, _, ^, ~, {, })
        QStringList specialCharacters = {"\\%", "\\$", "\\&", "\\#", "\\_", "\\^", "\\~", "\\{", "\\}"};
        for (const QString &pattern : specialCharacters) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = (HighlightingCategory::SpecialCharacter);
            highlightingRules.append(rule);
        }

        // Numeric literals (e.g., numbers in math mode or in text)
        rule.pattern = QRegularExpression("\\b[0-9]+\\.?[0-9]*\\b");
        rule.format = (HighlightingCategory::Number);
        highlightingRules.append(rule);

        // LaTeX environment names (e.g., itemize, enumerate)
        QStringList environments = {"itemize", "enumerate", "align", "equation", "document", "figure"};
        for (const QString &env : environments) {
            rule.pattern = QRegularExpression("\\\\begin\\{" + env + "\\}");
            rule.format = (HighlightingCategory::Environment);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}
