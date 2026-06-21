enum MetricStatus { pass, warn, fail }

class EvaluatorMetric {
  const EvaluatorMetric({
    required this.label,
    required this.value,
    required this.fraction,
    required this.threshold,
    required this.status,
  });

  final String label;
  final String value;
  final double fraction;
  final String threshold;
  final MetricStatus status;
}

class Scorecard {
  const Scorecard({
    required this.title,
    required this.run,
    required this.passed,
    required this.verdictLabel,
    required this.metrics,
    required this.note,
  });

  final String title;
  final String run;
  final bool passed;
  final String verdictLabel;
  final List<EvaluatorMetric> metrics;
  final String note;
}

class EvaluatorsData {
  const EvaluatorsData({
    required this.statusLabel,
    required this.scorecards,
    required this.desktopNote,
  });

  final String statusLabel;
  final List<Scorecard> scorecards;
  final String desktopNote;
}

const evaluatorsSample = EvaluatorsData(
  statusLabel: '2 evaluators enabled · view-only on mobile',
  desktopNote: 'Running and configuring evaluators — judge models, '
      'thresholds, gates — happens on desktop. Mobile is view-only.',
  scorecards: [
    Scorecard(
      title: 'claude-code · "draft OAuth guide"',
      run: 'run #1284 · indoxJudge · llama-3.1-8b · 12s',
      passed: true,
      verdictLabel: '✓ Quality gate: PASS (≥0.8)',
      metrics: [
        EvaluatorMetric(
          label: 'Faithfulness',
          value: '0.94',
          fraction: 0.94,
          threshold: '≥0.8',
          status: MetricStatus.pass,
        ),
        EvaluatorMetric(
          label: 'Hallucination',
          value: '0.06',
          fraction: 0.06,
          threshold: '≤0.1',
          status: MetricStatus.pass,
        ),
        EvaluatorMetric(
          label: 'Toxicity',
          value: '0.01',
          fraction: 0.02,
          threshold: '≤0.1',
          status: MetricStatus.pass,
        ),
        EvaluatorMetric(
          label: 'Context precision',
          value: '0.88',
          fraction: 0.88,
          threshold: '≥0.8',
          status: MetricStatus.pass,
        ),
        EvaluatorMetric(
          label: 'Answer-relevancy',
          value: '0.76',
          fraction: 0.76,
          threshold: '<0.8',
          status: MetricStatus.warn,
        ),
      ],
      note: 'Gate aggregates required metrics. One soft warning '
          '(answer-relevancy) did not fail the gate.',
    ),
    Scorecard(
      title: 'flow:summarize · "Q2 board deck"',
      run: 'run #1281 · Ragas · llama-3.1-8b · 18s',
      passed: false,
      verdictLabel: '✕ Quality gate: FAIL (<0.8)',
      metrics: [
        EvaluatorMetric(
          label: 'Faithfulness',
          value: '0.61',
          fraction: 0.61,
          threshold: '≥0.8',
          status: MetricStatus.fail,
        ),
        EvaluatorMetric(
          label: 'Context precision',
          value: '0.72',
          fraction: 0.72,
          threshold: '≥0.8',
          status: MetricStatus.warn,
        ),
        EvaluatorMetric(
          label: 'Answer-relevancy',
          value: '0.83',
          fraction: 0.83,
          threshold: '≥0.8',
          status: MetricStatus.pass,
        ),
      ],
      note: 'Faithfulness below threshold failed the gate. '
          'Re-run from desktop after adjusting context.',
    ),
  ],
);
