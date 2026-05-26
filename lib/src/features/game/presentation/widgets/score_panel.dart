import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/presentation/providers/game_provider.dart';

class ScorePanel extends ConsumerWidget {
  const ScorePanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Row(
              children: [
                const Icon(Icons.emoji_events, color: AppColors.accent, size: 16),
                const SizedBox(width: 6),
                const Text(
                  'PLACAR DE VITÓRIAS',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => ref.read(gameProvider.notifier).clearScores(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFEF4444).withValues(alpha: 0.35),
                      ),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.delete_outline_rounded,
                          color: Color(0xFFEF4444),
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Limpar',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            IntrinsicHeight(
              child: Row(
                children: [
                  Expanded(
                    child: _ScoreColumn(
                      label: 'GATO (VOCÊ)',
                      score: state.playerScore,
                    ),
                  ),
                  VerticalDivider(
                    color: AppColors.textMuted.withValues(alpha: 0.3),
                    width: 32,
                    thickness: 1,
                  ),
                  Expanded(
                    child: _ScoreColumn(
                      label: 'CPU (CERCA)',
                      score: state.cpuScore,
                      alignRight: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ScoreColumn extends StatelessWidget {
  const _ScoreColumn({
    required this.label,
    required this.score,
    this.alignRight = false,
  });

  final String label;
  final int score;
  final bool alignRight;

  @override
  Widget build(BuildContext context) {
    final align = alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: align,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          score.toString().padLeft(2, '0'),
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
