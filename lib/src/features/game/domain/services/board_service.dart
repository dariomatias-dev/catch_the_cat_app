import 'dart:collection';
import 'dart:math';

import 'package:catch_the_cat/src/features/game/domain/entities/cell_state.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/difficulty.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/game_result.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/position.dart';

const int kBoardSize = 11;

(int, int) _blockedRange(Difficulty difficulty) => switch (difficulty) {
  Difficulty.easy => (6, 10),
  Difficulty.medium => (9, 15),
  Difficulty.hard => (12, 16),
};

abstract final class BoardService {
  static List<List<CellState>> createBoard() {
    return List.generate(
      kBoardSize,
      (_) => List.generate(kBoardSize, (_) => CellState.empty),
    );
  }

  static List<List<CellState>> copyBoard(List<List<CellState>> board) {
    return board.map((row) => List<CellState>.from(row)).toList();
  }

  static Position catStart(Difficulty difficulty, Random rng) =>
      switch (difficulty) {
        Difficulty.easy => Position(2 + rng.nextInt(7), 2 + rng.nextInt(7)),
        Difficulty.medium => Position(3 + rng.nextInt(5), 3 + rng.nextInt(5)),
        Difficulty.hard => const Position(5, 5),
      };

  static List<List<CellState>> initBoard(
    Random rng,
    Difficulty difficulty,
    Position catStart,
  ) {
    final (min, max) = _blockedRange(difficulty);
    final count = min + rng.nextInt(max - min + 1);
    List<List<CellState>> board;

    do {
      board = createBoard();
      final available = <Position>[
        for (int r = 0; r < kBoardSize; r++)
          for (int c = 0; c < kBoardSize; c++)
            if (r != catStart.row || c != catStart.col) Position(r, c),
      ]..shuffle(rng);

      for (int i = 0; i < count; i++) {
        board[available[i].row][available[i].col] = CellState.blocked;
      }
      board[catStart.row][catStart.col] = CellState.cat;
    } while (shortestEscapeDistance(catStart, board) == null);

    return board;
  }

  static List<Position> neighbors(Position pos) {
    final r = pos.row;
    final c = pos.col;
    final List<(int, int)> offsets;

    if (r % 2 == 0) {
      offsets = <(int, int)>[
        (r - 1, c - 1),
        (r - 1, c),
        (r, c - 1),
        (r, c + 1),
        (r + 1, c - 1),
        (r + 1, c),
      ];
    } else {
      offsets = <(int, int)>[
        (r - 1, c),
        (r - 1, c + 1),
        (r, c - 1),
        (r, c + 1),
        (r + 1, c),
        (r + 1, c + 1),
      ];
    }

    return <Position>[
      for (final (nr, nc) in offsets)
        if (nr >= 0 && nr < kBoardSize && nc >= 0 && nc < kBoardSize)
          Position(nr, nc),
    ];
  }

  static bool isBorder(Position pos) =>
      pos.row == 0 ||
      pos.row == kBoardSize - 1 ||
      pos.col == 0 ||
      pos.col == kBoardSize - 1;

  static List<Position> validMoves(
    Position catPos,
    List<List<CellState>> board,
  ) => neighbors(
    catPos,
  ).where((p) => board[p.row][p.col] == CellState.empty).toList();

  static int? shortestEscapeDistance(
    Position catPos,
    List<List<CellState>> board,
  ) {
    if (isBorder(catPos)) return 0;
    final queue = Queue<(Position, int)>();
    final visited = <Position>{catPos};
    queue.add((catPos, 0));

    while (queue.isNotEmpty) {
      final (pos, dist) = queue.removeFirst();
      for (final n in neighbors(pos)) {
        if (visited.contains(n)) continue;
        if (board[n.row][n.col] == CellState.blocked) continue;
        if (isBorder(n)) return dist + 1;
        visited.add(n);
        queue.add((n, dist + 1));
      }
    }
    return null;
  }

  static List<Position> shortestEscapePath(
    Position catPos,
    List<List<CellState>> board,
  ) {
    if (isBorder(catPos)) return <Position>[];
    final queue = Queue<Position>();
    final cameFrom = <Position, Position?>{catPos: null};
    queue.add(catPos);
    Position? exit;

    outer:
    while (queue.isNotEmpty) {
      final pos = queue.removeFirst();
      for (final n in neighbors(pos)) {
        if (cameFrom.containsKey(n)) continue;
        if (board[n.row][n.col] == CellState.blocked) continue;
        cameFrom[n] = pos;
        if (isBorder(n)) {
          exit = n;
          break outer;
        }
        queue.add(n);
      }
    }

    if (exit == null) return <Position>[];

    final path = <Position>[];
    Position? cur = exit;
    while (cur != null && cur != catPos) {
      path.add(cur);
      cur = cameFrom[cur];
    }
    return path.reversed.toList();
  }

  static GameResult checkResult(Position catPos, List<List<CellState>> board) {
    if (isBorder(catPos)) return GameResult.playerWin;
    if (validMoves(catPos, board).isEmpty) return GameResult.cpuWin;
    return GameResult.inProgress;
  }
}
