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

    bool stream() const;
    void setStream(bool newStream);

    QString promptTemplate() const;
    void setPromptTemplate(const QString &newPromptTemplate);

    QString systemPrompt() const;
    void setSystemPrompt(const QString &newSystemPrompt);

    double temperature() const;
    void setTemperature(double newTemperature);

    int topK() const;
    void setTopK(int newTopK);

    double topP() const;
    void setTopP(double newTopP);

    double minP() const;
    void setMinP(double newMinP);

    double repeatPenalty() const;
    void setRepeatPenalty(double newRepeatPenalty);

    int promptBatchSize() const;
    void setPromptBatchSize(int newPromptBatchSize);

    int maxTokens() const;
    void setMaxTokens(int newMaxTokens);

    int repeatPenaltyTokens() const;
    void setRepeatPenaltyTokens(int newRepeatPenaltyTokens);

    int contextLength() const;
    void setContextLength(int newContextLength);

    int numberOfGPULayers() const;
    void setNumberOfGPULayers(int newNumberOfGPULayers);

signals:
    void textChanged();
    void streamChanged();
    void promptTemplateChanged();
    void systemPromptChanged();
    void temperatureChanged();
    void topKChanged();
    void topPChanged();
    void minPChanged();
    void repeatPenaltyChanged();
    void promptBatchSizeChanged();
    void maxTokensChanged();
    void repeatPenaltyTokensChanged();
    void contextLengthChanged();
    void numberOfGPULayersChanged();

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
private:
    Q_PROPERTY(bool stream READ stream WRITE setStream NOTIFY streamChanged FINAL)
    Q_PROPERTY(QString promptTemplate READ promptTemplate WRITE setPromptTemplate NOTIFY promptTemplateChanged FINAL)
    Q_PROPERTY(QString systemPrompt READ systemPrompt WRITE setSystemPrompt NOTIFY systemPromptChanged FINAL)
    Q_PROPERTY(double temperature READ temperature WRITE setTemperature NOTIFY temperatureChanged FINAL)
    Q_PROPERTY(int topK READ topK WRITE setTopK NOTIFY topKChanged FINAL)
    Q_PROPERTY(double topP READ topP WRITE setTopP NOTIFY topPChanged FINAL)
    Q_PROPERTY(double minP READ minP WRITE setMinP NOTIFY minPChanged FINAL)
    Q_PROPERTY(double repeatPenalty READ repeatPenalty WRITE setRepeatPenalty NOTIFY repeatPenaltyChanged FINAL)
    Q_PROPERTY(int promptBatchSize READ promptBatchSize WRITE setPromptBatchSize NOTIFY promptBatchSizeChanged FINAL)
    Q_PROPERTY(int maxTokens READ maxTokens WRITE setMaxTokens NOTIFY maxTokensChanged FINAL)
    Q_PROPERTY(int repeatPenaltyTokens READ repeatPenaltyTokens WRITE setRepeatPenaltyTokens NOTIFY repeatPenaltyTokensChanged FINAL)
    Q_PROPERTY(int contextLength READ contextLength WRITE setContextLength NOTIFY contextLengthChanged FINAL)
    Q_PROPERTY(int numberOfGPULayers READ numberOfGPULayers WRITE setNumberOfGPULayers NOTIFY numberOfGPULayersChanged FINAL)
};

#endif // CODEGENERATOR_H
