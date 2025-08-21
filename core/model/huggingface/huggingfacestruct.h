#ifndef HUGGINGFACESTRUCT_H
#define HUGGINGFACESTRUCT_H

#include <QString>

struct WidgetData {
    QString text;
};

struct ConfigData {
    QStringList architectures;
    QString model_type;
};

struct CardData {
    QStringList base_model;
    QString license;
    QString pipeline_tag;
    QString library_name;
    QStringList tags;
};

struct TransformersInfo {
    QString auto_model;
    QString pipeline_tag;
    QString processor;
};

struct GgufData {
    qint64 total;
    QString architecture;
    int context_length;
    QString chat_template;
    QString bos_token;
    QString eos_token;
};

struct SiblingFile {
    QString rfilename;
};

#endif // HUGGINGFACESTRUCT_H
