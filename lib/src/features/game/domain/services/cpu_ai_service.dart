import 'dart:math';

import 'package:catch_the_cat/src/features/game/domain/entities/cell_state.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/difficulty.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/position.dart';
import 'package:catch_the_cat/src/features/game/domain/services/board_service.dart';

abstract final class CpuAiService {
  static final _rng = Random();

  static Position? getMove(
    Position catPos,
    List<List<CellState>> board,
    Difficulty difficulty,
  ) => switch (difficulty) {
    Difficulty.easy => _easy(board),
    Difficulty.medium => _medium(catPos, board),
    Difficulty.hard => _hard(catPos, board),
  };

  static List<Position> _emptyCells(List<List<CellState>> board) => <Position>[
    for (int r = 0; r < kBoardSize; r++)
      for (int c = 0; c < kBoardSize; c++)
        if (board[r][c] == CellState.empty) Position(r, c),
  ];

  static Position? _easy(List<List<CellState>> board) {
    final empty = _emptyCells(board);
    if (empty.isEmpty) return null;
    return empty[_rng.nextInt(empty.length)];
  }

  static Position? _medium(Position catPos, List<List<CellState>> board) {
    final path = BoardService.shortestEscapePath(catPos, board);
    if (path.isNotEmpty) return path.first;
    return _easy(board);
  }

  static Position? _hard(Position catPos, List<List<CellState>> board) {
    final path = BoardService.shortestEscapePath(catPos, board);
    if (path.isEmpty) return _easy(board);

    final currentDist =
        BoardService.shortestEscapeDistance(catPos, board) ?? 999;
    Position? best;
    int bestGain = -1;

    for (final candidate in path) {
      if (board[candidate.row][candidate.col] != CellState.empty) continue;
      board[candidate.row][candidate.col] = CellState.blocked;
      final newDist = BoardService.shortestEscapeDistance(catPos, board) ?? 999;
      board[candidate.row][candidate.col] = CellState.empty;

      final gain = newDist - currentDist;
      if (gain > bestGain) {
        bestGain = gain;
        best = candidate;
      }
    }

    return best ?? path.first;
  }
}
