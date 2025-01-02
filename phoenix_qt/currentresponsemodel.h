#ifndef CURRENTRESPONSEMODEL_H
#define CURRENTRESPONSEMODEL_H

#include <QObject>
#include <QQmlEngine>
#include <QtQml>

#include <QAbstractListModel>


class CurrentResponseModel : public QAbstractListModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int size READ size NOTIFY sizeChanged)

    enum ChatlRoles {
        IdRole = Qt::UserRole + 1,
        TextRole
    };

public:
    explicit CurrentResponseModel(QObject *parent = nullptr);
    void updateResponse(const QString &token);

    //*------------------------------------------------------------------------------****************************------------------------------------------------------------------------------*//
    //*-------------------------------------------------------------------------------* QAbstractItemModel interface*------------------------------------------------------------------------------*//
    int rowCount(const QModelIndex &parent) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;
    Qt::ItemFlags flags(const QModelIndex &index) const override;
    bool setData(const QModelIndex &index, const QVariant &value, int role) override;
    //*---------------------------------------------------------------------------* end QAbstractItemModel interface *----------------------------------------------------------------------------*//

    int size() const;

signals:
    void sizeChanged();

private:
    QList<QString> texts;
    int numberOfTokenInLastText;
};

#endif // CURRENTRESPONSEMODEL_H
