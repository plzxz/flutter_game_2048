import 'package:flutter/material.dart';
import 'package:flutter_game_2048/theme/game_theme.dart';
import 'package:flutter_game_2048/theme/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:snow_fall_animation/snow_fall_animation.dart';

class Credit extends StatefulWidget {
  const Credit({super.key});
  @override
  State<Credit> createState() => credit();
}

class credit extends State<Credit> {
  //เก็บ list ของชื่อวิชาและชื่อคนในกลุ่ม
  final List<String> data = [
    'CSC452 Mobile programing',
    'Phongphit Thongchuenjit 6609684',
    'Pacharadanai Pattaravarenon 6606442 ',
    'Jirat Jakong 6609504',
  ];

  @override
  Widget build(BuildContext context) {
    final gameTheme = Theme.of(context).extension<GameTheme>();
    return Scaffold(
      appBar: AppBar(backgroundColor: gameTheme!.appBar),
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(
        child: Stack(
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
            
                  // กล่อง "Credit"
                  Container(
                    width: 280,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Credit',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                  ),
            
                  const SizedBox(height: 40),
            
                  // กล่องรายชื่อ
                  Container(
                    width: 340,
                    height: 400,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      data.join('\n\n'),
                      //เรียนใช้ data ที่เก็บใว้ บรรทัดที่ 14 ให้มาวางใว้ที่ตรงนี้
                      maxLines: 10,
                      overflow: TextOverflow.visible,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
