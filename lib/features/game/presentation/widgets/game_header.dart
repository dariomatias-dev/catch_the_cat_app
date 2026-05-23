import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:catch_the_cat/core/providers/audio_provider.dart';
import 'package:catch_the_cat/core/theme/app_colors.dart';

class GameHeader extends ConsumerWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bool muted = ref.watch(isMutedProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 12.0),
      child: Row(
        children: <Widget>[
          Container(
            width: 48.0,
            height: 48.0,
            decoration: BoxDecoration(
              color: AppColors.accentBlue.withAlpha(48),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: const Icon(
              Icons.pets_rounded,
              color: AppColors.accentBlue,
              size: 24.0,
            ),
          ),
          const SizedBox(width: 12.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'Pegue o Gato',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'FUGA ARCADE',
                  style: TextStyle(
                    color: AppColors.textSecondary.withAlpha(150),
                    fontSize: 11.0,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
          _HeaderActionBtn(
            onTap: () {
              ref.read(isMutedProvider.notifier).state = !muted;
            },
            icon: muted ? Icons.volume_off_rounded : Icons.volume_up_rounded,
            backgroundColor: AppColors.accentBlue.withAlpha(48),
            iconColor: AppColors.accentBlue,
          ),
          const SizedBox(width: 12.0),
          _HeaderActionBtn(
            onTap: () => _showHelp(context),
            icon: Icons.help_outline_rounded,
            backgroundColor: AppColors.surfaceCard.withAlpha(255),
            iconColor: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.surfaceCard,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: AppColors.accentPurple.withAlpha(40)),
          ),
          title: const Text(
            'Como jogar',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: const Text(
            'Você é o gato 🐱. Toque em uma casa adjacente vazia para mover.\n\nChegue à borda do tabuleiro para escapar!\n\nA CPU bloqueará uma casa após cada jogada sua.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15.0,
              height: 1.5,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'ENTENDI',
                style: TextStyle(
                  color: AppColors.accent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HeaderActionBtn extends StatelessWidget {
  final VoidCallback onTap;
  final IconData icon;
  final Color backgroundColor;
  final Color iconColor;

  const _HeaderActionBtn({
    required this.onTap,
    required this.icon,
    required this.backgroundColor,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.0),
        child: Container(
          width: 44.0,
          height: 44.0,
          alignment: Alignment.center,
          child: Icon(icon, color: iconColor, size: 20.0),
        ),
      ),
    );
  }
}
