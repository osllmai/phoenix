import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../models/data/catalog_entry.dart';
import '../../../models/data/catalog_repository.dart';
import 'welcome_content.dart';

part 'welcome_models.g.dart';

/// The three starter models offered on the choose-model step, sourced from the
/// real bundled catalog (recommended picks, smallest first).
@riverpod
Future<List<OnboardingModel>> onboardingModels(Ref ref) async {
  final byOrg = await ref.watch(modelCatalogProvider.future);
  final all = byOrg.values.expand((e) => e).toList();
  bool isChat(CatalogEntry e) => e.type.toLowerCase().contains('text');
  final chat = all.where(isChat).toList();
  final recommended = chat.where((e) => e.recommended).toList();
  final pool = (recommended.isNotEmpty ? recommended : (chat.isNotEmpty ? chat : all))
    ..sort((a, b) => a.filesizeGb.compareTo(b.filesizeGb));
  return pool.take(3).map(_toOption).toList();
}

OnboardingModel _toOption(CatalogEntry e) => OnboardingModel(
      id: e.modelName,
      icon: _iconFor(e.type),
      name: e.name,
      tagline: [e.parameters, e.type].where((s) => s.isNotEmpty).join(' · '),
      size: '${e.filesizeGb.toStringAsFixed(1)} GB',
      quant: e.quant.toUpperCase(),
    );

IconData _iconFor(String type) {
  final t = type.toLowerCase();
  if (t.contains('code')) return Icons.code;
  if (t.contains('vision') || t.contains('image')) return Icons.visibility_outlined;
  if (t.contains('embed')) return Icons.scatter_plot_outlined;
  return Icons.smart_toy_outlined;
}
