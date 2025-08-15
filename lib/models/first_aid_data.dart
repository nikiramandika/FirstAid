import 'package:flutter/material.dart';

class FirstAidData {
  final int id;
  final String category;
  final String title;
  final String description;
  final String treatment;
  final String warnings;
  final String symptoms;
  final String iconName;
  final int priority;

  FirstAidData({
    required this.id,
    required this.category,
    required this.title,
    required this.description,
    this.treatment = '',
    this.warnings = '',
    this.symptoms = '',
    this.iconName = 'medical',
    this.priority = 1,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category': category,
      'title': title,
      'description': description,
      'treatment': treatment,
      'warnings': warnings,
      'symptoms': symptoms,
      'iconName': iconName,
      'priority': priority,
    };
  }

  factory FirstAidData.fromMap(Map<String, dynamic> map) {
    return FirstAidData(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      description: map['description'],
      treatment: map['treatment'] ?? '',
      warnings: map['warnings'] ?? '',
      symptoms: map['symptoms'] ?? '',
      iconName: map['iconName'] ?? 'medical',
      priority: map['priority'] ?? 1,
    );
  }
}

class FirstAidCategory {
  final String name;
  final String description;
  final String iconName;
  final Color color;
  final int itemCount;

  FirstAidCategory({
    required this.name,
    required this.description,
    required this.iconName,
    required this.color,
    this.itemCount = 0,
  });
} 