import 'package:flutter_riverpod/legacy.dart';

import '../../data/online_catalog_stub.dart';

/// Which Online · IndoxHub state the screen renders. Defaults to the connected
/// success view; overridable in tests/goldens and via the header's demo menu
/// until the real cloud gateway drives it.
final onlineStateProvider =
    StateProvider<OnlineState>((ref) => OnlineState.success);
