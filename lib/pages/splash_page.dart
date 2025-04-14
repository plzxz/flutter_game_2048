import 'package:flutter/material.dart';
import 'package:flutter_game_2048/pages/game_page.dart';
import 'dart:async';
import 'package:flutter_game_2048/pages/home_page.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    // final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    // themeProvider.loadTheme();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => GamePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Text(
          'This This a Test Massage',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      )
    );
  }
}
