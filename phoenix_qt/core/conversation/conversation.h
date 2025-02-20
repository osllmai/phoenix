#ifndef CONVERSATION_H
#define CONVERSATION_H

#include <QObject>
#include <QtQml>
#include <QDateTime>

#include "./chat/modelsettings.h"
#include "./chat/messagelist.h"
#include "../model/model.h"

class Conversation : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int id READ id CONSTANT)
    Q_PROPERTY(QString title READ title WRITE setTitle NOTIFY titleChanged)
    Q_PROPERTY(QString description READ description WRITE setDescription NOTIFY descriptionChanged)
    Q_PROPERTY(QDateTime date READ date NOTIFY dateChanged)
    Q_PROPERTY(bool isLoadModel READ isLoadModel WRITE setIsLoadModel NOTIFY isLoadModelChanged)
    Q_PROPERTY(bool loadModelInProgress READ loadModelInProgress WRITE setLoadModelInProgress NOTIFY loadModelInProgressChanged)
    Q_PROPERTY(bool responseInProgress READ responseInProgress WRITE setResponseInProgress NOTIFY responseInProgressChanged)
    Q_PROPERTY(MessageList *messageList READ messageList NOTIFY messageListChanged)
    Q_PROPERTY(Model *model READ model WRITE setModel NOTIFY modelChanged)
    Q_PROPERTY(ModelSettings *modelSettings READ modelSettings NOTIFY modelSettingsChanged)

public:
    explicit Conversation(int id, const QString &title, const QDateTime &date, QObject *parent = nullptr);
    virtual ~Conversation();

    const int id() const;

    const QString& title() const;
    void setTitle(const QString &title);

    const QString& description() const;
    void setDescription(const QString &description);

    const QDateTime date() const;

    const bool isLoadModel() const;
    void setIsLoadModel(bool isLoadModel);

    const bool loadModelInProgress() const;
    void setLoadModelInProgress(bool inProgress);

    const bool responseInProgress() const;
    void setResponseInProgress(bool inProgress);

    MessageList *messageList();

    Model *model();
    void setModel(Model *model);

    ModelSettings *modelSettings();

    void loadModelRequested(Model *model);

signals:
    void titleChanged();
    void descriptionChanged();
    void dateChanged();
    void isLoadModelChanged();
    void loadModelInProgressChanged();
    void responseInProgressChanged();
    void messageListChanged();
    void modelChanged();
    void modelSettingsChanged();

private:
    int m_id;
    QString m_title;
    QString m_description;
    QDateTime m_date;
    bool m_isLoadModel;
    bool m_loadModelInProgress;
    bool m_responseInProgress;
    MessageList *m_messageList;
    Model *m_model;
    ModelSettings *m_modelSettings;
};

#endif // CONVERSATION_H
