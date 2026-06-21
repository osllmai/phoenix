import 'package:flutter/material.dart';

import '../providers/welcome_stage.dart';

/// The numbered 1·2·3·4 step rail with connecting lines. Completed steps show a
/// check, the current step is filled, the error step is tinted red.
class WelcomeStepIndicator extends StatelessWidget {
  const WelcomeStepIndicator({super.key, required this.stage, this.error = false});

  final WelcomeStage stage;
  final bool error;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final stages = WelcomeStage.values;
    final children = <Widget>[];
    for (var i = 0; i < stages.length; i++) {
      final done = i < stage.index;
      final active = i == stage.index;
      children.add(_dot(scheme, i + 1, done: done, active: active, err: error && active));
      if (i < stages.length - 1) {
        children.add(Expanded(
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 6),
            color: done ? scheme.primaryContainer : scheme.outlineVariant,
          ),
        ));
      }
    }
    return Row(children: children);
  }

  Widget _dot(ColorScheme scheme, int n,
      {required bool done, required bool active, required bool err}) {
    final Color bg, fg, border;
    if (err) {
      bg = scheme.errorContainer;
      fg = scheme.onErrorContainer;
      border = scheme.error;
    } else if (active) {
      bg = scheme.primary;
      fg = scheme.onPrimary;
      border = scheme.primary;
    } else if (done) {
      bg = scheme.primaryContainer;
      fg = scheme.onPrimaryContainer;
      border = scheme.primaryContainer;
    } else {
      bg = scheme.surfaceContainerHighest;
      fg = scheme.onSurfaceVariant;
      border = scheme.outline;
    }
    return Container(
      width: 30,
      height: 30,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        border: Border.all(color: border),
      ),
      child: done
          ? Icon(Icons.check, size: 16, color: fg)
          : Text('$n',
              style: TextStyle(color: fg, fontSize: 13, fontWeight: FontWeight.w600)),
    );
  }
}
