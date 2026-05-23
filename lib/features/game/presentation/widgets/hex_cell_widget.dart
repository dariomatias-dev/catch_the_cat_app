import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/cell_state.dart';
import '../../domain/entities/position.dart';

class HexCellWidget extends StatelessWidget {
  const HexCellWidget({
    super.key,
    required this.position,
    required this.cellState,
    required this.size,
    required this.isValidMove,
    required this.onTap,
  });

  final Position position;
  final CellState cellState;
  final double size;
  final bool isValidMove;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isCat = cellState == CellState.cat;
    final isBlocked = cellState == CellState.blocked;

    Color bgColor;
    Color? borderColor;
    Widget? child;

    if (isCat) {
      bgColor = AppColors.cellCat;
      child = _CatFace(size: size);
    } else if (isBlocked) {
      bgColor = AppColors.cellBlocked;
    } else if (isValidMove) {
      bgColor = Colors.transparent;
      borderColor = AppColors.cellValidMove;
    } else {
      bgColor = AppColors.cellEmpty;
    }

    return GestureDetector(
      onTap: isValidMove ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: bgColor,
          border: borderColor != null
              ? Border.all(color: borderColor, width: 2.5)
              : null,
        ),
        child: child,
      ),
    );
  }
}

class _CatFace extends StatelessWidget {
  const _CatFace({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final eyeSize = size * 0.14;
    return Stack(
      alignment: Alignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(-size * 0.08, -size * 0.04),
              child: Container(
                width: eyeSize,
                height: eyeSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3D2B00),
                ),
              ),
            ),
            Transform.translate(
              offset: Offset(size * 0.08, -size * 0.04),
              child: Container(
                width: eyeSize,
                height: eyeSize,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF3D2B00),
                ),
              ),
            ),
          ],
        ),
        Transform.translate(
          offset: Offset(0, size * 0.1),
          child: Container(
            width: eyeSize * 0.6,
            height: eyeSize * 0.6,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFC47A00),
            ),
          ),
        ),
      ],
    );
  }
}
