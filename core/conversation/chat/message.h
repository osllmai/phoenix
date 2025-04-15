#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>
#include <QQmlEngine>
#include <QDateTime>

class Message : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id CONSTANT FINAL)
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged FINAL)
    Q_PROPERTY(QDateTime date READ date CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)
    Q_PROPERTY(bool isPrompt READ isPrompt CONSTANT FINAL)
    Q_PROPERTY(int like READ like WRITE setLike NOTIFY likeChanged FINAL)

public:
    explicit Message(QObject* parent = nullptr) : QObject(parent) {}
    explicit Message(const int &id, const QString &text, const QDateTime date, const QString &icon, bool isPrompt, const int like, QObject *parent = nullptr );

    int id() const;

    QString text() const;
    void setText(const QString &newText);

    QDateTime date() const;

    QString icon() const;

    bool isPrompt() const;

    int like() const;
    void setLike(const int &newLike);

signals:
    void textChanged();
    void likeChanged();

private:
    int m_id;
    QString m_text;
    QDateTime m_date;
    QString m_icon;
    bool m_isPrompt;
    int m_like;
};

#endif // MESSAGE_H
