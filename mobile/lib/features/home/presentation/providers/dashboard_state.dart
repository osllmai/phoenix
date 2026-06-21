import 'package:freezed_annotation/freezed_annotation.dart';

part 'dashboard_state.freezed.dart';

@freezed
abstract class DashboardStat with _$DashboardStat {
  const factory DashboardStat({
    required String label,
    required String value,
    required String unit,
    required String icon,
  }) = _DashboardStat;
}

@freezed
abstract class ResourceMeter with _$ResourceMeter {
  const factory ResourceMeter({
    required String label,
    required double fraction,
    required String detail,
  }) = _ResourceMeter;
}

@freezed
abstract class DashboardState with _$DashboardState {
  const factory DashboardState({
    @Default(<DashboardStat>[]) List<DashboardStat> stats,
    @Default(<ResourceMeter>[]) List<ResourceMeter> resources,
    @Default(false) bool serverRunning,
    @Default('') String serverEndpoint,
  }) = _DashboardState;
}
