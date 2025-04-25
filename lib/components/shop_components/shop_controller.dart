import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shop_item.dart';
import 'shop_theme.dart';

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
      name: "Blue",
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
}
