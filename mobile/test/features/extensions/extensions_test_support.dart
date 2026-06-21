import 'package:mocktail/mocktail.dart';
import 'package:phoenix/features/extensions/presentation/data/extensions_repository.dart';
import 'package:phoenix/features/extensions/presentation/providers/extension_entry.dart';

class MockExtensionsRepository extends Mock implements ExtensionsRepository {}

const sampleEntries = <ExtensionEntry>[
  ExtensionEntry(
    id: 1,
    slug: 'docling',
    name: 'Documents · Docling',
    publisher: 'Phoenix',
    icon: '📄',
    category: ExtensionCategory.document,
    version: '1.2.0',
    description: 'Convert PDF / Office / images → clean markdown.',
    verified: true,
    installed: true,
    rating: 4.9,
    installsCount: 18000,
  ),
  ExtensionEntry(
    id: 2,
    slug: 'whisper',
    name: 'Speech · Whisper',
    publisher: 'Phoenix',
    icon: '🎙️',
    category: ExtensionCategory.speech,
    version: '0.9.1',
    description: 'Transcribe audio & video on-device.',
    verified: true,
    rating: 4.7,
    installsCount: 11000,
  ),
];
