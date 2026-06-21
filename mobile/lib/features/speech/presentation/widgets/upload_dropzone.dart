import 'package:flutter/material.dart';

/// Upload affordance mirroring the mock's dashed drop zone.
class UploadDropzone extends StatelessWidget {
  const UploadDropzone({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: DottedBorderBox(
        color: scheme.outline,
        child: Column(
          children: [
            Icon(Icons.folder_open_outlined,
                size: 24, color: scheme.onSurfaceVariant),
            const SizedBox(height: 8),
            Text('Choose an audio / video file',
                style: TextStyle(color: scheme.onSurfaceVariant)),
            const SizedBox(height: 4),
            Text('WAV · MP3 · M4A · FLAC · OGG · MP4',
                style: Theme.of(context).textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class DottedBorderBox extends StatelessWidget {
  const DottedBorderBox({super.key, required this.color, required this.child});

  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color, width: 2, strokeAlign: BorderSide.strokeAlignInside),
      ),
      child: child,
    );
  }
}
