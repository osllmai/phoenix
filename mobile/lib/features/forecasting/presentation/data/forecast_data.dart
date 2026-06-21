/// Static sample forecast for the on-device PREVIEW of the Forecasting screen.
/// Real series come from the paired desktop's TimesFM (PyTorch/Celery) backend;
/// this data mirrors the design mock so the tablet preview renders faithfully.
class ForecastRow {
  const ForecastRow(this.step, this.p10, this.p50, this.p90);
  final String step;
  final String p10;
  final String p50;
  final String p90;
}

class ForecastStat {
  const ForecastStat(this.label, this.value);
  final String label;
  final String value;
}

abstract final class ForecastSample {
  static const symbol = 'AAPL · 1D';
  static const horizon = 24;

  static const history = <double>[
    62, 58, 64, 67, 63, 70, 74, 71, 78, 82, 79, 86,
    84, 90, 95, 92, 98, 103, 99, 107, 112, 108, 116, 121,
  ];

  static const p50 = <double>[
    124, 128, 131, 134, 137, 139, 142, 145, 147, 150, 152, 154,
    151, 156, 159, 157, 162, 166, 163, 168, 172, 170, 175, 179,
  ];

  static double _spread(int i) => 6 + i * 0.9;
  static List<double> get p10 =>
      [for (var i = 0; i < p50.length; i++) p50[i] - _spread(i)];
  static List<double> get p90 =>
      [for (var i = 0; i < p50.length; i++) p50[i] + _spread(i)];

  static const stats = <ForecastStat>[
    ForecastStat('Next step (P50)', '128.4'),
    ForecastStat('P10–P90 (next)', '119–138'),
    ForecastStat('Trend', '▲ +6.2%'),
    ForecastStat('MASE', '0.71'),
  ];

  static const rows = <ForecastRow>[
    ForecastRow('+1 · 2026-06-22', '119.0', '128.4', '138.1'),
    ForecastRow('+2 · 2026-06-23', '121.3', '131.0', '141.8'),
    ForecastRow('+3 · 2026-06-24', '122.9', '133.6', '145.2'),
    ForecastRow('…', '…', '…', '…'),
    ForecastRow('+24 · 2026-07-24', '138.6', '159.2', '181.4'),
  ];
}
