import 'package:flutter/material.dart';
import 'package:flutter_game_2048/pages/menu_page.dart';
import 'package:flutter_game_2048/pages/signup_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

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
    _checkLogin();
  }

  void _checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    final isLogin = prefs.getBool('isLogin') ?? false;
    print(isLogin);

    await Future.delayed(const Duration(seconds: 2));
    if(!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => isLogin ? const MenuPage() : SignUpPage(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('splash_logo.png', width: 300),
            SizedBox(height: 20),
            Text(
              '2048',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
