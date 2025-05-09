#include "highlighting.h"

#include "highlightingcategory.h"
#include "languageHighlightingRules/pythonhighlightingrules.h"
#include "languageHighlightingRules/csharphighlightingrules.h"
#include "languageHighlightingRules/cpphighlightingrules.h"
#include "languageHighlightingRules/typescripthighlightingrules.h"
#include "languageHighlightingRules/javahighlightingrules.h"
#include "languageHighlightingRules/gohighlightingrules.h"
#include "languageHighlightingRules/bashhighlightingrules.h"
#include "languageHighlightingRules/latexhighlightingrules.h"
#include "languageHighlightingRules/htmlhighlightingrules.h"
#include "languageHighlightingRules/phphighlightingrules.h"
#include "languageHighlightingRules/jsonhighlightingrules.h"
#include "languageHighlightingRules/javascripthighlightingrules.h"
#include "languageHighlightingRules/markdownhighlightingrules.h"
#include "languageHighlightingRules/swifthighlightingrules.h"
#include "languageHighlightingRules/kotlinhighlightingrules.h"
#include "languageHighlightingRules/rusthighlightingrules.h"
#include "languageHighlightingRules/rubyhighlightingrules.h"
#include "languageHighlightingRules/sqlhighlightingrules.h"
#include "languageHighlightingRules/rhighlightingrules.h"
#include "languageHighlightingRules/perlhighlightingrules.h"
#include "languageHighlightingRules/scalahighlightingrules.h"
#include "languageHighlightingRules/haskellhighlightingrules.h"
#include "languageHighlightingRules/luahighlightingrules.h"
#include "languageHighlightingRules/assemblyhighlightingrules.h"
#include "languageHighlightingRules/cmakehighlightingrules.h"
#include "languageHighlightingRules/makefilehighlightingrules.h"
#include "languageHighlightingRules/qmllightingrules.h"
#include "languageHighlightingRules/inihighlightingrules.h"
#include "languageHighlightingRules/yamlhighlightingrules.h"
#include "languageHighlightingRules/dockerfilehighlightingrules.h"
#include "languageHighlightingRules/batchhighlightingrules.h"
#include "languageHighlightingRules/powershellhighlightingrules.h"
#include "languageHighlightingRules/shellscripthighlightingrules.h"
#include "languageHighlightingRules/xmlhighlightingrules.h"
#include "languageHighlightingRules/csshighlightingrules.h"
#include "languageHighlightingRules/csvhighlightingrules.h"
#include "languageHighlightingRules/tomlhighlightingrules.h"

QVector<HighlightingRule> Highlighting::python() {
    return pythonHighlightingRules();
}

QVector<HighlightingRule> Highlighting::csharp() {
    return csharpHighlightingRules();
}

QVector<HighlightingRule> Highlighting::cpp() {
    return cppHighlightingRules();
}

QVector<HighlightingRule> Highlighting::typescript() {
    return typescriptHighlightingRules();
}

QVector<HighlightingRule> Highlighting::java() {
    return javaHighlightingRules();
}

QVector<HighlightingRule> Highlighting::go() {
    return goHighlightingRules();
}

QVector<HighlightingRule> Highlighting::bash() {
    return bashHighlightingRules();
}

QVector<HighlightingRule> Highlighting::latex() {
    return latexHighlightingRules();
}

QVector<HighlightingRule> Highlighting::html() {
    return htmlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::php() {
    return phpHighlightingRules();
}

QVector<HighlightingRule> Highlighting::json() {
    return jsonHighlightingRules();
}

QVector<HighlightingRule> Highlighting::javascript() {
    return javascriptHighlightingRules();
}

QVector<HighlightingRule> Highlighting::markdown() {
    return markdownHighlightingRules();
}

QVector<HighlightingRule> Highlighting::swift() {
    return swiftHighlightingRules();
}

QVector<HighlightingRule> Highlighting::kotlin() {
    return kotlinHighlightingRules();
}

QVector<HighlightingRule> Highlighting::rust() {
    return rustHighlightingRules();
}

QVector<HighlightingRule> Highlighting::ruby() {
    return rubyHighlightingRules();
}

QVector<HighlightingRule> Highlighting::sql() {
    return sqlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::r() {
    return rHighlightingRules();
}

QVector<HighlightingRule> Highlighting::perl() {
    return perlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::scala() {
    return scalaHighlightingRules();
}

QVector<HighlightingRule> Highlighting::haskell() {
    return haskellHighlightingRules();
}

QVector<HighlightingRule> Highlighting::lua() {
    return luaHighlightingRules();
}

QVector<HighlightingRule> Highlighting::assembly() {
    return assemblyHighlightingRules();
}

QVector<HighlightingRule> Highlighting::cmake() {
    return cmakeHighlightingRules();
}

QVector<HighlightingRule> Highlighting::makefile() {
    return makefileHighlightingRules();
}

QVector<HighlightingRule> Highlighting::qml() {
    return qmlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::ini() {
    return iniHighlightingRules();
}

QVector<HighlightingRule> Highlighting::yaml() {
    return yamlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::dockerfile() {
    return dockerfileHighlightingRules();
}

QVector<HighlightingRule> Highlighting::batch() {
    return batchHighlightingRules();
}

QVector<HighlightingRule> Highlighting::powershell() {
    return powershellHighlightingRules();
}

QVector<HighlightingRule> Highlighting::shellscript() {
    return shellScriptHighlightingRules();
}

QVector<HighlightingRule> Highlighting::xml() {
    return xmlHighlightingRules();
}

QVector<HighlightingRule> Highlighting::css() {
    return cssHighlightingRules();
}

QVector<HighlightingRule> Highlighting::csv() {
    return csvHighlightingRules();
}

QVector<HighlightingRule> Highlighting::toml() {
    return tomlHighlightingRules();
}
