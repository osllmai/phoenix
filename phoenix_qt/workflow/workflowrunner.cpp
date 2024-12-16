#include "workflowrunner.h"

#include "workflowstep.h"
#include "workflowstepfield.h"

#include "blocks/chatinputblock.h"
#include "blocks/openaistep.h"
#include "blocks/outputstep.h"

WorkFlowRunner::WorkFlowRunner(QObject *parent)
    : QObject{parent}
{
    createStep<ChatInputBlock>();
    createStep<OpenAIStep>();
    createStep<OutputStep>();

    Q_EMIT stepsChanged();
}

void WorkFlowRunner::start()
{
    setCurrentStep(0);
    setTotalSteps(m_steps.size());

    if (!m_steps.size()) {
        Q_EMIT finished();
        return;
    }

    std::for_each(m_steps.begin(), m_steps.end(), [this](WorkFlowStep *step) {
        step->init();
        connect(step, &WorkFlowStep::finished, this, &WorkFlowRunner::step_finished);
    });

    m_steps.first()->run();
}

WorkFlowStepField *WorkFlowRunner::field(const QString &name) const
{
    for (auto &step : m_steps)
        for (auto field : step->fieldsList())
            if (field->name() == name)
                return field;
    return nullptr;
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

void WorkFlowRunner::step_finished()
{
    if (m_currentStep == m_totalSteps - 1) {
        Q_EMIT finished();
        return;
    }

    setCurrentStep(m_currentStep + 1);
    m_steps[m_currentStep]->run();
}

int WorkFlowRunner::totalSteps() const
{
    return m_totalSteps;
}

void WorkFlowRunner::setTotalSteps(int newTotalSteps)
{
    if (m_totalSteps == newTotalSteps)
        return;
    m_totalSteps = newTotalSteps;
    emit totalStepsChanged();
}

QList<WorkFlowStep *> WorkFlowRunner::steps() const
{
    return m_steps;
}

bool WorkFlowRunner::isReady() const
{
    return m_isReady;
}

void WorkFlowRunner::step_readyChanged()
{
    auto b = std::all_of(m_steps.begin(), m_steps.end(), [](WorkFlowStep *step) {
        return step->isReady();
    });

    if (b != m_isReady) {
        m_isReady = b;
        Q_EMIT isReadyChanged();
    }
}

void WorkFlowRunner::addStep(WorkFlowStep *step)
{
    connect(step, &WorkFlowStep::isReadyChanged, this, &WorkFlowRunner::step_readyChanged);
    m_steps << step;
}
