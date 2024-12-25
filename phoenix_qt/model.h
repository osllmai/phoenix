#ifndef MODEL_H
#define MODEL_H

#include <QObject>
#include <QtQml>

#include "download.h"

class Model : public QObject
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int id READ id WRITE setId NOTIFY idChanged )
    Q_PROPERTY(double fileSize READ fileSize WRITE setFileSize NOTIFY fileSizeChanged)
    Q_PROPERTY(int ramRamrequired READ ramRamrequired WRITE setRamRamrequired NOTIFY ramRamrequiredChanged)
    Q_PROPERTY(QString name READ name WRITE setName NOTIFY nameChanged)
    Q_PROPERTY(QString information READ information WRITE setInformation NOTIFY informationChanged)
    Q_PROPERTY(QString fileName READ fileName WRITE setFileName NOTIFY fileNameChanged)
    Q_PROPERTY(QString url READ url WRITE setUrl NOTIFY urlChanged)
    Q_PROPERTY(QString directoryPath READ directoryPath WRITE setDirectoryPath NOTIFY directoryPathChanged)
    Q_PROPERTY(QString parameters READ parameters WRITE setParameters NOTIFY parametersChanged)
    Q_PROPERTY(QString quant READ quant WRITE setQuant NOTIFY quantChanged)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged)
    Q_PROPERTY(QString promptTemplate READ promptTemplate WRITE setPromptTemplate NOTIFY promptTemplateChanged)
    Q_PROPERTY(QString systemPrompt READ systemPrompt WRITE setSystemPrompt NOTIFY systemPromptChanged)
    Q_PROPERTY(QString icon READ icon WRITE setIcon NOTIFY iconChanged)

    Q_PROPERTY(double downloadPercent READ downloadPercent WRITE setDownloadPercent NOTIFY downloadPercentChanged)

    Q_PROPERTY(bool isDownloading READ isDownloading WRITE setIsDownloading NOTIFY isDownloadingChanged)
    Q_PROPERTY(bool downloadFinished READ downloadFinished WRITE setDownloadFinished NOTIFY downloadFinishedChanged)

    Q_PROPERTY(BackendType backendType READ backendType WRITE setBackendType NOTIFY backendTypeChanged FINAL)
    Q_PROPERTY(QString apiKey READ apiKey WRITE setApiKey NOTIFY apiKeyChanged FINAL)

public:
    enum class BackendType {
        LocalModel,
        OnlineProvider
    };
    Q_ENUM(BackendType)

    explicit Model(QObject *parent = nullptr);
    Model(int id,
          double fileSize,
          int ramRamrequired,
          const QString &name,
          const QString &information,
          const QString &fileName,
          const QString &url,
          const QString &directoryPath,
          const QString &parameters,
          const QString &quant,
          const QString &type,
          const QString &promptTemplate,
          const QString &systemPrompt,
          const QString &icon,
          double downloadPercent,
          bool isDownloading,
          bool downloadFinished,
          QObject *parent = nullptr);

    virtual ~Model();
    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Read Property  *----------------------------------------------------------------------------------------*//
    int id() const;
    double fileSize() const;
    int ramRamrequired() const;
    QString parameters() const;
    QString quant() const;
    QString type() const;
    QString promptTemplate() const;
    QString systemPrompt() const;
    QString name() const;
    QString information() const;
    QString fileName() const;
    QString url() const;
    QString directoryPath() const;
    QString icon() const;
    double downloadPercent() const;
    bool isDownloading() const;
    bool downloadFinished() const;
    //*--------------------------------------------------------------------------------------* end Read Property *-------------------------------------------------------------------------------------*//


    //*----------------------------------------------------------------------------------------***************----------------------------------------------------------------------------------------*//
    //*----------------------------------------------------------------------------------------* Write Property *----------------------------------------------------------------------------------------*//
    void setId(const int id);
    void setFileSize(const double fileSize);
    void setRamRamrequired(const int ramRamrequired);
    void setParameters(const QString parameters);
    void setQuant(const QString quant);
    void setType(const QString type);
    void setPromptTemplate(const QString promptTemplate);
    void setSystemPrompt(const QString systemPrompt);
    void setName(const QString name);
    void setInformation(const QString information);
    void setFileName(const QString fileName);
    void setUrl(const QString url);
    void setDirectoryPath(const QString directoryPath);
    void setIcon(const QString icon);
    void setDownloadPercent(const double downloadPercent);
    void setIsDownloading(const bool isDownloading);
    void setDownloadFinished(const bool downloadFinished);
    //*-------------------------------------------------------------------------------------* end Write Property *--------------------------------------------------------------------------------------*//

    BackendType backendType() const;
    void setBackendType(BackendType newBackendType);

    QString apiKey() const;
    void setApiKey(const QString &newApiKey);

signals:
    void idChanged(int id);
    void fileSizeChanged(double fileSize);
    void ramRamrequiredChanged(int ramRamrequired);
    void parametersChanged(QString parameters);
    void quantChanged(QString quant);
    void typeChanged(QString type);
    void promptTemplateChanged(QString promptTemplate);
    void systemPromptChanged(QString systemPrompt);
    void nameChanged(QString name);
    void informationChanged(QString information);
    void fileNameChanged(QString fileName);
    void urlChanged(QString url);
    void directoryPathChanged(QString directoryPath);
    void iconChanged(QString icon);
    void downloadPercentChanged(double downloadPercent);
    void isDownloadingChanged(bool isDownloading);
    void downloadFinishedChanged(bool downloadFinished);
    void backendTypeChanged();

    void apiKeyChanged();

private:
    int m_id{};
    double m_fileSize{};
    int m_ramRamrequired{};
    QString m_parameters;
    QString m_quant;
    QString m_type;
    QString m_promptTemplate;
    QString m_systemPrompt;
    QString m_name;
    QString m_information;
    QString m_fileName;
    QString m_url;
    QString m_directoryPath;
    QString m_icon;
    double m_downloadPercent{};
    bool m_isDownloading{};
    bool m_downloadFinished{};
    BackendType m_backendType{BackendType::LocalModel};
    QString m_apiKey;
};

#endif // MODEL_H
