#pragma once

#include "modellist.h"

#include <QQmlEngine>
#include <QSortFilterProxyModel>

class ModelListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(ModelList* modelList READ modelList WRITE setModelList NOTIFY modelListChanged FINAL)
    Q_PROPERTY(BackendType backendType READ backendType WRITE setBackendType NOTIFY backendTypeChanged FINAL)
    Q_PROPERTY(QString searchTerm READ searchTerm WRITE setSearchTerm NOTIFY searchTermChanged FINAL)

public:
    enum class BackendType {
        LocalModel,
        OnlineProvider,
        AllProviders
    };
    Q_ENUM(BackendType)

    enum class ReadyType {
        Ready,
        NotReady,
        All
    };
    Q_ENUM(ReadyType)

    explicit ModelListFilter(QObject *parent = nullptr);

    BackendType backendType() const;
    void setBackendType(BackendType newBackendType);

    QString searchTerm() const;
    void setSearchTerm(const QString &newSearchTerm);

    ModelList *modelList() const;
    void setModelList(ModelList *newModelList);

signals:
    void modelListChanged();
    void backendTypeChanged();
    void searchTermChanged();

private:
    ModelList *m_modelList = nullptr;
    BackendType m_backendType{BackendType::AllProviders};
    ReadyType m_readyType{ReadyType::All};
    QString m_searchTerm;


protected:
    bool filterAcceptsRow(int source_row, const QModelIndex &source_parent) const override;
};
