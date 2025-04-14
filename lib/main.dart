import 'package:flutter/material.dart';
import 'package:flutter_game_2048/pages/splash_page.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  final themeProvider = ThemeProvider();
  themeProvider.loadTheme();
  runApp(
    ChangeNotifierProvider.value(
      value: themeProvider,
      child: const MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}