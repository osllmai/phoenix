#ifndef MESSAGE_H
#define MESSAGE_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>

class Message : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged )
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged )
    Q_PROPERTY(Message *child READ child NOTIFY childChanged )
    Q_PROPERTY(int numberOfCurrentChild READ numberOfCurrentChild NOTIFY numberOfCurrentChildChanged )
    Q_PROPERTY(int numberOfChildList READ numberOfChildList NOTIFY numberOfChildListChanged )
    Q_PROPERTY(bool isPrompt READ isPrompt NOTIFY isPromptChanged )

public:
    explicit Message(const int &id, const QString &text, bool isPrompt, QObject *parent );
    // Message* findChild(const int index) ;
    void nextChild(const int numberOfNext);
    void addChild( Message *message);

    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    int id() const;
    QString text() const;
    Message *child() ;
    int numberOfCurrentChild() const;
    int numberOfChildList() const;
    bool isPrompt() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
    void setId(const int id);
    void setText(const QString text);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

signals:
    void idChanged(int id);
    void textChanged(QString text);
    void childChanged();
    void numberOfCurrentChildChanged(int numberOfCurrentChild);
    void numberOfChildListChanged(int numberOfChildList);
    void isPromptChanged(bool isPrompt);

private:
    int m_id;
    QString m_text;
    int m_numberOfCurrentChild;
    int m_numberOfChildList;
    bool m_isPrompt;
    Message *m_child;
    QList<Message*> childList;
};

#endif // MESSAGE_H
