import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'speech_controller.dart';
import 'speech_state.dart';

part 'past_transcriptions_provider.g.dart';

@riverpod
List<PastTranscription> pastTranscriptions(Ref ref) =>
    ref.watch(speechControllerProvider).history;
