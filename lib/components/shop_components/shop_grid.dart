import 'package:flutter/material.dart';
import 'shop_item.dart';
import 'shop_theme.dart';

class ShopGrid extends StatelessWidget {
  final int selectedTab;
  final List<ShopItem> items;
  final List<ShopThemeModel> themes;
  final int selectedItemIndex;
  final int selectedThemeIndex;
  final Function(int) onItemSelected;

  final Color activeColor;
  final Color inactiveColor;

  const ShopGrid({
    super.key,
    required this.selectedTab,
    required this.items,
    required this.themes,
    required this.selectedItemIndex,
    required this.selectedThemeIndex,
    required this.onItemSelected,
    required this.activeColor,
    required this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    final isItemTab = selectedTab == 0;
    final data = isItemTab ? items : themes;

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1.4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: data.length,
      itemBuilder: (context, index) {
      final selected = isItemTab ? selectedItemIndex : selectedThemeIndex;
      final bgColor = selected == index ? inactiveColor : activeColor;

      return GestureDetector(
        onTap: () => onItemSelected(index),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (isItemTab) ...[
                Icon(items[index].icon, size: 24),
                Text(items[index].name, style: const TextStyle(fontSize: 12)),
                Text("points: ${items[index].points}", style: const TextStyle(fontSize: 11)),
              ] else ...[
                Text(themes[index].name, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(themes[index].name, style: const TextStyle(fontSize: 12)),
                Text("points: ${themes[index].points}", style: const TextStyle(fontSize: 11)),
              ]
            ],
          ),
        ),
      );
    }
    );
  }
}
