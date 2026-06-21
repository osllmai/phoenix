import 'package:flutter/material.dart';

class SettingToggle extends StatelessWidget {
  const SettingToggle({super.key, required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Switch(value: value, onChanged: onChanged),
        const SizedBox(width: 8),
        Text(value ? 'On' : 'Off',
            style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class SettingPills extends StatelessWidget {
  const SettingPills({
    super.key,
    required this.options,
    required this.selected,
    required this.onSelected,
  });

  final List<String> options;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        for (var i = 0; i < options.length; i++)
          ChoiceChip(
            label: Text(options[i]),
            selected: i == selected,
            onSelected: (_) => onSelected(i),
          ),
      ],
    );
  }
}

class SettingSlider extends StatelessWidget {
  const SettingSlider({
    super.key,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    this.unit = '',
  });

  final double value;
  final double min;
  final double max;
  final String unit;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Expanded(
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),
        const SizedBox(width: 8),
        Text(
          '${value.round()}$unit',
          style: Theme.of(context).textTheme.bodyMedium
              ?.copyWith(color: scheme.primary),
        ),
      ],
    );
  }
}

class SettingSwatches extends StatelessWidget {
  const SettingSwatches({
    super.key,
    required this.colors,
    required this.selected,
    required this.onSelected,
  });

  final List<Color> colors;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (var i = 0; i < colors.length; i++)
          GestureDetector(
            onTap: () => onSelected(i),
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: colors[i],
                shape: BoxShape.circle,
                border: Border.all(
                  color: i == selected ? scheme.onSurface : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
