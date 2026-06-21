import 'package:desktop_drop/desktop_drop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;

import '../providers/model_providers.dart';

/// Wraps [child] so dropping `.gguf` files onto it imports them into the catalog.
class DropImport extends ConsumerStatefulWidget {
  const DropImport({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<DropImport> createState() => _DropImportState();
}

class _DropImportState extends ConsumerState<DropImport> {
  bool _dragging = false;

  Future<void> _onDrop(DropDoneDetails detail) async {
    final messenger = ScaffoldMessenger.of(context);
    final ctrl = ref.read(modelsControllerProvider.notifier);
    setState(() => _dragging = false);
    final ggufs = detail.files
        .where((f) => f.path.toLowerCase().endsWith('.gguf'))
        .toList();
    if (ggufs.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Drop a .gguf file to add a model.')),
      );
      return;
    }
    for (final f in ggufs) {
      await ctrl.addLocal(
        name: p.basenameWithoutExtension(f.path),
        path: f.path,
      );
    }
    final n = ggufs.length;
    messenger.showSnackBar(
      SnackBar(content: Text('Added $n model${n == 1 ? '' : 's'}')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropTarget(
      onDragEntered: (_) => setState(() => _dragging = true),
      onDragExited: (_) => setState(() => _dragging = false),
      onDragDone: _onDrop,
      child: Stack(
        children: [
          widget.child,
          if (_dragging) const Positioned.fill(child: DropHint()),
        ],
      ),
    );
  }
}

/// Drag-over overlay prompting the user to drop a `.gguf`.
class DropHint extends StatelessWidget {
  const DropHint({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      color: cs.primary.withValues(alpha: 0.12),
      alignment: Alignment.center,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 22),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: cs.primary, width: 2),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.download, size: 40, color: cs.primary),
            const SizedBox(height: 10),
            Text(
              'Drop .gguf to add',
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
