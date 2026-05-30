import 'package:flutter/material.dart';

import 'package:catch_the_cat/src/core/theme/app_theme.dart';

import 'package:catch_the_cat/src/features/game/presentation/screens/game_screen/game_screen.dart';

class CatchTheCatApp extends StatelessWidget {
  const CatchTheCatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catch the Cat',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.dark,
      home: const GameScreen(),
    );
  }
}
