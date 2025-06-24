#ifndef CODEGENERATOR_H
#define CODEGENERATOR_H

#include <QObject>
#include <QQmlEngine>

class CodeGenerator : public QObject {
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString text READ text NOTIFY textChanged FINAL)

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
    Q_PROPERTY(double repeatPenaltyTokens READ repeatPenaltyTokens WRITE setRepeatPenaltyTokens NOTIFY repeatPenaltyTokensChanged FINAL)
    Q_PROPERTY(int contextLength READ contextLength WRITE setContextLength NOTIFY contextLengthChanged FINAL)
    Q_PROPERTY(int numberOfGPULayers READ numberOfGPULayers WRITE setNumberOfGPULayers NOTIFY numberOfGPULayersChanged FINAL)

    Q_PROPERTY(bool topKVisible READ topKVisible NOTIFY topKVisibleChanged FINAL)
    Q_PROPERTY(bool topPVisible READ topPVisible NOTIFY topPVisibleChanged FINAL)
    Q_PROPERTY(bool minPVisible READ minPVisible NOTIFY minPVisibleChanged FINAL)
    Q_PROPERTY(bool repeatPenaltyVisible READ repeatPenaltyVisible NOTIFY repeatPenaltyVisibleChanged FINAL)
    Q_PROPERTY(bool promptBatchSizeVisible READ promptBatchSizeVisible NOTIFY promptBatchSizeVisibleChanged FINAL)
    Q_PROPERTY(bool maxTokensVisible READ maxTokensVisible NOTIFY maxTokensVisibleChanged FINAL)
    Q_PROPERTY(bool repeatPenaltyTokensVisible READ repeatPenaltyTokensVisible NOTIFY repeatPenaltyTokensVisibleChanged FINAL)
    Q_PROPERTY(bool contextLengthVisible READ contextLengthVisible NOTIFY contextLengthVisibleChanged FINAL)
    Q_PROPERTY(bool numberOfGPULayersVisible READ numberOfGPULayersVisible NOTIFY numberOfGPULayersVisibleChanged FINAL)

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
                           const bool &topKVisible,
                           const bool &topPVisible,
                           const bool &minPVisible,
                           const bool &repeatPenaltyVisible,
                           const bool &promptBatchSizeVisible,
                           const bool &maxTokensVisible,
                           const bool &repeatPenaltyTokensVisible,
                           const bool &contextLengthVisible,
                           const bool &numberOfGPULayersVisible,
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

    double repeatPenaltyTokens() const;
    void setRepeatPenaltyTokens(double newRepeatPenaltyTokens);

    int contextLength() const;
    void setContextLength(int newContextLength);

    int numberOfGPULayers() const;
    void setNumberOfGPULayers(int newNumberOfGPULayers);

    bool topKVisible() const;
    void setTopKVisible(bool newTopKVisible);

    bool topPVisible() const;
    void setTopPVisible(bool newTopPVisible);

    bool minPVisible() const;
    void setMinPVisible(bool newMinPVisible);

    bool repeatPenaltyVisible() const;
    void setRepeatPenaltyVisible(bool newRepeatPenaltyVisible);

    bool promptBatchSizeVisible() const;
    void setPromptBatchSizeVisible(bool newPromptBatchSizeVisible);

    bool maxTokensVisible() const;
    void setMaxTokensVisible(bool newMaxTokensVisible);

    bool repeatPenaltyTokensVisible() const;
    void setRepeatPenaltyTokensVisible(bool newRepeatPenaltyTokensVisible);

    bool contextLengthVisible() const;
    void setContextLengthVisible(bool newContextLengthVisible);

    bool numberOfGPULayersVisible() const;
    void setNumberOfGPULayersVisible(bool newNumberOfGPULayersVisible);

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
    void topKVisibleChanged();
    void topPVisibleChanged();
    void minPVisibleChanged();
    void repeatPenaltyVisibleChanged();
    void promptBatchSizeVisibleChanged();
    void maxTokensVisibleChanged();
    void repeatPenaltyTokensVisibleChanged();
    void contextLengthVisibleChanged();
    void numberOfGPULayersVisibleChanged();

private:
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
    double m_repeatPenaltyTokens;
    int m_contextLength;
    int m_numberOfGPULayers;

    bool m_topKVisible;
    bool m_topPVisible;
    bool m_minPVisible;
    bool m_repeatPenaltyVisible;
    bool m_promptBatchSizeVisible;
    bool m_maxTokensVisible;
    bool m_repeatPenaltyTokensVisible;
    bool m_contextLengthVisible;
    bool m_numberOfGPULayersVisible;
};

#endif // CODEGENERATOR_H
