import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/domain/entities/game_result.dart';
import 'package:catch_the_cat/src/features/game/presentation/providers/game_provider.dart';

class StatusBanner extends ConsumerWidget {
  const StatusBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameProvider);
    final inProgress = state.result == GameResult.inProgress;

    final text = switch (state.result) {
      GameResult.inProgress =>
        state.isCpuThinking ? 'CPU pensando...' : 'Gato ativo! Salve o Gato saltando até a borda.',
      GameResult.playerWin || GameResult.cpuWin => 'Partida concluída!',
    };

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: inProgress
              ? AppColors.accent.withValues(alpha: 0.10)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: inProgress
              ? Border.all(color: AppColors.accent.withValues(alpha: 0.7), width: 1.5)
              : Border.all(
                  color: AppColors.textMuted.withValues(alpha: 0.3),
                  width: 1,
                ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: inProgress ? AppColors.accent : AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
