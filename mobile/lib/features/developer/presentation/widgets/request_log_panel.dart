import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/server_console_controller.dart';
import '../providers/server_console_state.dart';
import 'console_card.dart';

class RequestLogPanel extends ConsumerWidget {
  const RequestLogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(serverConsoleControllerProvider);
    final controller = ref.read(serverConsoleControllerProvider.notifier);
    final scheme = Theme.of(context).colorScheme;

    // Placeholder: real PTY/log stream is deferred; rows are sample data.
    return ConsoleCard(
      title: 'Request log',
      subtitle: 'sample data · live PTY/log stream deferred',
      bodyPadding: EdgeInsets.zero,
      trailing: Row(
        children: [
          Icon(Icons.circle, size: 9,
              color: state.logLive ? scheme.primary : scheme.onSurfaceVariant),
          const SizedBox(width: 4),
          Text(state.logLive ? 'live' : 'paused',
              style: Theme.of(context).textTheme.labelSmall),
          const SizedBox(width: 8),
          TextButton(
            onPressed: controller.toggleLogLive,
            child: Text(state.logLive ? 'Pause' : 'Resume'),
          ),
        ],
      ),
      child: Container(
        decoration: BoxDecoration(
          color: scheme.surface,
          border: Border(top: BorderSide(color: scheme.outline)),
        ),
        child: Column(
          children: [for (final e in state.log) _LogRow(entry: e)],
        ),
      ),
    );
  }
}

class _LogRow extends StatelessWidget {
  const _LogRow({required this.entry});

  final RequestLogEntry entry;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mono = TextStyle(fontFamily: 'monospace', fontSize: 12, color: scheme.onSurfaceVariant);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 64, child: Text(entry.time, style: mono)),
          SizedBox(width: 48, child: Text(entry.method, style: mono.copyWith(color: scheme.primary))),
          Expanded(child: Text(entry.path, style: mono.copyWith(color: scheme.onSurface), overflow: TextOverflow.ellipsis)),
          SizedBox(width: 110, child: Text(entry.model, style: mono, overflow: TextOverflow.ellipsis)),
          _StatusChip(status: entry.status),
          SizedBox(width: 72, child: Text(entry.latency, style: mono, textAlign: TextAlign.right)),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final int status;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final color = status >= 500 || status == 401
        ? scheme.error
        : status >= 400
            ? scheme.onSurfaceVariant
            : scheme.primary;
    return SizedBox(
      width: 48,
      child: Text('$status',
          style: TextStyle(fontFamily: 'monospace', fontSize: 12, color: color)),
    );
  }
}
