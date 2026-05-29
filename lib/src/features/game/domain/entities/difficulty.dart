enum Difficulty { easy, medium, hard }

extension DifficultyExt on Difficulty {
  String get label => switch (this) {
    Difficulty.easy => 'Fácil',
    Difficulty.medium => 'Médio',
    Difficulty.hard => 'Difícil',
  };

  String get description => switch (this) {
    Difficulty.easy =>
      '6 - 10 blocos iniciais · Gato em posição aleatória · IA joga aleatório',
    Difficulty.medium =>
      '9 - 15 blocos iniciais · Gato mais centralizado · IA bloqueia fuga',
    Difficulty.hard =>
      '12 - 16 blocos iniciais · Gato sempre no centro · IA maximiza bloqueio',
  };
}
