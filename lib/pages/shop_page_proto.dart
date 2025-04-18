import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:provider/provider.dart';

class ShopPage extends StatefulWidget {
  const ShopPage({super.key});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  int selectedTab = 0; // 0 = Item, 1 = Theme
  int selectedItemIndex = 0;
  int selectedThemeIndex = 0;

  int points = 0;

  int item_swap = 0;
  int item_undo = 0;
  int item_delete = 0;


  Future<Map<String, int>> loadItemQuantities() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "swap": prefs.getInt("item_swap") ?? 0,
      "undo": prefs.getInt("item_undo") ?? 0,
      "delete": prefs.getInt("item_delete") ?? 0,
    };
  }

  Future<void> saveItemQuantity(String name, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("item_$name", value);
  }

  final List<Map<String, dynamic>> items = [
    {
      "name": "undo",
      "icon": Icons.fast_rewind,
      "description":
          "This item’s got the power to rewind and fix your past mistakes, giving you a second shot at glory. \n\n🌀 But hey... it ain’t strong enough to fix her heart, bro. Can’t patch love with code—only your gameplay. 💔🎮 Keep grinding!",
      "points": 30,
    },
    {
      "name": "swap",
      "icon": Icons.loop,
      "description":
          "This item lets you swap number slots with each other, makin’ it way easier to rack up those points. Big brain plays unlocked.\n\n💡🔥 Use it right, and you’ll be scoring like a legend in no time!.",
      "points": 50,
    },
    {
      "name": "delete",
      "icon": Icons.delete_forever,
      "description":
          "This item lets you delete any number you choose, and boom—they’re all gone in a flash. \n\n💥💨 No trace left, just clean digits and clean plays. Use it wisely, bro… this one’s pure chaos control! 🧠🧹",
      "points": 100,
    },
  ];

  Future<void> saveOwnedThemes(List<String> owned) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList("owned_themes", owned);
  }

  Future<List<String>> loadOwnedThemes() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList("owned_themes") ?? [];
  }

  final List<Map<String, dynamic>> themes = [
    {
      "name": "Normal",
      "small_image": Colors.brown.shade200,
      "image": 'normal.png',
      "id": 0,
      "points": 0,
      "owned": true,
    },
    {
      "name": "Light",
      "small_image": Colors.white,
      "image": 'light.png',
      "id": 1,
      "points": 50,
      "owned": false,
    },
    {
      "name": "Dark",
      "small_image": Colors.black,
      "image": 'dark.png',
      "id": 2,
      "points": 500,
      "owned": false,
    },
    {
      "name": "Blue",
      "small_image": Colors.blue,
      "image": 'blue.png',
      "id": 3,
      "points": 100,
      "owned": false,
    },
    {
      "name": "Crismas",
      "small_image": Colors.green,
      "image": 'crismas.png',
      "id": 4,
      "points": 30,
      "owned": false,
    },
  ];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadItem() async {
    final prefs = await SharedPreferences.getInstance();
    final items = await loadItemQuantities();
    setState(() {
      item_swap = items["swap"]!;
      item_undo = items["undo"]!;
      item_delete = items["delete"]!;
    });
  }

  void loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final items = await loadItemQuantities();
    final ownedThemes = await loadOwnedThemes();
    final savedPoints = prefs.getInt('points') ?? 0;

    setState(() {
      points = savedPoints;
      item_swap = items["swap"]!;
      item_undo = items["undo"]!;
      item_delete = items["delete"]!;
      for (var theme in themes) {
        theme["owned"] = ownedThemes.contains(theme["name"]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();
    final currentItem = items[selectedItemIndex];
    final currentTheme = themes[selectedThemeIndex];

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
          Column(
            children: [
              SizedBox(height: 30),
              Container(
                height: 80,
                width: 300,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: const Text(
                    'Shop',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  ),
                ),
              ),
              SizedBox(height: 45),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedTab = 0),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedTab == 0 ? gameTheme.activeButton : gameTheme.inactiveButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text(
                        "Item",
                        style: TextStyle(fontSize: 14, color: gameTheme.lightText),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () => setState(() => selectedTab = 1),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            selectedTab == 1 ? gameTheme.activeButton : gameTheme.inactiveButton,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                      ),
                      child: Text(
                        "Theme",
                        style: TextStyle(fontSize: 14, color: gameTheme.lightText),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 50),
                  SizedBox(height: 20, child: Text("points: $points")),
                ],
              ),
              // SizedBox(height: 10),
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
                        child: Scrollbar(
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  childAspectRatio: 1.4,
                                  crossAxisSpacing: 8,
                                  mainAxisSpacing: 8,
                                ),
                            itemCount:
                                selectedTab == 0 ? items.length : themes.length,
                            itemBuilder: (context, index) {
                              final isItem = selectedTab == 0;
                              final data = isItem ? items[index] : themes[index];
          
                              return GestureDetector(
                                onTap:
                                    () => setState(() {
                                      if (isItem)
                                        selectedItemIndex = index;
                                      else
                                        selectedThemeIndex = index;
                                    }),
                                child: SizedBox(
                                  width: 100,
                                  height: 100,
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color:
                                          (isItem
                                                      ? selectedItemIndex
                                                      : selectedThemeIndex) ==
                                                  index
                                              ? gameTheme.inactiveButton
                                              : gameTheme.activeButton,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        if (!isItem)
                                          Container(
                                            height: 30,
                                            // color: data["small_image"],
                                            child: Text(
                                              data["name"],
                                              style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          )
                                        else
                                          Icon(data["icon"], size: 24),
                                        Text(
                                          data["name"],
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          "points: ${data["points"]}",
                                          style: const TextStyle(fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      height: 250,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: gameTheme.lightText,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child:
                            selectedTab == 0
                                ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          currentItem["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: gameTheme.darkText
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          "owned: ${_getItemCount(currentItem["name"])}",
                                          style: TextStyle(fontSize: 12, color: gameTheme.darkText),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
                                      child: Text(
                                        currentItem["description"],
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(color: gameTheme.darkText),
                                      ),
                                    ),
                                  ],
                                )
                                : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          currentTheme["name"],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: gameTheme.darkText
                                          ),
                                        ),
                                        SizedBox(width: 10),
                                        if (currentTheme["owned"]) Text("Owned",  style: TextStyle(color: gameTheme.darkText),),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Expanded(
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: Image.asset(currentTheme["image"]),
                                      ),
                                    ),
                                  ],
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            points = prefs.getInt('points') ?? 0;
          
                            if (selectedTab == 0) {
                              final item = items[selectedItemIndex];
                              final name = item["name"];
                              final int cost = item["points"];
          
                              // get current quantity
                              Map<String, int> quantities =
                                  await loadItemQuantities();
                              int currentQty = quantities[name]!;
          
                              // max quantity rules
                              final max =
                                  {"swap": 4, "undo": 8, "delete": 2}[name]!;
          
                              if (currentQty >= max) {
                                // Already at max
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "You already have max $name items.",
                                    ),
                                  ),
                                );
                                return;
                              }
          
                              if (points < cost) {
                                // Not enough points
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Not enough points to buy $name.",
                                    ),
                                  ),
                                );
                                return;
                              }
          
                              // All good, process purchase
                              await saveItemQuantity(name, currentQty + 1);
                              await prefs.setInt("points", points - cost);
          
                              setState(() {
                                points -= cost;
                              });
          
                              loadItem();
          
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("$name purchased!")),
                              );
                            } else {
                              final theme = themes[selectedThemeIndex];
                              final name = theme["name"];
                              final int cost = theme["points"];
          
                              if (!theme["owned"]) {
                                if (points < cost) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        "Not enough points to buy $name theme.",
                                      ),
                                    ),
                                  );
                                  return;
                                }
          
                                // Purchase theme
                                List<String> ownedThemes = await loadOwnedThemes();
                                ownedThemes.add(name);
                                await saveOwnedThemes(ownedThemes);
                                await prefs.setInt("points", points - cost);
          
                                setState(() {
                                  points -= cost;
                                  themes[selectedThemeIndex]["owned"] = true;
                                });
          
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("$name theme purchased!")),
                                );
                              } else {
                                // Already owned, equip it
                                Provider.of<ThemeProvider>(
                                  context,
                                  listen: false,
                                ).changeTheme(theme["id"]);
          
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("$name theme equipped!")),
                                );
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: gameTheme.actionButton,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: Text(
                            selectedTab == 0
                                ? "Buy"
                                : currentTheme["owned"]
                                ? "Equip"
                                : "Buy",
                            style: TextStyle(color: gameTheme.lightText),
                          ),
                        ),
                        SizedBox(width: 50),
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

  void onBuyTheme(String themeName) async {
    List<String> ownedThemes = await loadOwnedThemes();

    if (!ownedThemes.contains(themeName)) {
      ownedThemes.add(themeName);
      await saveOwnedThemes(ownedThemes);
    }

    setState(() {
      themes.firstWhere((theme) => theme["name"] == themeName)["owned"] = true;
    });
  }

  int _getItemCount(String name) {
    switch (name) {
      case "swap":
        return item_swap;
      case "undo":
        return item_undo;
      case "delete":
        return item_delete;
      default:
        return 0;
    }
  }
}
