import 'package:flutter/material.dart';

const _info = Color(0xFF5B8BA5);

/// The banner warning that Online models run in the cloud, not on-device.
class CloudNotice extends StatelessWidget {
  const CloudNotice({super.key, this.text});

  final String? text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: _info.withValues(alpha: 0.12),
        border: Border(bottom: BorderSide(color: _info.withValues(alpha: 0.5))),
      ),
      child: Row(
        children: [
          Icon(Icons.cloud_outlined, size: 16, color: _info),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text ??
                  'These models run in the cloud via IndoxHub — not on-device. '
                      'Prompts leave your machine and bill against credits.',
              style: theme.textTheme.bodySmall
                  ?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
