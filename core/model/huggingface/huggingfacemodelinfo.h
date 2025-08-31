#ifndef HUGGINGFACEMODELINFO_H
#define HUGGINGFACEMODELINFO_H

#include <QObject>
#include <QQmlEngine>
#include <QString>
#include <QStringList>
#include <QList>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QNetworkRequest>
#include <QUrl>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QtConcurrent>
#include <QThread>
#include <QTimer>

#include "huggingfacestruct.h"

class HuggingfaceModelInfo: public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(QString id READ id CONSTANT FINAL)
    Q_PROPERTY(QString name READ name CONSTANT FINAL)
    Q_PROPERTY(QString icon READ icon CONSTANT FINAL)
    Q_PROPERTY(bool isPrivate READ isPrivate NOTIFY isPrivateChanged FINAL)
    Q_PROPERTY(QString pipeline_tag READ pipeline_tag NOTIFY pipeline_tagChanged FINAL)
    Q_PROPERTY(QString library_name READ library_name NOTIFY library_nameChanged FINAL)
    Q_PROPERTY(QStringList tags READ tags NOTIFY tagsChanged FINAL)
    Q_PROPERTY(int downloads READ downloads NOTIFY downloadsChanged FINAL)
    Q_PROPERTY(int likes READ likes NOTIFY likesChanged FINAL)
    Q_PROPERTY(QString modelId READ modelId NOTIFY modelIdChanged FINAL)
    Q_PROPERTY(QString author READ author NOTIFY authorChanged FINAL)
    Q_PROPERTY(QString sha READ sha NOTIFY shaChanged FINAL)
    Q_PROPERTY(QString lastModified READ lastModified NOTIFY lastModifiedChanged FINAL)
    Q_PROPERTY(bool gated READ gated NOTIFY gatedChanged FINAL)
    Q_PROPERTY(bool disabled READ disabled NOTIFY disabledChanged FINAL)
    Q_PROPERTY(QList<WidgetData> widgetData READ widgetData NOTIFY widgetDataChanged FINAL)
    Q_PROPERTY(ConfigData config READ config NOTIFY configChanged FINAL)
    Q_PROPERTY(CardData cardData READ cardData NOTIFY cardDataChanged FINAL)
    Q_PROPERTY(TransformersInfo transformersInfo READ transformersInfo NOTIFY transformersInfoChanged FINAL)
    Q_PROPERTY(GgufData gguf READ gguf NOTIFY ggufChanged FINAL)
    Q_PROPERTY(QVariantList siblings READ siblingsQml NOTIFY siblingsChanged FINAL)
    Q_PROPERTY(QStringList spaces READ spaces NOTIFY spacesChanged FINAL)
    Q_PROPERTY(QString createdAt READ createdAt NOTIFY createdAtChanged FINAL)
    Q_PROPERTY(qint64 usedStorage READ usedStorage NOTIFY usedStorageChanged FINAL)
    Q_PROPERTY(QString readMe READ readMe NOTIFY readMeChanged FINAL)

    Q_PROPERTY(bool loadModelProcess READ loadModelProcess NOTIFY loadModelProcessChanged FINAL)
    Q_PROPERTY(bool successModelProcess READ successModelProcess NOTIFY successModelProcessChanged FINAL)
public:
    explicit HuggingfaceModelInfo(QObject* parent = nullptr) : QObject(parent) {}
    explicit HuggingfaceModelInfo(const QString& id, const QString& name, const QString& icon, QObject* parent);
    ~HuggingfaceModelInfo();

    void fetchModelInfo();

    QString id() const;

    QString name() const;

    QString icon() const;

    bool isPrivate() const;
    void setIsPrivate(bool newIsPrivate);

    QString pipeline_tag() const;
    void setPipeline_tag(const QString& newPipeline_tag);

    QString library_name() const;
    void setLibrary_name(const QString& newLibrary_name);

    QStringList tags() const;
    void setTags(const QStringList& newTags);

    int downloads() const;
    void setDownloads(int newDownloads);

    int likes() const;
    void setLikes(int newLikes);

    QString modelId() const;
    void setModelId(const QString& newModelId);

    QString author() const;
    void setAuthor(const QString& newAuthor);

    QString sha() const;
    void setSha(const QString& newSha);

    QString lastModified() const;
    void setLastModified(const QString& newLastModified);

    bool gated() const;
    void setGated(bool newGated);

    bool disabled() const;
    void setDisabled(bool newDisabled);

    QList<WidgetData> widgetData() const;
    void setWidgetData(const QList<WidgetData>& newWidgetData);

    ConfigData config() const;
    void setConfig(const ConfigData& newConfig);

    CardData cardData() const;
    void setCardData(const CardData& newCardData);

    TransformersInfo transformersInfo() const;
    void setTransformersInfo(const TransformersInfo& newTransformersInfo);

    GgufData gguf() const;
    void setGguf(const GgufData& newGguf);

    QList<SiblingFile> siblings() const;
    void setSiblings(const QList<SiblingFile>& newSiblings);

    QVariantList siblingsQml() const;

    QStringList spaces() const;
    void setSpaces(const QStringList& newSpaces);

    QString createdAt() const;
    void setCreatedAt(const QString& newCreatedAt);

    qint64 usedStorage() const;
    void setUsedStorage(qint64 newUsedStorage);

    bool loadModelProcess() const;
    void setLoadModelProcess(bool newLoadModelProcess);

    bool successModelProcess() const;
    void setSuccessModelProcess(bool newSuccessModelProcess);

    QString readMe() const;
    void setReadMe(const QString &newReadMe);

signals:
    void isPrivateChanged();
    void pipeline_tagChanged();
    void library_nameChanged();
    void tagsChanged();
    void downloadsChanged();
    void likesChanged();
    void modelIdChanged();
    void authorChanged();
    void shaChanged();
    void lastModifiedChanged();
    void gatedChanged();
    void disabledChanged();
    void widgetDataChanged();
    void configChanged();
    void cardDataChanged();
    void transformersInfoChanged();
    void ggufChanged();
    void siblingsChanged();
    void spacesChanged();
    void createdAtChanged();
    void usedStorageChanged();
    void loadModelProcessChanged();
    void successModelProcessChanged();
    void readMeChanged();

    void modelLoaded();
    void modelLoadFailed(QString error);

private slots:
    void onReplyFinished(QNetworkReply *reply);

private:
    QString m_id;
    QString m_name;
    QString m_icon;
    bool m_isPrivate;
    QString m_pipeline_tag;
    QString m_library_name;
    QStringList m_tags;
    int m_downloads;
    int m_likes;
    QString m_modelId;
    QString m_author;
    QString m_sha;
    QString m_lastModified;
    bool m_gated;
    bool m_disabled;
    QList<WidgetData> m_widgetData;
    ConfigData m_config;
    CardData m_cardData;
    TransformersInfo m_transformersInfo;
    GgufData m_gguf;
    QList<SiblingFile> m_siblings;
    QStringList m_spaces;
    QString m_createdAt;
    qint64 m_usedStorage;
    bool m_loadModelProcess;
    bool m_successModelProcess;
    QString m_readMe;

    QNetworkAccessManager* m_manager;
};

#endif // HUGGINGFACEMODELINFO_H
