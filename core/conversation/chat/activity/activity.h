#ifndef ACTIVITY_H
#define ACTIVITY_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

class Activity : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString text READ text CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)

public:
    explicit Activity(QObject* parent = nullptr) : QObject(parent) {}
    explicit Activity(const int &id, const QString &text, const QString &icon, QObject *parent = nullptr );

    int id() const;

    QString text() const;

    QString icon() const;

private:
    int m_id;
    QString m_text;
    QString m_icon;
};

#endif // ACTIVITY_H
