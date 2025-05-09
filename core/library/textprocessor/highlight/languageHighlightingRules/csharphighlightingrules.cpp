#include "csharphighlightingrules.h"

#include "../highlightingcategory.h"

QVector<HighlightingRule> csharpHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule (optional, usually handled separately)
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Keywords
        QStringList keywordPatterns = {
            "\\babstract\\b", "\\bas\\b", "\\bbase\\b", "\\bbool\\b", "\\bbreak\\b", "\\bbyte\\b",
            "\\bcase\\b", "\\bcatch\\b", "\\bchar\\b", "\\bchecked\\b", "\\bclass\\b", "\\bconst\\b",
            "\\bcontinue\\b", "\\bdecimal\\b", "\\bdefault\\b", "\\bdelegate\\b", "\\bdo\\b",
            "\\bdouble\\b", "\\belse\\b", "\\benum\\b", "\\bevent\\b", "\\bexplicit\\b",
            "\\bextern\\b", "\\bfalse\\b", "\\bfinally\\b", "\\bfixed\\b", "\\bfloat\\b",
            "\\bfor\\b", "\\eforeach\\b", "\\bgoto\\b", "\\bif\\b", "\\bimplicit\\b",
            "\\bin\\b", "\\bint\\b", "\\binterface\\b", "\\binternal\\b", "\\bis\\b",
            "\\block\\b", "\\blong\\b", "\\bnamespace\\b", "\\bnew\\b", "\\bnull\\b",
            "\\bobject\\b", "\\boperator\\b", "\\bout\\b", "\\boverride\\b", "\\bparams\\b",
            "\\bprivate\\b", "\\bprotected\\b", "\\bpublic\\b", "\\breadonly\\b", "\\bref\\b",
            "\\breturn\\b", "\\bsbyte\\b", "\\bsealed\\b", "\\bshort\\b", "\\bsizeof\\b",
            "\\bstackalloc\\b", "\\bstatic\\b", "\\bstring\\b", "\\bstruct\\b", "\\bswitch\\b",
            "\\bthis\\b", "\\bthrow\\b", "\\btrue\\b", "\\btry\\b", "\\btypeof\\b",
            "\\buint\\b", "\\bulong\\b", "\\bunchecked\\b", "\\bunsafe\\b", "\\bushort\\b",
            "\\busing\\b", "\\bvirtual\\b", "\\bvoid\\b", "\\bvolatile\\b", "\\bwhile\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Class name after 'class'
        rule.pattern = QRegularExpression("\\bclass\\s+(\\w+)");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Function definitions (returnType name(...))
        rule.pattern = QRegularExpression("\\b(\\w+)\\s+(\\w+)\\s*\\(");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Function calls (identifier followed by parentheses)
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Built-in constants
        QStringList constants = { "\\btrue\\b", "\\bfalse\\b", "\\bnull\\b" };
        for (const QString &pattern : constants) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // Numbers
        rule.pattern = QRegularExpression("\\b\\d+(\\.\\d+)?\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Number);
        highlightingRules.append(rule);

        // Strings (single-line)
        rule.pattern = QRegularExpression("\".*?\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Character literals
        rule.pattern = QRegularExpression("'.'");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Comments (multi-line)
        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        // Attributes / annotations (e.g., [Serializable])
        rule.pattern = QRegularExpression("\\[\\w+\\]");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Annotation);
        highlightingRules.append(rule);

        // Operators
        QStringList operators = {
            "\\+", "-", "\\*", "/", "%", "=", "==", "!=", "<", ">", "<=", ">=", "&&", "\\|\\|", "!", "\\?"
        };
        for (const QString &pattern : operators) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Operator);
            highlightingRules.append(rule);
        }
    }
    return highlightingRules;
}

