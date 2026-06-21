import 'catalog_entry.dart';

enum Runnability { runs, tight, tooLarge }

/// RAM a model needs to RUN, computed from its actual .gguf size (weights +
/// KV-cache/context + runtime overhead) — model/device-driven, NOT the catalog's
/// hand-entered minRamGB.
double neededGbFor(CatalogEntry e) => e.filesizeGb * 1.25 + 0.7;

/// Decides against the REAL device RAM, reserving headroom for the OS/other apps.
({Runnability level, double neededGb}) runnabilityFor(
  CatalogEntry e,
  double deviceRamGb,
) {
  final needed = neededGbFor(e);
  const osHeadroomGb = 1.5;
  final usable = deviceRamGb - osHeadroomGb;
  final Runnability level;
  if (usable >= needed) {
    level = Runnability.runs;
  } else if (deviceRamGb >= needed) {
    level = Runnability.tight;
  } else {
    level = Runnability.tooLarge;
  }
  return (level: level, neededGb: needed);
}
