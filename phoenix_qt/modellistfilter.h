#pragma once

#include "currentmodellist.h"

#include <QQmlEngine>
#include <QSortFilterProxyModel>

class ModelListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(CurrentModelList* currentModelList READ currentModelList WRITE setCurrentModelList NOTIFY currentModelListChanged FINAL)
    Q_PROPERTY(BackendType backendType READ backendType WRITE setBackendType NOTIFY backendTypeChanged FINAL)
    Q_PROPERTY(QString searchTerm READ searchTerm WRITE setSearchTerm NOTIFY searchTermChanged FINAL)

public:
    enum class BackendType {
        LocalModel,
        OnlineProvider,
        All
    };
    Q_ENUM(BackendType)

    explicit ModelListFilter(QObject *parent = nullptr);

    BackendType backendType() const;
    void setBackendType(BackendType newBackendType);

    QString searchTerm() const;
    void setSearchTerm(const QString &newSearchTerm);

    CurrentModelList *currentModelList() const;
    void setCurrentModelList(CurrentModelList *newCurrentModelList);

signals:
    void modelListChanged();
    void backendTypeChanged();
    void searchTermChanged();

    void currentModelListChanged();

private:
    CurrentModelList *m_currentModelList = nullptr;
    BackendType m_backendType{BackendType::All};
    QString m_searchTerm;


protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
};
