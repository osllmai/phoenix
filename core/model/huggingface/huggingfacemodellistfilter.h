#ifndef HUGGINGFACEMODELLISTFILTER_H
#define HUGGINGFACEMODELLISTFILTER_H

#include <QObject>
#include <QQmlEngine>
#include <QSortFilterProxyModel>
#include "huggingfacemodellist.h"
#include "huggingfacemodel.h"

class HuggingfaceModelListFilter : public QSortFilterProxyModel
{
    Q_OBJECT
    QML_ELEMENT
    Q_PROPERTY(int count READ count NOTIFY countChanged FINAL)
    Q_PROPERTY(FilterType filterType READ filterType WRITE setFilterType NOTIFY filterTypeChanged FINAL)
    Q_PROPERTY(QString task READ task WRITE setTask NOTIFY taskChanged FINAL)
    Q_PROPERTY(QString library READ library WRITE setLibrary NOTIFY libraryChanged FINAL)
    Q_PROPERTY(QString filterStr READ filterStr WRITE setFilterStr NOTIFY filterStrChanged FINAL)

public:
    explicit HuggingfaceModelListFilter(QObject* parent = nullptr);
    explicit HuggingfaceModelListFilter(QAbstractItemModel *model, QObject *parent = nullptr);

    Q_INVOKABLE QVariantMap get(int index) const;

    enum class FilterType {
        All,
        MostLiked,
        MostDownloaded,
    };
    Q_ENUM(FilterType)

    int count() const;

    FilterType filterType() const { return m_filterType; }
    void setFilterType(FilterType newFilterType);

    QString task() const;
    void setTask(const QString &newTask);

    QString library() const;
    void setLibrary(const QString &newLibrary);

    QString filterStr() const;
    void setFilterStr(const QString &newFilterStr);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    void setSourceModel(QAbstractItemModel *sourceModel) override;

signals:
    void countChanged();
    void filterTypeChanged();
    void taskChanged();
    void libraryChanged();
    void filterStrChanged();

private:
    void init();

    FilterType m_filterType{FilterType::All};
    QString m_task = "all";
    QString m_library = "all";
    QString m_filterStr = "all";
};

#endif // HUGGINGFACEMODELLISTFILTER_H
