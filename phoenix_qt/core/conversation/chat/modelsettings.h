#ifndef MODELSETTINGS_H
#define MODELSETTINGS_H

#include <QObject>
#include <QQmlEngine>

class ModelSettings : public QObject{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
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

public:
    explicit ModelSettings(const int &id, QObject *parent = nullptr);
    virtual ~ModelSettings();

    const int id() const;

    const bool stream() const;
    void setStream(const bool stream);

    const QString promptTemplate() const;
    void setPromptTemplate(const QString promptTemplate);

    const QString systemPrompt() const;
    void setSystemPrompt(const QString systemPrompt);

    const double temperature() const;
    void setTemperature(const double temperature);

    const int topK() const;
    void setTopK(const int topK);

    const double topP() const;
    void setTopP(const double topP);

    const double minP() const;
    void setMinP(const double minP);

    const double repeatPenalty() const;
    void setRepeatPenalty(const double repeatPenalty);

    const int promptBatchSize() const;
    void setPromptBatchSize(const int promptBatchSize);

    const int maxTokens() const;
    void setMaxTokens(const int maxTokens);

    const int repeatPenaltyTokens() const;
    void setRepeatPenaltyTokens(const int repeatPenaltyTokens);

    const int contextLength() const;
    void setContextLength(const int contextLength);

    const int numberOfGPULayers() const;
    void setNumberOfGPULayers(const int numberOfGPULayers);

signals:
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

private:
    int m_id;
    bool m_stream = true;
    QString m_promptTemplate = "### Human:\n%1\n\n### Assistant:\n";
    QString m_systemPrompt = "### System:\nYou are an AI assistant who gives a quality response to whatever humans ask of you.\n\n";
    double m_temperature = 0.7;
    int m_topK = 40;
    double m_topP = 0.4;
    double m_minP = 0.0;
    double m_repeatPenalty = 1.18;
    int m_promptBatchSize = 128;
    int m_maxTokens = 4096;
    int m_repeatPenaltyTokens = 64;
    int m_contextLength = 2048;
    int m_numberOfGPULayers = 80;
};

#endif // MODELSETTINGS_H
