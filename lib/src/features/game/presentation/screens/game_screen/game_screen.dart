import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/src/core/providers/audio_provider.dart';
import 'package:catch_the_cat/src/core/theme/app_colors.dart';

import 'package:catch_the_cat/src/features/game/domain/entities/game_result.dart';
import 'package:catch_the_cat/src/features/game/presentation/providers/game_provider.dart';
import 'package:catch_the_cat/src/features/game/presentation/view_models/game_state_view_model.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/difficulty_selector.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/game_board_widget.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/game_header.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/game_instructions.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/new_game_button.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/result_dialog.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/score_panel.dart';
import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/widgets/status_banner.dart';

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
            children: const <Widget>[
              GameHeader(),
              ScorePanel(),
              SizedBox(height: 8.0),
              DifficultySelector(),
              SizedBox(height: 8.0),
              StatusBanner(),
              SizedBox(height: 8.0),
              GameBoardWidget(),
              GameInstructions(),
              SizedBox(height: 12),
              NewGameButton(),
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
      builder: (ctx) => ResultDialog(
        isWin: isWin,
        onNewGame: () {
          Navigator.pop(ctx);
          ref.read(gameProvider.notifier).newGame();
        },
      ),
    );
  }
}
