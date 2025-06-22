#ifndef LANGUAGE_H
#define LANGUAGE_H

#include <QObject>

enum Language {
    None,
    Python,
    Cpp,
    Bash,
    TypeScript,
    Java,
    Go,
    Json,
    Csharp,
    Latex,
    Html,
    Php,
    Javascript,
    Markdown,
    Swift,
    Kotlin,
    Rust,
    Ruby,
    SQL,
    R,
    Perl,
    Scala,
    Haskell,
    Lua,
    Assembly,
    CMake,
    Makefile,
    Qml,
    Ini,
    Yaml,
    Dockerfile,
    Batch,
    PowerShell,
    ShellScript,
    Xml,
    Css,
    Csv,
    Toml
};

static Language stringToLanguage(const QString &language)
{
    if (language == "python")
        return Python;
    if (language == "cpp")
        return Cpp;
    if (language == "c++")
        return Cpp;
    if (language == "csharp")
        return Csharp;
    if (language == "c#")
        return Csharp;
    if (language == "c")
        return Cpp;
    if (language == "bash")
        return Bash;
    if (language == "javascript")
        return TypeScript;
    if (language == "typescript")
        return TypeScript;
    if (language == "java")
        return Java;
    if (language == "go")
        return Go;
    if (language == "golang")
        return Go;
    if (language == "json")
        return Json;
    if (language == "latex")
        return Latex;
    if (language == "html")
        return Html;
    if (language == "php")
        return Php;

    return None;
}

#endif // LANGUAGE_H
