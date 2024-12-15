#pragma once

#include <QQuickPaintedItem>
#include <QUndoStack>

class Block;
class AbstractTool;
class RelationHandle;
class AbstractRelation;
class WorkFlowEditorArea : public QQuickPaintedItem
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(
        Tool selectedTool READ selectedTool WRITE setSelectedTool NOTIFY selectedToolChanged FINAL)
    Q_PROPERTY(QQmlComponent *highlightComponent READ highlightComponent WRITE setHighlightComponent
                   NOTIFY highlightComponentChanged FINAL)
    Q_PROPERTY(QQmlComponent *relationComponent READ relationComponent WRITE setRelationComponent
                   NOTIFY relationComponentChanged FINAL)
    Q_PROPERTY(int gridSize READ gridSize WRITE setGridSize NOTIFY gridSizeChanged FINAL)
    Q_PROPERTY(GridType gridType READ gridType WRITE setGridType NOTIFY gridTypeChanged FINAL)
    Q_PROPERTY(QColor gridColor READ gridColor WRITE setGridColor NOTIFY gridColorChanged FINAL)
    Q_PROPERTY(QColor backgroundColor READ backgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged FINAL)

public:
    enum class Tool { None, Select, Relation };
    Q_ENUM(Tool)

    enum class GridType { None, Dot, Grid };
    Q_ENUM(GridType)

    WorkFlowEditorArea(QQuickItem *parent = nullptr);
    void componentComplete() override;
    void paint(QPainter *painter) override;

    Q_INVOKABLE QQuickItem *addBlock(QQmlComponent *block, const QVariantMap &props);
    Q_INVOKABLE QQuickItem *addMiddleBlock(QQmlComponent *block,
                                           AbstractRelation *relation,
                                           const QVariantMap &props);

    Q_INVOKABLE AbstractRelation *addRelation(Block *from, Block *to);
    Q_INVOKABLE AbstractRelation *addRelation(RelationHandle *from, RelationHandle *to);
    Q_INVOKABLE Block *findBlock(const QUuid &uuid);

    QQmlComponent *highlightComponent() const;
    void setHighlightComponent(QQmlComponent *newHighlightComponent);

    Tool selectedTool() const;
    void setSelectedTool(Tool newSelectedTool);

    QQmlComponent *relationComponent() const;
    void setRelationComponent(QQmlComponent *newRelationComponent);

    int gridSize() const;
    void setGridSize(int newGridSize);

    GridType gridType() const;
    void setGridType(GridType newGridType);

    QColor gridColor() const;
    void setGridColor(const QColor &newGridColor);

    QColor backgroundColor() const;
    void setBackgroundColor(const QColor &newBackgroundColor);

    QList<Block *> blocks() const;

    QList<AbstractRelation *> relations() const;

protected:
    bool childMouseEventFilter(QQuickItem *, QEvent *);

Q_SIGNALS:
    void highlightComponentChanged();

    void selectedToolChanged();

    void relationComponentChanged();

    void gridSizeChanged();

    void gridTypeChanged();

    void gridColorChanged();

    void backgroundColorChanged();

private:
    QList<Block *> _blocks;
    QList<AbstractRelation *> _relations;

    void createTools();
    void tool_activated();

    QUndoStack _undoStack;
    AbstractTool *_activeTool{nullptr};
    QMap<Tool, AbstractTool *> _tools;
    QQmlComponent *m_highlightComponent = nullptr;
    Tool m_selectedTool{Tool::None};
    QQmlComponent *m_relationComponent = nullptr;
    int m_gridSize{10};
    GridType m_gridType{GridType::Dot};
    QColor m_gridColor{Qt::gray};
    QColor m_backgroundColor{Qt::white};

    friend class AddBlockCommand;
};
