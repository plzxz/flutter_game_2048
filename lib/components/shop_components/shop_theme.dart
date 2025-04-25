import 'package:flutter/material.dart';

class ShopThemeModel {
  final String name;
  final Color smallImage;
  final String image;
  final int id;
  final int points;
  bool owned;

  ShopThemeModel({
    required this.name,
    required this.smallImage,
    required this.image,
    required this.id,
    required this.points,
    this.owned = false,
  });
}
