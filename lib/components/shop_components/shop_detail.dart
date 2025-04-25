import 'package:flutter/material.dart';
import 'shop_item.dart';
import 'shop_theme.dart';

class ShopDetailPanel extends StatelessWidget {
  final int selectedTab;
  final ShopItem item;
  final ShopThemeModel theme;
  final int ownedItemCount;
  final Color textColor;

  const ShopDetailPanel({
    super.key,
    required this.selectedTab,
    required this.item,
    required this.theme,
    required this.ownedItemCount,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return selectedTab == 0
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(item.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(width: 10),
                  Text("owned: $ownedItemCount",
                      style: TextStyle(fontSize: 12, color: textColor)),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Text(item.description,
                    overflow: TextOverflow.fade, style: TextStyle(color: textColor)),
              ),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(theme.name,
                      style: TextStyle(fontWeight: FontWeight.bold, color: textColor)),
                  const SizedBox(width: 10),
                  if (theme.owned)
                    Text("Owned", style: TextStyle(color: textColor)),
                ],
              ),
              const SizedBox(height: 4),
              Expanded(
                child: Image.asset(theme.image),
              ),
            ],
          );
  }
}
