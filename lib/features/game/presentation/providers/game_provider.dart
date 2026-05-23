import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/cell_state.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/position.dart';
import '../../domain/services/board_service.dart';
import '../../domain/services/cpu_ai_service.dart';
import '../view_models/game_state_view_model.dart';

final gameProvider = NotifierProvider<GameNotifier, GameStateViewModel>(GameNotifier.new);

class GameNotifier extends Notifier<GameStateViewModel> {
  final _rng = Random();
  int _generation = 0;

  @override
  GameStateViewModel build() => _newGameState(
        difficulty: Difficulty.medium,
        playerScore: 0,
        cpuScore: 0,
      );

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
      state = state.copyWith(
        board: BoardService.copyBoard(board),
        catPosition: position,
        result: GameResult.playerWin,
        playerScore: state.playerScore + 1,
        validMoves: const [],
        isCpuThinking: false,
      );
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
    final cpuMove = CpuAiService.getMove(state.catPosition, board, state.difficulty);
    if (cpuMove != null) {
      board[cpuMove.row][cpuMove.col] = CellState.blocked;
    }

    final resultAfterCpu = BoardService.checkResult(state.catPosition, board);
    final newMoves = resultAfterCpu == GameResult.inProgress
        ? BoardService.validMoves(state.catPosition, board)
        : const <Position>[];

    state = state.copyWith(
      board: BoardService.copyBoard(board),
      result: resultAfterCpu,
      cpuScore: resultAfterCpu == GameResult.cpuWin ? state.cpuScore + 1 : state.cpuScore,
      validMoves: newMoves,
      isCpuThinking: false,
      lastBarrierPosition: cpuMove,
    );
  }
}
