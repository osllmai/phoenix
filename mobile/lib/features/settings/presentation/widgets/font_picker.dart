import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/fonts.dart';

Future<void> showFontPicker({
  required BuildContext context,
  required String selected,
  required ValueChanged<String> onSelected,
  required VoidCallback onFetchFailed,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (_) => _FontPickerSheet(
      selected: selected,
      onSelected: onSelected,
      onFetchFailed: onFetchFailed,
    ),
  );
}

class _FontPickerSheet extends StatefulWidget {
  const _FontPickerSheet({
    required this.selected,
    required this.onSelected,
    required this.onFetchFailed,
  });

  final String selected;
  final ValueChanged<String> onSelected;
  final VoidCallback onFetchFailed;

  @override
  State<_FontPickerSheet> createState() => _FontPickerSheetState();
}

class _FontPickerSheetState extends State<_FontPickerSheet> {
  String _query = '';

  List<String> _families() {
    final q = _query.trim().toLowerCase();
    if (q.isEmpty) {
      return [...kFontOptions.values, ...kPopularGoogleFonts];
    }
    final hits = GoogleFonts.asMap().keys
        .where((k) => k.toLowerCase().contains(q))
        .take(80)
        .toList();
    final bundled = kFontOptions.values
        .where((f) => f.toLowerCase().contains(q));
    return {...bundled, ...hits}.toList();
  }

  void _pick(String family) {
    if (!isBundledFont(family)) {
      try {
        GoogleFonts.getFont(family);
      } catch (_) {
        widget.onFetchFailed();
        Navigator.of(context).pop();
        return;
      }
    }
    widget.onSelected(family);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final families = _families();
    final inset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: inset),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search Google Fonts',
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: families.length,
                itemBuilder: (_, i) => _FontTile(
                  family: families[i],
                  selected: families[i] == widget.selected,
                  onTap: () => _pick(families[i]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FontTile extends StatelessWidget {
  const _FontTile({
    required this.family,
    required this.selected,
    required this.onTap,
  });

  final String family;
  final bool selected;
  final VoidCallback onTap;

  TextStyle? _previewStyle() {
    if (isBundledFont(family)) return TextStyle(fontFamily: family);
    try {
      return GoogleFonts.getFont(family);
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bundled = isBundledFont(family);
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      title: Text(family, style: _previewStyle()),
      leading: Icon(
        bundled ? Icons.offline_pin_outlined : Icons.cloud_download_outlined,
        size: 20,
        color: scheme.onSurfaceVariant,
      ),
      trailing: selected ? const Icon(Icons.check) : null,
      onTap: onTap,
    );
  }
}
