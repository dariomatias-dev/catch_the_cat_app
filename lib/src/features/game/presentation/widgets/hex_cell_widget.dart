import 'package:flutter/material.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/domain/entities/cell_state.dart';
import 'package:catch_the_cat/src/features/game/domain/entities/position.dart';

class HexCellWidget extends StatelessWidget {
  const HexCellWidget({
    super.key,
    required this.position,
    required this.cellState,
    required this.size,
    required this.isValidMove,
    required this.isLastBarrier,
    required this.onTap,
  });

  final Position position;
  final CellState cellState;
  final double size;
  final bool isValidMove;
  final bool isLastBarrier;
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
      child = _AnimatedCat(size: size);
    } else if (isBlocked) {
      bgColor = AppColors.cellBlocked;
    } else if (isValidMove) {
      bgColor = Colors.transparent;
      borderColor = AppColors.cellValidMove;
    } else {
      bgColor = AppColors.cellEmpty;
    }

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        GestureDetector(
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
            child: child != null ? Center(child: child) : null,
          ),
        ),
        if (isLastBarrier)
          Positioned.fill(
            child: IgnorePointer(
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.65, end: 0.0),
                duration: const Duration(milliseconds: 600),
                builder: (_, v, _) => Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: v),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _AnimatedCat extends StatefulWidget {
  const _AnimatedCat({required this.size});
  final double size;

  @override
  State<_AnimatedCat> createState() => _AnimatedCatState();
}

class _AnimatedCatState extends State<_AnimatedCat>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.82, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scale,
      builder: (_, _) => Transform.scale(
        scale: _scale.value,
        child: Text(
          '🐱',
          style: TextStyle(fontSize: widget.size * 0.68, height: 1),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
