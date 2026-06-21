import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/responsive/breakpoints.dart';
import '../widgets/document_inspector.dart';
import '../widgets/document_library.dart';
import '../widgets/documents_header.dart';

class DocumentsScreen extends ConsumerWidget {
  const DocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ff = formFactorOf(context);
    if (ff.hasSidePane) return const _WidePane();
    return const _PhoneFlow();
  }
}

class _WidePane extends StatelessWidget {
  const _WidePane();

  @override
  Widget build(BuildContext context) {
    final listWidth = formFactorOf(context).isDesktop ? 380.0 : 300.0;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DocumentsHeader(),
            const JobBar(),
            Expanded(
              child: Row(
                children: [
                  SizedBox(width: listWidth, child: const DocumentLibrary()),
                  const VerticalDivider(width: 1),
                  const Expanded(child: DocumentInspector()),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PhoneFlow extends StatefulWidget {
  const _PhoneFlow();

  @override
  State<_PhoneFlow> createState() => _PhoneFlowState();
}

class _PhoneFlowState extends State<_PhoneFlow> {
  bool _detail = false;

  @override
  Widget build(BuildContext context) {
    if (_detail) {
      return Scaffold(
        body: SafeArea(
          child: DocumentInspector(
            onBack: () => setState(() => _detail = false),
          ),
        ),
      );
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const DocumentsHeader(),
            const JobBar(),
            Expanded(
              child: DocumentLibrary(
                onSelected: () => setState(() => _detail = true),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
