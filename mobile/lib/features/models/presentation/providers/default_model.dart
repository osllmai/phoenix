import 'package:phoenix_core/phoenix_core.dart';

/// Sentinel for the "choose each time" default-model option.
const noDefaultModelOption = '— None (choose each time) —';

/// The installed model the default-model [setting] refers to, or null when the
/// setting is the "none" sentinel or nothing installed matches. Tolerant of the
/// "Name · Quant" display form shown in settings — matches on the base name.
AiModel? matchDefaultModel(String setting, List<AiModel> installed) {
  final value = setting.trim();
  if (value.isEmpty || value == noDefaultModelOption) return null;
  final base = value.split('·').first.trim();
  for (final m in installed) {
    if (!m.isInstalled) continue;
    if (m.name == value || m.name == base) return m;
  }
  return null;
}
