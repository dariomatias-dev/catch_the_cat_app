import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/providers/shared_preferences_provider.dart';
import '../data/repositories/score_repository_impl.dart';
import '../domain/repositories/score_repository.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return ScoreRepositoryImpl(prefs);
});
