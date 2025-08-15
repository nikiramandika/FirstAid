import 'package:flutter/material.dart';

class Category {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Widget route;

  const Category({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.route,
  });
} 