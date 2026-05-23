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
import '../widgets/result_overlay.dart';
import '../widgets/score_panel.dart';
import '../widgets/status_banner.dart';

class GameScreen extends ConsumerWidget {
  const GameScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Init audio service on first build
    final audio = ref.watch(audioServiceProvider);

    ref.listen<bool>(isMutedProvider, (_, muted) => audio.setMuted(muted));

    ref.listen<GameStateViewModel>(gameProvider, (prev, next) {
      if (prev == null) return;
      if (prev.catPosition != next.catPosition) { audio.playCatJump(); }
      if (prev.isCpuThinking && !next.isCpuThinking &&
          next.result == GameResult.inProgress) {
        audio.playBarrierPlaced();
      }
      if (next.result == GameResult.playerWin &&
          prev.result != GameResult.playerWin) { audio.playWin(); }
      if (next.result == GameResult.cpuWin &&
          prev.result != GameResult.cpuWin) { audio.playLose(); }
      if (prev.result != GameResult.inProgress &&
          next.result == GameResult.inProgress) { audio.resumeBackground(); }
    });

    final result = ref.watch(gameProvider.select((s) => s.result));
    final gameOver = result != GameResult.inProgress;

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
              if (!gameOver) ...[
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
              ] else
                const ResultOverlay(),
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
                        Icon(Icons.refresh_rounded, color: Colors.white, size: 18),
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
}
