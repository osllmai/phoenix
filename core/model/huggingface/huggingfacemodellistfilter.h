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
    Q_PROPERTY(QString pipelineTag READ pipelineTag WRITE setPipelineTag NOTIFY pipelineTagChanged FINAL)

public:
    explicit HuggingfaceModelListFilter(QObject* parent = nullptr);
    explicit HuggingfaceModelListFilter(QAbstractItemModel *model, QObject *parent = nullptr);

    enum class FilterType {
        All,
        MostLiked,
        MostDownloaded,
        PipelineTag
    };
    Q_ENUM(FilterType)

    int count() const;

    FilterType filterType() const { return m_filterType; }
    void setFilterType(FilterType newFilterType);

    QString pipelineTag() const { return m_pipelineTag; }
    void setPipelineTag(const QString &newTag);

protected:
    bool filterAcceptsRow(int sourceRow, const QModelIndex &sourceParent) const override;
    void setSourceModel(QAbstractItemModel *sourceModel) override;

signals:
    void countChanged();
    void filterTypeChanged();
    void pipelineTagChanged();

private:
    void init();

    FilterType m_filterType{FilterType::All};
    QString m_pipelineTag{};
};

#endif // HUGGINGFACEMODELLISTFILTER_H
