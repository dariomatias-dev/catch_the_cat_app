import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/game_result.dart';
import '../providers/game_provider.dart';

class ResultOverlay extends ConsumerWidget {
  const ResultOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final result = ref.watch(gameProvider.select((s) => s.result));
    final isWin = result == GameResult.playerWin;

    final iconColor = isWin ? AppColors.accent : AppColors.accentBlue;
    final icon = isWin ? Icons.auto_awesome : Icons.warning_amber_rounded;
    final title = isWin ? 'Você Escapou!' : 'Gato Cercado!';
    final description = isWin
        ? 'Incrível! O Gato superou a cerca do adversário e conseguiu alcançar a liberdade. 🎉'
        : 'Você perdeu! A CPU bloqueou todas as suas vias de fuga possíveis. 🐱';
    final scoreLabel = isWin ? '+1 Vitória para o Gato' : '+1 Vitória para a CPU';
    final actionLabel = isWin ? 'Jogar Novamente' : 'Tentar Novamente';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: iconColor.withValues(alpha: 0.15),
              ),
              child: Icon(icon, color: iconColor, size: 40),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: TextStyle(
                color: iconColor,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            _OutlinedBtn(label: scoreLabel),
            const SizedBox(height: 12),
            _FilledBtn(
              label: actionLabel,
              color: iconColor,
              onTap: () => ref.read(gameProvider.notifier).newGame(),
            ),
          ],
        ),
      ),
    );
  }
}

class _OutlinedBtn extends StatelessWidget {
  const _OutlinedBtn({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.textMuted.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.emoji_events, color: AppColors.accent, size: 16),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilledBtn extends StatelessWidget {
  const _FilledBtn({
    required this.label,
    required this.color,
    required this.onTap,
  });

  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.refresh_rounded, color: Colors.black87, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
