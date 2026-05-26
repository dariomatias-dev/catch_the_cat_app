abstract interface class ScoreRepository {
  int get playerScore;

  int get cpuScore;

  Future<void> savePlayerScore(int score);

  Future<void> saveCpuScore(int score);

  Future<void> clearScores();
}
