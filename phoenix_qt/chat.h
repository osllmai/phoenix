#ifndef CHAT_H
#define CHAT_H

#include <QObject>
#include <QtQml>
#include <QDateTime>

#include <chatllm.h>
#include <chatmodel.h>
#include <model.h>

class Chat : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged )
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged )
    Q_PROPERTY(QDateTime date READ date NOTIFY dateChanged )

    Q_PROPERTY(ChatModel *chatModel READ chatModel NOTIFY chatModelChanged )
    Q_PROPERTY(bool isLoadModel READ isLoadModel WRITE setIsLoadModel NOTIFY isLoadModelChanged )
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged )
    Q_PROPERTY(int valueTimer READ valueTimer NOTIFY valueTimerChanged)
    Q_PROPERTY(Model *model READ model WRITE setModel NOTIFY modelChanged)

public:
    explicit Chat(const int &id, const QString &title, const QDateTime date , Message* root, QObject *parent = nullptr);
    virtual ~Chat();

    Q_INVOKABLE void loadModelRequested(Model *model);
    Q_INVOKABLE void unloadModelRequested();
    void addChatItem(int id, QString prompt, QString response);

    //*----------------------------------------------------------------------------------------**************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property *----------------------------------------------------------------------------------------*//
    int id() const;
    QString title() const;
    QDateTime date() const;
    ChatModel* chatModel() const;
    bool isLoadModel() const;
    bool loadModelInProgress() const;
    bool responseInProgress() const;
    int valueTimer() const;
    Model* model() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property  *----------------------------------------------------------------------------------------*//
    void setId(const int id);
    void setTitle(const QString title);
    void setIsLoadModel(const bool isLoadModel);
    void setLoadModelInProgress(const bool loadModelInProgress);
    void setResponseInProgress(const bool responseInProgress);
    void setModel(Model* model);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

signals:
    void idChanged();
    void titleChanged();
    void dateChanged();
    void chatModelChanged();
    void isLoadModelChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void valueTimerChanged();
    void modelChanged();

    void loadModel(const QString &modelPath);
    void unLoadModel();
    void prompt(const QString &input);
    void tokenResponse(const QString &token);

    void startChat();
    void finishedResponnseRequest();

public slots:
    void LoadModelResult(const bool result);
    void promptRequested(const QString &input);
    void tokenResponseRequested(const QString &token);
    void finishedResponnse();

private:
    int m_id;
    QString m_title;
    QDateTime m_date;
    ChatLLM *chatLLM;
    ChatModel *m_chatModel;
    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;
    QTimer *m_timer;
    int m_valueTimer;
    Model *m_model;
};

#endif // CHAT_H
