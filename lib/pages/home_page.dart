import 'package:flutter/material.dart';
import 'package:flutter_game_2048/components/box.dart';
import 'package:flutter_game_2048/components/button.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
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
    );
  }
}