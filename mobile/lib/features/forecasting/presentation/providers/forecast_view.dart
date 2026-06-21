import 'package:flutter_riverpod/legacy.dart';

/// Which Forecasting state renders. Defaults to the success PREVIEW; the
/// header's debug menu flips it (and the desktop backend will drive it for real
/// once wired). Mirrors the design mock's states.
enum ForecastView { firstRun, success, denied, loading, error }

/// New users (no data, no run yet) see [ForecastView.firstRun]; the populated
/// [success] view appears once a real forecast result exists.
final forecastViewProvider =
    StateProvider<ForecastView>((ref) => ForecastView.firstRun);
