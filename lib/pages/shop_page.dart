import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

import 'package:flutter_game_2048/components/shop_components/shop_controller.dart';
import 'package:flutter_game_2048/components/shop_components/shop_tabs.dart';
import 'package:flutter_game_2048/components/shop_components/shop_grid.dart';
import 'package:flutter_game_2048/components/shop_components/shop_detail.dart';
import 'package:flutter_game_2048/components/shop_components/shop_buy_button.dart';


class ShopPage extends StatelessWidget {
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ShopController()..loadData(),
      child: const ShopPageContent(),
    );
  }
}

class ShopPageContent extends StatelessWidget {
  const ShopPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>()!;// ดึงธีมเกม
    final controller = Provider.of<ShopController>(context);// เข้าถึง controller
    final themeProvider = Provider.of<ThemeProvider>(context);// เข้าถึง theme provider

  // ดูว่าอยู่แท็บไอเท็มไหม
    final isItemTab = controller.selectedTab == 0;
    final currentItem = controller.items[controller.selectedItemIndex];
    final currentTheme = controller.themes[controller.selectedThemeIndex];
    final points = controller.points;

    return Scaffold(
      appBar: AppBar(backgroundColor: gameTheme.appBar),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          if (themeProvider.selectTheme == 4)
            SnowFallAnimation(
              config: SnowfallConfig(
                numberOfSnowflakes: 200,
                speed: 1.0,
                useEmoji: true,
                customEmojis: ['❄️', '❅', '❆'],
              ),
            ),
          Column(
            children: [
              const SizedBox(height: 30),
              Container(
                height: 80,
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'Shop',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(height: 45),

              // ปุ่มเลือกแท็บ (ไอเท็ม / ธีม)
              ShopTabs(
                // แท็บปัจจุบัน
                selectedTab: controller.selectedTab,
                // ฟังก์ชันเปลี่ยนแท็บ
                onTabSelected: controller.selectTab,
                activeColor: gameTheme.activeButton,
                inactiveColor: gameTheme.inactiveButton,
                textColor: gameTheme.lightText,
              ),

              const SizedBox(height: 15),
              Row(
                children: [
                  const SizedBox(width: 50),
                  Text("points: $points"),// โชว์คะแนนผู้เล่น
                ],
              ),
              const SizedBox(height: 10),

              Expanded(
                child: Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: gameTheme.lightText,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ShopGrid( // แสดงกริด
                          selectedTab: controller.selectedTab,
                          items: controller.items,
                          themes: controller.themes,
                          selectedItemIndex: controller.selectedItemIndex,
                          selectedThemeIndex: controller.selectedThemeIndex,
                          onItemSelected: (index) {
                            if (controller.selectedTab == 0) {
                              controller.selectItem(index);
                            } else {
                              controller.selectTheme(index);
                            }
                          },
                          activeColor: gameTheme.activeButton,
                          inactiveColor: gameTheme.inactiveButton,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    SizedBox(
                      height: 250,
                      child: Container(// กล่องแสดงรายละเอียด
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: gameTheme.lightText,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ShopDetailPanel(// รายละเอียดของรายการที่เลือก
                          selectedTab: controller.selectedTab,
                          item: currentItem,
                          theme: currentTheme,
                          ownedItemCount: controller.getItemCount(currentItem.name),
                          textColor: gameTheme.darkText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShopBuyButton(// ปุ่มซื้อ/ติดตั้ง
                          label: isItemTab
                              ? "Buy"
                              : currentTheme.owned
                                  ? "Equip"
                                  : "Buy",
                          onPressed: () async {
                            if (isItemTab) {
                              await controller.buyItem(controller.selectedItemIndex);
                            } else {
                              if (currentTheme.owned) {
                                themeProvider.changeTheme(currentTheme.id);
                                _showSnackbar(context, "${currentTheme.name} theme equipped!");
                              } else {
                                await controller.buyTheme(controller.selectedThemeIndex);
                                _showSnackbar(context, "${currentTheme.name} theme purchased!");
                              }
                            }
                          },
                          buttonColor: gameTheme.actionButton,
                          textColor: gameTheme.lightText,
                        ),
                        const SizedBox(width: 50),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  // ฟังก์ชันแสดงข้อความชั่วคราวด้านล่าง
  void _showSnackbar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), duration: const Duration(seconds: 1)),
    );
  }
}