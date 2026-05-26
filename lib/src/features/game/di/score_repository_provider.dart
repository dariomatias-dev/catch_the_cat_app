import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/providers/shared_preferences_provider.dart';

import 'package:catch_the_cat/src/features/game/data/repositories/score_repository_impl.dart';
import 'package:catch_the_cat/src/features/game/domain/repositories/score_repository.dart';

final scoreRepositoryProvider = Provider<ScoreRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);

  return ScoreRepositoryImpl(prefs);
});
