import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/documents/presentation/data/documents_repository.dart';
import 'package:phoenix/features/documents/presentation/providers/document.dart';

class MockDocumentsRepository extends Mock implements DocumentsRepository {}

final sampleListDocs = <PhoenixDocument>[
  const PhoenixDocument(
    id: '1',
    title: 'llama-3-technical-report.pdf',
    kind: DocKind.pdf,
    status: DocStatus.converted,
    meta: 'Jun 9',
    badge: 'PDF',
  ),
  const PhoenixDocument(
    id: '2',
    title: 'product-roadmap-2026.docx',
    kind: DocKind.office,
    status: DocStatus.converting,
    meta: 'Jun 8',
    badge: 'DOCX',
  ),
];

PhoenixDocument detailFor(String id) => PhoenixDocument(
      id: id,
      title: id == '1'
          ? 'llama-3-technical-report.pdf'
          : 'product-roadmap-2026.docx',
      kind: DocKind.pdf,
      status: DocStatus.converted,
      meta: 'Jun 9',
      badge: 'PDF',
      markdown: '## Loaded from API\n\nDocument $id body.',
    );
