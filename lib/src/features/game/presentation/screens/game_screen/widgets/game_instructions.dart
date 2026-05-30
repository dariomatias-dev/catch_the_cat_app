import 'package:flutter/material.dart';

import 'package:catch_the_cat/src/core/theme/app_colors.dart';

class GameInstructions extends StatelessWidget {
  const GameInstructions({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
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
    );
  }
}
