import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/domain/entities/difficulty.dart';
import 'package:catch_the_cat/src/features/game/presentation/providers/game_provider.dart';

class DifficultySelector extends ConsumerWidget {
  const DifficultySelector({super.key});

  static Color _colorFor(Difficulty d) => switch (d) {
    Difficulty.easy => const Color(0xFF34D399),
    Difficulty.medium => AppColors.accent,
    Difficulty.hard => const Color(0xFFEF4444),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(gameProvider.select((s) => s.difficulty));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              current.description,
              key: ValueKey(current),
              style: TextStyle(
                color: _colorFor(current).withValues(alpha: 0.85),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: Difficulty.values.map((d) {
              final selected = d == current;
              final color = _colorFor(d);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 3),
                  child: GestureDetector(
                    onTap: () =>
                        ref.read(gameProvider.notifier).setDifficulty(d),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      height: 38,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selected
                            ? color.withValues(alpha: 0.15)
                            : AppColors.surfaceCard,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: selected
                              ? color.withValues(alpha: 0.8)
                              : AppColors.textMuted.withValues(alpha: 0.22),
                          width: selected ? 1.5 : 1,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            width: 7,
                            height: 7,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: selected
                                  ? color
                                  : AppColors.textMuted.withValues(alpha: 0.45),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            d.label,
                            style: TextStyle(
                              color: selected ? color : AppColors.textMuted,
                              fontSize: 12,
                              fontWeight: selected
                                  ? FontWeight.w700
                                  : FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
