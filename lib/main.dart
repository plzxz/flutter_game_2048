import 'package:flutter/material.dart';
import 'package:flutter_game_2048/pages/credit.dart';
import 'package:flutter_game_2048/pages/game_page_proto.dart';
import 'package:flutter_game_2048/pages/leaderBoard_page.dart';
import 'package:flutter_game_2048/pages/shop_page.dart';
import 'package:flutter_game_2048/pages/splash_page.dart';
import 'package:flutter_game_2048/pages/test_page.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeProvider = ThemeProvider();
  await themeProvider.loadTheme();
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
      home:  SplashPage(),
      routes: {
        '/gamePage': (context) => const GamePage(),
        '/boardPage': (context) => const LeaderBoardPage(),
        '/shopPage': (context) => const ShopPage(),
        '/testPage': (context) => const TestPage(),
        '/creditPage': (context) => const Credit(),
      },
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}