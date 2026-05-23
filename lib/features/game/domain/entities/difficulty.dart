enum Difficulty { easy, medium, hard }

extension DifficultyExt on Difficulty {
  String get label => switch (this) {
        Difficulty.easy => 'Fácil',
        Difficulty.medium => 'Médio',
        Difficulty.hard => 'Difícil',
      };
}
