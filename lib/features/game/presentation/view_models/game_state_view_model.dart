import '../../domain/entities/cell_state.dart';
import '../../domain/entities/difficulty.dart';
import '../../domain/entities/game_result.dart';
import '../../domain/entities/position.dart';

const _kKeep = Object();

class GameStateViewModel {
  const GameStateViewModel({
    required this.board,
    required this.catPosition,
    required this.result,
    required this.playerScore,
    required this.cpuScore,
    required this.difficulty,
    required this.validMoves,
    required this.isCpuThinking,
    this.lastBarrierPosition,
  });

  final List<List<CellState>> board;
  final Position catPosition;
  final GameResult result;
  final int playerScore;
  final int cpuScore;
  final Difficulty difficulty;
  final List<Position> validMoves;
  final bool isCpuThinking;
  final Position? lastBarrierPosition;

  GameStateViewModel copyWith({
    List<List<CellState>>? board,
    Position? catPosition,
    GameResult? result,
    int? playerScore,
    int? cpuScore,
    Difficulty? difficulty,
    List<Position>? validMoves,
    bool? isCpuThinking,
    Object? lastBarrierPosition = _kKeep,
  }) =>
      GameStateViewModel(
        board: board ?? this.board,
        catPosition: catPosition ?? this.catPosition,
        result: result ?? this.result,
        playerScore: playerScore ?? this.playerScore,
        cpuScore: cpuScore ?? this.cpuScore,
        difficulty: difficulty ?? this.difficulty,
        validMoves: validMoves ?? this.validMoves,
        isCpuThinking: isCpuThinking ?? this.isCpuThinking,
        lastBarrierPosition: identical(lastBarrierPosition, _kKeep)
            ? this.lastBarrierPosition
            : lastBarrierPosition as Position?,
      );
}
