import 'package:flutter/material.dart';

class CategoryModel {
  final String name;
  final int color;
  final String icon;
  final String description;

  CategoryModel({
    required this.name,
    required this.color,
    required this.icon,
    required this.description,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      name: json['name'] ?? '',
      color: int.parse(json['color'] ?? '0xFF3182CE'),
      icon: json['icon'] ?? 'medical_services',
      description: json['description'] ?? '',
    );
  }

  Color getColor() {
    return Color(color);
  }

  IconData getIcon() {
    switch (icon) {
      case 'bloodtype':
        return Icons.bloodtype;
      case 'accessibility':
        return Icons.accessibility;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'psychology':
        return Icons.psychology;
      case 'warning':
        return Icons.warning;
      case 'flash_on':
        return Icons.flash_on;
      default:
        return Icons.medical_services;
    }
  }
}
