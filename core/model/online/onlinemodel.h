#ifndef ONLINEMODEL_H
#define ONLINEMODEL_H

#include <QObject>
#include <QQmlEngine>

#include "../model.h"

class OnlineModel : public Model
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(double inputPricePer1KTokens READ inputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(double outputPricePer1KTokens READ outputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(QString contextWindows READ contextWindows CONSTANT FINAL)
    Q_PROPERTY(bool commercial READ commercial CONSTANT FINAL)
    Q_PROPERTY(bool pricey READ pricey CONSTANT FINAL)
    Q_PROPERTY(QString output READ output CONSTANT FINAL)
    Q_PROPERTY(QString comments READ comments CONSTANT FINAL)

public:
    explicit OnlineModel(QObject* parent = nullptr) : Model(parent) {}

    explicit OnlineModel(const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const QString& type, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, const bool recommended, QObject* parent,

                         const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                         const QString& contextWindows, const bool commercial, const bool pricey,
                         const QString& output, const QString& comments
                         );

    virtual ~OnlineModel();

    const double inputPricePer1KTokens() const;

    const double outputPricePer1KTokens() const;

    const QString &contextWindows() const;

    const bool commercial() const;

    const bool pricey() const;

    const QString &output() const;

    const QString &comments() const;

private:
    double m_inputPricePer1KTokens;
    double m_outputPricePer1KTokens;
    QString m_contextWindows;
    bool m_commercial;
    bool m_pricey;
    QString m_output;
    QString m_comments;
};

#endif // ONLINEMODEL_H
