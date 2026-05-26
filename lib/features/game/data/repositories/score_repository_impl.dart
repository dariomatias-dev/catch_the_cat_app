import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/score_repository.dart';

const _kPlayerScore = 'player_score';
const _kCpuScore = 'cpu_score';

class ScoreRepositoryImpl implements ScoreRepository {
  const ScoreRepositoryImpl(this._prefs);

  final SharedPreferences _prefs;

  @override
  int get playerScore => _prefs.getInt(_kPlayerScore) ?? 0;

  @override
  int get cpuScore => _prefs.getInt(_kCpuScore) ?? 0;

  @override
  Future<void> savePlayerScore(int score) => _prefs.setInt(_kPlayerScore, score);

  @override
  Future<void> saveCpuScore(int score) => _prefs.setInt(_kCpuScore, score);

  @override
  Future<void> clearScores() async {
    await _prefs.remove(_kPlayerScore);
    await _prefs.remove(_kCpuScore);
  }
}
