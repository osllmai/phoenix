#pragma once

#include <QObject>

class WorkFlowStep;
class WorkFlowRunner : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int currentStep READ currentStep WRITE setCurrentStep NOTIFY currentStepChanged FINAL)
    Q_PROPERTY(int steps READ steps WRITE setSteps NOTIFY stepsChanged FINAL)

public:
    explicit WorkFlowRunner(QObject *parent = nullptr);


    Q_INVOKABLE void start();

    int currentStep() const;
    void setCurrentStep(int newCurrentStep);

    int steps() const;
    void setSteps(int newSteps);

Q_SIGNALS:
    void inputRequired();
    void currentStepChanged();
    void stepsChanged();
    void finished();

private Q_SLOTS:
    void stepFinished();

private:
    int m_currentStep;
    int m_steps;
    QList<WorkFlowStep *> m_stepsList;
};
