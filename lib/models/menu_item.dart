import 'package:flutter/material.dart';

enum MenuCategory { makanan, minuman, camilan }

extension MenuCategoryX on MenuCategory {
  String get label => switch (this) {
        MenuCategory.makanan => 'Makanan',
        MenuCategory.minuman => 'Minuman',
        MenuCategory.camilan => 'Camilan',
      };

  IconData get icon => switch (this) {
        MenuCategory.makanan => Icons.rice_bowl_rounded,
        MenuCategory.minuman => Icons.local_cafe_rounded,
        MenuCategory.camilan => Icons.cookie_rounded,
      };
}

class MenuItem {
  final String id;
  final String name;
  final String emoji;
  final MenuCategory category;
  final int price;
  final String description;
  final double rating;
  final int reviews;
  final int prepMinutes;
  final List<String> ingredients;
  final Color color;
  final bool bestSeller;

  const MenuItem({
    required this.id,
    required this.name,
    required this.emoji,
    required this.category,
    required this.price,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.prepMinutes,
    required this.ingredients,
    required this.color,
    this.bestSeller = false,
  });

  bool get isDrink => category == MenuCategory.minuman;
  bool get isFood => category == MenuCategory.makanan;
}
