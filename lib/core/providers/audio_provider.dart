import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/audio_service.dart';

final audioServiceProvider = Provider<AudioService>((ref) {
  final service = AudioService();
  service.init();
  ref.onDispose(service.dispose);
  return service;
});

final isMutedProvider = StateProvider<bool>((ref) => false);
