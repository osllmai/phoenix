#include "javahighlightingrules.h"
#include "../highlightingcategory.h"

QVector<HighlightingRule> javaHighlightingRules() {
    static QVector<HighlightingRule> highlightingRules;
    if (highlightingRules.isEmpty()) {
        HighlightingRule rule;

        // Default rule for unmatched text
        rule.pattern = QRegularExpression(".*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Default);
        highlightingRules.append(rule);

        // Function calls (e.g., myFunction())
        rule.pattern = QRegularExpression("\\b(\\w+)\\s*(?=\\()");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::FunctionCall);
        highlightingRules.append(rule);

        // Method definitions (e.g., public void myMethod())
        rule.pattern = QRegularExpression("\\b(public|private|protected|static|void|final|abstract|synchronized|native)\\s+(\\w+)\\s*\\(");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Function);
        highlightingRules.append(rule);

        // Class names (e.g., class MyClass)
        rule.pattern = QRegularExpression("\\bclass\\s+(\\w+)\\b");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::ClassName);
        highlightingRules.append(rule);

        // Java keywords
        QStringList keywordPatterns = {
            "\\babstract\\b", "\\bassert\\b", "\\bboolean\\b", "\\bbreak\\b", "\\bbyte\\b",
            "\\bcase\\b", "\\bcatch\\b", "\\bchar\\b", "\\bclass\\b", "\\bconst\\b",
            "\\bcontinue\\b", "\\bdefault\\b", "\\bdo\\b", "\\bdouble\\b", "\\belse\\b",
            "\\benum\\b", "\\bextends\\b", "\\bfinal\\b", "\\bfinally\\b", "\\bfloat\\b",
            "\\bfor\\b", "\\bgoto\\b", "\\bif\\b", "\\bimplements\\b", "\\bimport\\b",
            "\\binstanceof\\b", "\\bint\\b", "\\binterface\\b", "\\blong\\b", "\\bnative\\b",
            "\\bnew\\b", "\\bpackage\\b", "\\bprivate\\b", "\\bprotected\\b", "\\bpublic\\b",
            "\\breturn\\b", "\\bshort\\b", "\\bsingleton\\b", "\\bstatic\\b", "\\bstrictfp\\b",
            "\\bsuper\\b", "\\bswitch\\b", "\\b synchronized\\b", "\\bthis\\b", "\\bthrow\\b",
            "\\bthrows\\b", "\\btransient\\b", "\\btry\\b", "\\bvoid\\b", "\\bvolatile\\b",
            "\\bwhile\\b"
        };
        for (const QString &pattern : keywordPatterns) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Keyword);
            highlightingRules.append(rule);
        }

        // Built-in constants: true, false, null
        QStringList builtinConstants = { "\\btrue\\b", "\\bfalse\\b", "\\bnull\\b" };
        for (const QString &pattern : builtinConstants) {
            rule.pattern = QRegularExpression(pattern);
            rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Constant);
            highlightingRules.append(rule);
        }

        // String literals (e.g., "this is a string")
        rule.pattern = QRegularExpression("\"[^\"]*\"");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::String);
        highlightingRules.append(rule);

        // Comments (single-line // and multi-line /* */)
        rule.pattern = QRegularExpression("//[^\n]*");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);

        rule.pattern = QRegularExpression("/\\*[\\s\\S]*?\\*/");
        rule.format = highlightingCategory_To_QTextCharFormat(HighlightingCategory::Comment);
        highlightingRules.append(rule);
    }
    return highlightingRules;
}
