import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class GameHeader extends StatelessWidget {
  const GameHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceCard,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Center(
              child: Text('🐱', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Pegue o Gato',
                  style: TextStyle(
                    color: AppColors.accentBlue,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                Text(
                  'FUGA ARCADE',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.5,
                  ),
                ),
              ],
            ),
          ),
          _IconBtn(
            icon: Icons.volume_up_rounded,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _IconBtn(
            icon: Icons.help_outline_rounded,
            isCircle: true,
            onTap: () => _showHelp(context),
          ),
        ],
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surfaceCard,
        title: const Text(
          'Como jogar',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'Você é o gato 🐱. Toque em uma casa adjacente vazia para mover.\n\n'
          'Chegue à borda do tabuleiro para escapar!\n\n'
          'A CPU bloqueará uma casa após cada jogada sua.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'OK',
              style: TextStyle(color: AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    this.isCircle = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppColors.surfaceCard,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(8),
        ),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }
}
