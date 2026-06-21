import 'package:flutter_test/flutter_test.dart';
import 'package:phoenix/features/models/data/catalog_entry.dart';
import 'package:phoenix/features/models/data/runnability.dart';

CatalogEntry _entry({double size = 0}) => CatalogEntry(
      org: 'o',
      modelName: 'm',
      name: 'm',
      filename: 'm.gguf',
      url: 'u',
      filesizeGb: size,
    );

void main() {
  test('needed RAM is computed from the file size, not a catalog field', () {
    expect(neededGbFor(_entry(size: 4)), closeTo(5.7, 0.001)); // 4*1.25 + 0.7
  });

  test('runs when usable RAM (after OS headroom) covers the need', () {
    final r = runnabilityFor(_entry(size: 4), 16); // need 5.7, usable 14.5
    expect(r.level, Runnability.runs);
    expect(r.neededGb, closeTo(5.7, 0.001));
  });

  test('tight when it fits total RAM but not after OS headroom', () {
    // need 5.7; device 6 → fits total, usable 4.5 < 5.7
    expect(runnabilityFor(_entry(size: 4), 6).level, Runnability.tight);
  });

  test('tooLarge when device RAM is below the computed need', () {
    expect(runnabilityFor(_entry(size: 4), 4).level, Runnability.tooLarge);
  });

  test('a big model is tooLarge on a typical tablet', () {
    final r = runnabilityFor(_entry(size: 14.7), 6); // ~19 GB need, 6 GB device
    expect(r.neededGb, closeTo(19.075, 0.001));
    expect(r.level, Runnability.tooLarge);
  });
}
