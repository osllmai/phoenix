#ifndef ONLINEMODELLISTFILTER_H
#define ONLINEMODELLISTFILTER_H

#include <QObject>
#include <QtQml>
#include <QQmlEngine>
#include <QSortFilterProxyModel>
#include "../company.h"
#include "../companylist.h"

class OnlineModelListFilter: public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(FilterType filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged FINAL)
    Q_PROPERTY(int companyId READ companyId WRITE setCompanyId NOTIFY companyIdChanged FINAL)
    Q_PROPERTY(QString type READ type WRITE setType NOTIFY typeChanged FINAL)

public:
    explicit OnlineModelListFilter(QObject* parent = nullptr) : QSortFilterProxyModel(parent) {}
    explicit OnlineModelListFilter(QAbstractItemModel *model, QObject *parent);

    Q_INVOKABLE void filter(QString filter);

    enum class FilterType {
        InstallModel,
        Company,
        Type,
        Favorite,
        All
    };
    Q_ENUM(FilterType)

    int count() const;

    FilterType filterType() const;
    void setFilterType(FilterType newFilterType);

    int companyId() const;
    void setCompanyId(const int newCompany);

    QString type() const;
    void setType(const QString &newType);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;

signals:
    void countChanged();
    void filterTypeChanged();
    void companyIdChanged();
    void typeChanged();

private:
    FilterType m_filterType;
    int m_companyId;
    QString m_type;
};


#endif // ONLINEMODELLISTFILTER_H
