#ifndef ONLINEMODEL_H
#define ONLINEMODEL_H

#include <QObject>
#include <QQmlEngine>

#include "../model.h"

class OnlineModel : public Model
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString type READ type CONSTANT FINAL)
    Q_PROPERTY(double inputPricePer1KTokens READ inputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(double outputPricePer1KTokens READ outputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(QString contextWindows READ contextWindows CONSTANT FINAL)
    Q_PROPERTY(bool recommended READ recommended CONSTANT FINAL)
    Q_PROPERTY(bool commercial READ commercial CONSTANT FINAL)
    Q_PROPERTY(bool pricey READ pricey CONSTANT FINAL)
    Q_PROPERTY(QString output READ output CONSTANT FINAL)
    Q_PROPERTY(QString comments READ comments CONSTANT FINAL)
    Q_PROPERTY(bool installModel READ installModel WRITE setInstallModel NOTIFY installModelChanged FINAL)

public:
    explicit OnlineModel(QObject* parent = nullptr) : Model(parent) {}

    explicit OnlineModel(const int id, const QString& modelName, const QString& name, const QString& key, QDateTime addModelTime,
                         const bool isLike, Company* company, const BackendType backend,
                         const QString& icon , const QString& information , const QString& promptTemplate ,
                         const QString& systemPrompt, QDateTime expireModelTime, QObject* parent,

                         const QString& type, const double inputPricePer1KTokens, const double outputPricePer1KTokens,
                         const QString& contextWindows, const bool recommended, const bool commercial, const bool pricey,
                         const QString& output, const QString& comments, const bool installModel
                         );

    virtual ~OnlineModel();

    const QString &type() const;

    const double inputPricePer1KTokens() const;

    const double outputPricePer1KTokens() const;

    const QString &contextWindows() const;

    const bool recommended() const;

    const bool commercial() const;

    const bool pricey() const;

    const QString &output() const;

    const QString &comments() const;

    const bool installModel() const;
    void setInstallModel(const bool newInstallModel);

signals:
    void installModelChanged();
    void modelChanged();

private:
    QString m_type;
    double m_inputPricePer1KTokens;
    double m_outputPricePer1KTokens;
    QString m_contextWindows;
    bool m_recommended;
    bool m_commercial;
    bool m_pricey;
    QString m_output;
    QString m_comments;
    bool m_installModel;
};

#endif // ONLINEMODEL_H
