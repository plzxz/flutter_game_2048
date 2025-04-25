import 'package:flutter/material.dart';

class ShopItem {
  final String name;
  final IconData icon;
  final String description;
  final int points;

  ShopItem({
    required this.name,
    required this.icon,
    required this.description,
    required this.points,
  });
}
