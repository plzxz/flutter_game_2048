import 'package:flutter/material.dart';
import 'package:flutter_game_2048/components/box.dart';
import 'package:flutter_game_2048/components/button.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:provider/provider.dart';

class TestPage extends StatelessWidget {
  const TestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();

    return Scaffold(
      appBar: AppBar(backgroundColor: gameTheme!.appBar),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          if(Provider.of<ThemeProvider>(context).selectTheme == 4)
          SnowFallAnimation(
            config: SnowfallConfig(
              numberOfSnowflakes: 200,
              speed: 1.0,
              useEmoji: true,
              customEmojis: ['❄️', '❅', '❆'],
            ),
          ),
          Center(
            child: MyBox(
              color: Theme.of(context).colorScheme.primary, 
              size: 400,
              child: MyBox(
                color: Theme.of(context).colorScheme.secondary,
                size: 200,
                child: MyButton(
                  color: Theme.of(context).colorScheme.tertiary,
                  onTap: () {
                    Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
                  }
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}