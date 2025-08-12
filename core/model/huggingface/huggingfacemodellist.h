#ifndef HUGGINGFACEMODELLIST_H
#define HUGGINGFACEMODELLIST_H

#include <QObject>
#include <QQmlEngine>
#include <QAbstractListModel>

#include "./huggingfacemodel.h"

class HuggingfaceModelList: public QAbstractListModel
{
    Q_OBJECT
    QML_SINGLETON
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
public:
    static HuggingfaceModelList* instance(QObject* parent);

    enum HuggingfaceModelRoles {
        IdRole = Qt::UserRole + 1,
        IdModelRole,
        LikesRole,
        DownloadsRole,
        PiplineTagRole,
        TagsRole,
        CreatedAtRole,
        ModelObjectRole
    };

    int count() const;
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    // bool setData(const QModelIndex &index, const QVariant &value, int role) override;

signals:
    void countChanged();

private:
    explicit HuggingfaceModelList(QObject* parent);
    static HuggingfaceModelList* m_instance;

    QList<HuggingfaceModel*> m_models;
};

#endif // HUGGINGFACEMODELLIST_H
