import 'package:flutter/material.dart';
import 'package:flutter_game_2048/components/aButton.dart';
import 'package:flutter_game_2048/pages/login_page.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';
import 'package:provider/provider.dart';


class MenuPage extends StatefulWidget {
  const MenuPage({super.key});
  
  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();
    return Scaffold(
      appBar: AppBar(backgroundColor: gameTheme!.appBar),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Stack(
        children: [
          //เสกหิมะ ถ้าเลือก them ที่ 4 คือ Chirsmas
          if(Provider.of<ThemeProvider>(context).selectTheme == 4)
          SnowFallAnimation(
            config: SnowfallConfig(
              numberOfSnowflakes: 200,
              speed: 1.0,
              useEmoji: true,
              customEmojis: ['❄️', '❅', '❆'],
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 20),
                  // Logo
                  Container(
                    width: 320,
                    height: 175,
                    decoration: BoxDecoration(
                      color: gameTheme.lightText,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    //วางใว้ตรงกลางแล้วใส่ Logo                    alignment: Alignment.center,
                    child: Image.asset('assets/images/game_logo.png'),
                  ),

                  // const SizedBox(height: 10),
                  // Buttons
                  Column(
                    children: [
                      MenuButton(
                        label: "Start",
                        color: Theme.of(context).colorScheme.primary,
                        textColor: gameTheme.lightText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 70,
                        width: 300,
                        onPressed: () {
                          Navigator.pushNamed(context, '/gamePage');
                        },
                      ),
                      //Box ใว้ใส่ Leader board
                      const SizedBox(height: 20),
                      MenuButton(
                        label: "Leader board",
                        color: Theme.of(context).colorScheme.primary,
                        textColor: gameTheme.lightText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        height: 60,
                        width: 250,
                        onPressed: () {
                          //ไปหน้า leader board Page
                          Navigator.pushNamed(context, '/boardPage');
                        },
                      ),
                      //Box ใว้ใส่ Shop
                      const SizedBox(height: 20),
                      MenuButton(
                        label: "Shop",
                        color: Theme.of(context).colorScheme.primary,
                        textColor: gameTheme.lightText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        height: 60,
                        width: 220,
                        onPressed: () {
                          //ไปหน้า shopPage
                          Navigator.pushNamed(context, '/shopPage');
                        },
                      ),
                      const SizedBox(height: 20),
                      // MenuButton(
                      //   label: "Test Theme",
                      //   color: Theme.of(context).colorScheme.primary,
                      //   textColor: gameTheme.lightText,
                      //   fontSize: 16,
                      //   fontWeight: FontWeight.bold,
                      //   height: 55,
                      //   width: 190,
                      //   onPressed: () {
                      //     Navigator.pushNamed(context, '/testPage');
                      //   },
                      // ),
                    ],
                  ),
          
                  // Bottom Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    //สร้างแถวแนวยาว
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        //ใส่ปุ่มเครดิต
                        bottomIconButton(Icons.star_border, () {
                          Navigator.pushNamed(context, '/creditPage');
                        }),
                        //ปุ่ม logout
                        bottomTextButton("logout"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 64,
        height: 66,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 30),
      ),
    );
  }

  Widget bottomTextButton(String text) {
    return GestureDetector(
      onTap: () async {
        final prefs = await SharedPreferences.getInstance();
        prefs.clear();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginPage()),
          (route) => false,
        );
      },
      child: Container(
        width: 64,
        height: 66,
        decoration: BoxDecoration(
          color:  Theme.of(context).colorScheme.tertiary,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
