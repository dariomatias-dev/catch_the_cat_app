import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/domain/entities/position.dart';
import 'package:catch_the_cat/src/features/game/domain/services/board_service.dart';
import 'package:catch_the_cat/src/features/game/presentation/providers/game_provider.dart';
import 'package:catch_the_cat/src/features/game/presentation/widgets/hex_cell_widget.dart';

class GameBoardWidget extends ConsumerWidget {
  const GameBoardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final validSet = state.validMoves.toSet();

    final screenWidth = MediaQuery.of(context).size.width;
    const outerPadding = 16.0;
    const boardPadding = 10.0;
    final availableW = screenWidth - outerPadding * 2 - boardPadding * 2;

    final hSpacing = availableW / 11.5;
    final cellDiam = hSpacing * 0.92;
    final vSpacing = hSpacing * 0.866;
    final boardW = 10.5 * hSpacing + cellDiam;
    final boardH = 10 * vSpacing + cellDiam;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: outerPadding, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(boardPadding),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: boardW,
          height: boardH,
          child: Stack(
            children: [
              for (int row = 0; row < kBoardSize; row++)
                for (int col = 0; col < kBoardSize; col++)
                  _buildCell(
                    ref: ref,
                    row: row,
                    col: col,
                    state: state,
                    validSet: validSet,
                    hSpacing: hSpacing,
                    vSpacing: vSpacing,
                    cellDiam: cellDiam,
                  ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCell({
    required WidgetRef ref,
    required int row,
    required int col,
    required dynamic state,
    required Set<Position> validSet,
    required double hSpacing,
    required double vSpacing,
    required double cellDiam,
  }) {
    final pos = Position(row, col);
    final left = col * hSpacing + (row.isOdd ? hSpacing / 2 : 0);
    final top = row * vSpacing;
    final cellState = state.board[row][col];
    final isValid = validSet.contains(pos);
    final isLastBarrier = pos == state.lastBarrierPosition;

    return Positioned(
      left: left,
      top: top,
      child: HexCellWidget(
        position: pos,
        cellState: cellState,
        size: cellDiam,
        isValidMove: isValid,
        isLastBarrier: isLastBarrier,
        onTap: () => ref.read(gameProvider.notifier).onCellTap(pos),
      ),
    );
  }
}
