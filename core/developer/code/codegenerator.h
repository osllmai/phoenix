#ifndef CODEGENERATOR_H
#define CODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>

class CodeGenerator : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString text READ text NOTIFY textChanged FINAL)

public:
    explicit CodeGenerator(QObject* parent = nullptr);
    explicit CodeGenerator(const bool &stream,
                           const QString &promptTemplate,
                           const QString &systemPrompt,
                           const double &temperature,
                           const int &topK,
                           const double &topP,
                           const double &minP,
                           const double &repeatPenalty,
                           const int &promptBatchSize,
                           const int &maxTokens,
                           const int &repeatPenaltyTokens,
                           const int &contextLength,
                           const int &numberOfGPULayers,
                           QObject *parent = nullptr);

    virtual ~CodeGenerator();

    virtual QString getModels();
    virtual QString postChat();

    QString text();

    void setStream(const bool stream);
    void setPromptTemplate(const QString promptTemplate);
    void setSystemPrompt(const QString systemPrompt);
    void setTemperature(const double temperature);
    void setTopK(const int topK);
    void setTopP(const double topP);
    void setMinP(const double minP);
    void setRepeatPenalty(const double repeatPenalty);
    void setPromptBatchSize(const int promptBatchSize);
    void setMaxTokens(const int maxTokens);
    void setRepeatPenaltyTokens(const int repeatPenaltyTokens);
    void setContextLength(const int contextLength);
    void setNumberOfGPULayers(const int numberOfGPULayers);

signals:
    void textChanged();

protected:
    QString m_text;

    bool m_stream;
    QString m_promptTemplate;
    QString m_systemPrompt;
    double m_temperature;
    int m_topK;
    double m_topP;
    double m_minP;
    double m_repeatPenalty;
    int m_promptBatchSize;
    int m_maxTokens;
    int m_repeatPenaltyTokens;
    int m_contextLength;
    int m_numberOfGPULayers;
};

#endif // CODEGENERATOR_H
