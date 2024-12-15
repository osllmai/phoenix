#include "workflowrunner.h"

#include "workflowstep.h"

WorkFlowRunner::WorkFlowRunner(QObject *parent)
    : QObject{parent}
{}

void WorkFlowRunner::start() {
    setCurrentStep(0);
    setSteps(m_stepsList.size());

    if (!m_stepsList.size()) {
        Q_EMIT finished();
        return;
    }

    for (auto &step:m_stepsList)
        connect(step, &WorkFlowStep::finished,this, &WorkFlowRunner::stepFinished);

    m_stepsList.first()->run();
}

int WorkFlowRunner::currentStep() const
{
    return m_currentStep;
}

void WorkFlowRunner::setCurrentStep(int newCurrentStep)
{
    if (m_currentStep == newCurrentStep)
        return;
    m_currentStep = newCurrentStep;
    emit currentStepChanged();
}

int WorkFlowRunner::steps() const
{
    return m_steps;
}

void WorkFlowRunner::setSteps(int newSteps)
{
    if (m_steps == newSteps)
        return;
    m_steps = newSteps;
    emit stepsChanged();
}

void WorkFlowRunner::stepFinished() {
    if (m_currentStep== m_steps-1) {
        Q_EMIT finished();
        return;
    }

    setCurrentStep(m_currentStep + 1);
    m_stepsList[m_currentStep]->run();
}
