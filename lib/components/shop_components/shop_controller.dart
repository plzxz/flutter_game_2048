import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shop_item.dart';
import 'shop_theme.dart';
import 'package:http/http.dart' as http;

class ShopController extends ChangeNotifier {
  int points = 0;
  int selectedTab = 0;
  int selectedItemIndex = 0;
  int selectedThemeIndex = 0;

  int itemSwap = 0;
  int itemUndo = 0;
  int itemDelete = 0;

  List<ShopItem> items = [
    ShopItem(
      name: "undo",
      icon: Icons.fast_rewind,
      description: "Rewind your last move. No rewind for heartbreaks, bro.",
      points: 30,
    ),
    ShopItem(
      name: "swap",
      icon: Icons.loop,
      description: "Swap numbers. Big brain time.",
      points: 50,
    ),
    ShopItem(
      name: "delete",
      icon: Icons.delete_forever,
      description: "Delete a number. Chaos reigns.",
      points: 100,
    ),
    ShopItem(
      name: "rebirth",
      icon: Icons.refresh,
      description: "Trade your score for points and start fresh. No cost. One-time use.",
      points: 0,
    ),
  ];

  List<ShopThemeModel> themes = [
    ShopThemeModel(
      name: "Normal",
      smallImage: Colors.brown.shade200,
      image: 'assets/images/normal.png',
      id: 0,
      points: 0,
      owned: true,
    ),
    ShopThemeModel(
      name: "Light",
      smallImage: Colors.white,
      image: 'assets/images/light.png',
      id: 1,
      points: 50,
    ),
    ShopThemeModel(
      name: "Dark",
      smallImage: Colors.black,
      image: 'assets/images/dark.png',
      id: 2,
      points: 500,
    ),
    ShopThemeModel(
      name: "Ice",
      smallImage: Colors.blue,
      image: 'assets/images/blue.png',
      id: 3,
      points: 100,
    ),
    ShopThemeModel(
      name: "Crismas",
      smallImage: Colors.green,
      image: 'assets/images/crismas.png',
      id: 4,
      points: 30,
    ),
  ];

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    points = prefs.getInt('points') ?? 0;
    itemSwap = prefs.getInt("item_swap") ?? 0;
    itemUndo = prefs.getInt("item_undo") ?? 0;
    itemDelete = prefs.getInt("item_delete") ?? 0;

    final ownedThemes = prefs.getStringList("owned_themes") ?? [];
    for (var theme in themes) {
      theme.owned = ownedThemes.contains(theme.name);
    }

    notifyListeners();
  }

  int getItemCount(String name) {
    switch (name) {
      case "swap": return itemSwap;
      case "undo": return itemUndo;
      case "delete": return itemDelete;
      default: return 0;
    }
  }

  Future<void> buyItem(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final item = items[index];

    if (item.name == "rebirth") {
      await _useRebirth(prefs);
      return;
    }

    if (points < item.points) return;

    int count = getItemCount(item.name);
    int max = {"swap": 4, "undo": 8, "delete": 2}[item.name]!;

    if (count >= max) return;

    count++;
    switch (item.name) {
      case "swap": itemSwap = count; break;
      case "undo": itemUndo = count; break;
      case "delete": itemDelete = count; break;
    }

    await prefs.setInt("item_${item.name}", count);
    points -= item.points;
    await prefs.setInt("points", points);
    notifyListeners();
  }

  Future<void> buyTheme(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final theme = themes[index];
    if (theme.owned || points < theme.points) return;

    theme.owned = true;
    final owned = prefs.getStringList("owned_themes") ?? [];
    owned.add(theme.name);
    await prefs.setStringList("owned_themes", owned);

    points -= theme.points;
    await prefs.setInt("points", points);
    notifyListeners();
  }

  Future<void> _useRebirth(SharedPreferences prefs) async {
    final username = prefs.getString("username");

    if (username == null) {
      throw Exception("Username not found in SharedPreferences");
    }

    //Get score from server
    final int score = await fetchScore(username);
    //Add to local points
    points += score;
    await prefs.setInt("points", points);

    //Reset server score
    await resetScore(username);

    notifyListeners();
  }

  void selectTab(int tab) {
    selectedTab = tab;
    notifyListeners();
  }

  void selectItem(int index) {
    selectedItemIndex = index;
    notifyListeners();
  }

  void selectTheme(int index) {
    selectedThemeIndex = index;
    notifyListeners();
  }

  Future<int> fetchScore(String username) async {
    final response = await http.get(Uri.parse('https://2048-api.vercel.app/score/$username'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['score'] ?? 0;
    } else {
      throw Exception('Failed to fetch score: ${response.statusCode}');
    }
  }

  Future<void> resetScore(String username) async {
    final response = await http.post(
      Uri.parse('https://2048-api.vercel.app/reset-score'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to reset score: ${response.statusCode}');
    }
  }
}
