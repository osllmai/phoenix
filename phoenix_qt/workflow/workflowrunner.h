#pragma once

#include <QObject>
#include <QQmlEngine>

class WorkFlowStep;
class WorkFlowStepField;
class WorkFlowRunner : public QObject
{
    Q_OBJECT
    QML_ELEMENT

    Q_PROPERTY(int currentStep READ currentStep WRITE setCurrentStep NOTIFY currentStepChanged FINAL)
    Q_PROPERTY(int totalSteps READ totalSteps WRITE setTotalSteps NOTIFY totalStepsChanged FINAL)
    Q_PROPERTY(QList<WorkFlowStep *> steps READ steps NOTIFY stepsChanged FINAL)
    Q_PROPERTY(bool isReady READ isReady NOTIFY isReadyChanged FINAL)
public:
    explicit WorkFlowRunner(QObject *parent = nullptr);

    Q_INVOKABLE void start();

    WorkFlowStepField *field(const QString &name) const;

    int currentStep() const;
    void setCurrentStep(int newCurrentStep);

    int totalSteps() const;
    void setTotalSteps(int newTotalSteps);

    QList<WorkFlowStep *> steps() const;

    bool isReady() const;

    template<class T>
    T* createStep() {
        auto t = new T{this};
        addStep(t);
        return t;
    }

Q_SIGNALS:
    void inputRequired();
    void currentStepChanged();
    void stepsChanged();
    void finished();

    void totalStepsChanged();

    void isReadyChanged();

private Q_SLOTS:
    void step_finished();
    void step_readyChanged();

private:
    void addStep(WorkFlowStep *step);
    int m_currentStep;
    int m_totalSteps;
    QList<WorkFlowStep *> m_steps;
    bool m_isReady{false};
};
