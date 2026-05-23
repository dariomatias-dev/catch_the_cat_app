import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/difficulty.dart';
import '../providers/game_provider.dart';

class DifficultySelector extends ConsumerWidget {
  const DifficultySelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(gameProvider.select((s) => s.difficulty));

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          const Text(
            'Dificuldade:',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Row(
              children: Difficulty.values.map((d) {
                final selected = d == current;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: GestureDetector(
                      onTap: () =>
                          ref.read(gameProvider.notifier).setDifficulty(d),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        height: 32,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selected
                              ? AppColors.accent
                              : AppColors.surfaceCard,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: selected
                                ? AppColors.accent
                                : AppColors.textMuted.withValues(alpha: 0.4),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          d.label,
                          style: TextStyle(
                            color: selected
                                ? Colors.black87
                                : AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
