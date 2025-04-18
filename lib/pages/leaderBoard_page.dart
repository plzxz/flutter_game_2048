import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderBoardPage extends StatefulWidget {
  const LeaderBoardPage({super.key});

  @override
  State<LeaderBoardPage> createState() => LeaderBoardPageState();
}

class LeaderBoardPageState extends State<LeaderBoardPage> {
  List<Map<String, dynamic>> leaderBoardData = [];

  @override
  void initState() {
    super.initState();
    loadLeaderboardData();
  }

  void loadLeaderboardData() async {
    try {
      final response = await http.get(Uri.parse('https://2048-api.vercel.app/leaderboard'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);

        setState(() {
          leaderBoardData = data
              .map<Map<String, dynamic>>((entry) => {
                    "username": entry["username"],
                    "score": entry["score"],
                  })
              .toList();
        });
      } else {
        throw Exception("Failed to load leaderboard: ${response.statusCode}");
      }
    } catch (e) {
      print("Error loading leaderboard: $e");
    }
  }

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
            child: Column(
              children: [
                const SizedBox(height: 40),
                Container(
                  height: 80,
                  width: 300,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: const Text(
                      'Leader Board',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 80),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: gameTheme.lightText,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Table(
                    border: TableBorder(
                      horizontalInside: BorderSide(width: 2, color: Colors.black),
                      verticalInside: BorderSide(width: 2, color: Colors.black),
                    ),
                    columnWidths: const {
                      0: FlexColumnWidth(1),
                      1: FlexColumnWidth(1),
                    },
                    children: [
                      TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Center(
                              child: Text(
                                'Player',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: gameTheme.darkText
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 4,
                            ),
                            child: Center(
                              child: Text(
                                'Score',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: gameTheme.darkText
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      ...leaderBoardData.map(
                        (entry) => TableRow(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 4,
                              ),
                              child: Center(
                                child: Text(
                                  entry['username'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: gameTheme.darkText
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 4,
                              ),
                              child: Center(
                                child: Text(
                                  entry['score'].toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                    color: gameTheme.darkText
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
