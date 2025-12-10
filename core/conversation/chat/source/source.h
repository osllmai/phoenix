#ifndef SOURCE_H
#define SOURCE_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

class Source : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString titel READ titel CONSTANT FINAL)
    Q_PROPERTY(QString text READ text CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)
    Q_PROPERTY(QString link READ link CONSTANT FINAL)

public:
    explicit Source(QObject* parent = nullptr) : QObject(parent) {}
    explicit Source(const int &id,
                    const QString &text,
                    const QString &icon,
                    const QString &link,
                    QObject *parent = nullptr );

    int id() const;

    QString text() const;

    QString icon() const;

    QString titel() const;

    QString link() const;

private:
    int m_id;
    QString m_titel;
    QString m_text;
    QString m_icon;
    QString m_link;
};

#endif // SOURCE_H
