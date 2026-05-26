import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/features/game/di/score_repository_provider.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/cell_state.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/difficulty.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/game_result.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/position.dart';
import 'package:catch_the_cat/src/features/game/domain/repositories/score_repository.dart';
import 'package:catch_the_cat/src/features/game/domain/services/board_service.dart';
import 'package:catch_the_cat/src/features/game/domain/services/cpu_ai_service.dart';
import 'package:catch_the_cat/src/features/game/presentation/view_models/game_state_view_model.dart';

final gameProvider = NotifierProvider<GameNotifier, GameStateViewModel>(
  GameNotifier.new,
);

class GameNotifier extends Notifier<GameStateViewModel> {
  final _rng = Random();
  int _generation = 0;

  ScoreRepository get _repo => ref.read(scoreRepositoryProvider);

  @override
  GameStateViewModel build() {
    final repo = ref.watch(scoreRepositoryProvider);

    return _newGameState(
      difficulty: Difficulty.medium,
      playerScore: repo.playerScore,
      cpuScore: repo.cpuScore,
    );
  }

  GameStateViewModel _newGameState({
    required Difficulty difficulty,
    required int playerScore,
    required int cpuScore,
  }) {
    final board = BoardService.initBoard(_rng);
    final moves = BoardService.validMoves(kCatStart, board);
    return GameStateViewModel(
      board: board,
      catPosition: kCatStart,
      result: GameResult.inProgress,
      playerScore: playerScore,
      cpuScore: cpuScore,
      difficulty: difficulty,
      validMoves: moves,
      isCpuThinking: false,
    );
  }

  void newGame() {
    _generation++;
    state = _newGameState(
      difficulty: state.difficulty,
      playerScore: state.playerScore,
      cpuScore: state.cpuScore,
    );
  }

  void clearScores() {
    _generation++;
    _repo.clearScores();
    state = _newGameState(
      difficulty: state.difficulty,
      playerScore: 0,
      cpuScore: 0,
    );
  }

  void setDifficulty(Difficulty difficulty) {
    state = state.copyWith(difficulty: difficulty);
  }

  Future<void> onCellTap(Position position) async {
    if (state.result != GameResult.inProgress) return;
    if (state.isCpuThinking) return;
    if (!state.validMoves.contains(position)) return;

    final gen = ++_generation;

    // Move cat
    var board = BoardService.copyBoard(state.board);
    board[state.catPosition.row][state.catPosition.col] = CellState.empty;
    board[position.row][position.col] = CellState.cat;

    final resultAfterMove = BoardService.checkResult(position, board);

    if (resultAfterMove == GameResult.playerWin) {
      final newPlayerScore = state.playerScore + 1;
      state = state.copyWith(
        board: BoardService.copyBoard(board),
        catPosition: position,
        result: GameResult.playerWin,
        playerScore: newPlayerScore,
        validMoves: const [],
        isCpuThinking: false,
      );
      await _repo.savePlayerScore(newPlayerScore);
      return;
    }

    state = state.copyWith(
      board: BoardService.copyBoard(board),
      catPosition: position,
      validMoves: const [],
      isCpuThinking: true,
    );

    await Future.delayed(const Duration(milliseconds: 450));
    if (_generation != gen) return;

    // CPU move
    board = BoardService.copyBoard(state.board);
    final cpuMove = CpuAiService.getMove(
      state.catPosition,
      board,
      state.difficulty,
    );
    if (cpuMove != null) {
      board[cpuMove.row][cpuMove.col] = CellState.blocked;
    }

    final resultAfterCpu = BoardService.checkResult(state.catPosition, board);
    final newMoves = resultAfterCpu == GameResult.inProgress
        ? BoardService.validMoves(state.catPosition, board)
        : const <Position>[];
    final newCpuScore = resultAfterCpu == GameResult.cpuWin
        ? state.cpuScore + 1
        : state.cpuScore;

    state = state.copyWith(
      board: BoardService.copyBoard(board),
      result: resultAfterCpu,
      cpuScore: newCpuScore,
      validMoves: newMoves,
      isCpuThinking: false,
      lastBarrierPosition: cpuMove,
    );

    if (resultAfterCpu == GameResult.cpuWin) {
      await _repo.saveCpuScore(newCpuScore);
    }
  }
}
