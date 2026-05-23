import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/providers/audio_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/game_result.dart';
import '../providers/game_provider.dart';
import '../view_models/game_state_view_model.dart';
import '../widgets/difficulty_selector.dart';
import '../widgets/game_board_widget.dart';
import '../widgets/game_header.dart';
import '../widgets/score_panel.dart';
import '../widgets/status_banner.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final audio = ref.watch(audioServiceProvider);

    ref.listen<bool>(isMutedProvider, (_, muted) => audio.setMuted(muted));

    ref.listen<GameStateViewModel>(gameProvider, (prev, next) {
      if (prev == null) return;
      if (prev.catPosition != next.catPosition) {
        audio.playCatJump();
      }
      if (prev.isCpuThinking &&
          !next.isCpuThinking &&
          next.result == GameResult.inProgress) {
        audio.playBarrierPlaced();
      }
      if (next.result == GameResult.playerWin &&
          prev.result != GameResult.playerWin) {
        audio.playWin();
      }
      if (next.result == GameResult.cpuWin &&
          prev.result != GameResult.cpuWin) {
        audio.playLose();
      }
      if (prev.result != GameResult.inProgress &&
          next.result == GameResult.inProgress) {
        audio.resumeBackground();
      }
    });

    ref.listen<GameResult>(gameProvider.select((s) => s.result), (prev, next) {
      if (next == GameResult.inProgress) return;
      _showResultDialog(context, ref, next);
    });

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GameHeader(),
              const ScorePanel(),
              const DifficultySelector(),
              const StatusBanner(),
              const GameBoardWidget(),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                child: Text(
                  'Toque em uma casa vazia para o gato pular. A CPU bloqueará uma saída em seguida.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: GestureDetector(
                  onTap: () => ref.read(gameProvider.notifier).newGame(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.refresh_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Novo Jogo',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResultDialog(
    BuildContext context,
    WidgetRef ref,
    GameResult result,
  ) {
    final isWin = result == GameResult.playerWin;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withValues(alpha: 0.75),
      builder: (ctx) => _ResultDialog(
        isWin: isWin,
        onNewGame: () {
          Navigator.pop(ctx);
          ref.read(gameProvider.notifier).newGame();
        },
      ),
    );
  }
}

class _ResultDialog extends StatelessWidget {
  const _ResultDialog({required this.isWin, required this.onNewGame});

  final bool isWin;
  final VoidCallback onNewGame;

  @override
  Widget build(BuildContext context) {
    final color = isWin ? AppColors.accent : AppColors.accentBlue;
    final icon = isWin
        ? Icons.auto_awesome_rounded
        : Icons.sentiment_very_dissatisfied_rounded;
    final title = isWin ? 'Você Escapou!' : 'Gato Cercado!';
    final subtitle = isWin
        ? 'O gato superou a cerca e alcançou a liberdade! 🎉'
        : 'A CPU bloqueou todas as vias de fuga. 🐱';
    final scoreLabel = isWin
        ? '+1 Vitória para o Gato'
        : '+1 Vitória para a CPU';
    final btnLabel = isWin ? 'Jogar Novamente' : 'Tentar Novamente';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.30),
              blurRadius: 48,
              spreadRadius: 2,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(color: color, icon: icon, title: title),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 26),
              child: Column(
                children: [
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13.5,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _ScoreBadge(label: scoreLabel),
                  const SizedBox(height: 14),
                  _ActionButton(
                    label: btnLabel,
                    color: color,
                    textColor: isWin ? Colors.black87 : Colors.white,
                    onTap: onNewGame,
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

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({
    required this.color,
    required this.icon,
    required this.title,
  });

  final Color color;
  final IconData icon;
  final String title;

  Widget _dot(double size, double opacity) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      color: color.withValues(alpha: opacity),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color.withValues(alpha: 0.22),
              color.withValues(alpha: 0.06),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: 18, left: 26, child: _dot(9, 0.25)),
            Positioned(top: 46, left: 52, child: _dot(5, 0.18)),
            Positioned(top: 22, right: 30, child: _dot(6, 0.20)),
            Positioned(top: 54, right: 58, child: _dot(10, 0.14)),
            Positioned(bottom: 24, left: 38, child: _dot(7, 0.18)),
            Positioned(bottom: 14, right: 26, child: _dot(5, 0.22)),

            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.07),
                        ),
                      ),
                      Container(
                        width: 78,
                        height: 78,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.13),
                        ),
                      ),
                      Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: color.withValues(alpha: 0.20),
                          border: Border.all(
                            color: color.withValues(alpha: 0.45),
                            width: 1.5,
                          ),
                        ),
                        child: Icon(icon, color: color, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.3,
                      ),
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

class _ScoreBadge extends StatelessWidget {
  const _ScoreBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.textMuted.withValues(alpha: 0.22)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            color: AppColors.accent,
            size: 16,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: textColor,
          padding: const EdgeInsets.symmetric(vertical: 15),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        icon: Icon(Icons.refresh_rounded, size: 18, color: textColor),
        label: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.3,
          ),
        ),
        onPressed: onTap,
      ),
    );
  }
}
