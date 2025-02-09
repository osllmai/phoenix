#ifndef ONLINEMODEL_H
#define ONLINEMODEL_H

#include <QObject>
#include <QtQml>

#include "../model.h"

class OnlineModel : public Model
{
    Q_OBJECT
    Q_PROPERTY(QString type READ type CONSTANT FINAL)
    Q_PROPERTY(double inputPricePer1KTokens READ inputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(double outputPricePer1KTokens READ outputPricePer1KTokens CONSTANT FINAL)
    Q_PROPERTY(QString contextWindows READ contextWindows CONSTANT FINAL)
    Q_PROPERTY(bool recommended READ recommended CONSTANT FINAL)
    Q_PROPERTY(bool commercial READ commercial CONSTANT FINAL)
    Q_PROPERTY(bool pricey READ pricey CONSTANT FINAL)
    Q_PROPERTY(QString output READ output CONSTANT FINAL)
    Q_PROPERTY(QString comments READ comments CONSTANT FINAL)

public:
    explicit OnlineModel(Model *parent);

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
};

#endif // ONLINEMODEL_H
