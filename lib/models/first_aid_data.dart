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
  final String videoUrl;
  final String illustrationUrl;

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
    this.videoUrl = '',
    this.illustrationUrl = '',
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
      'videoUrl': videoUrl,
      'illustrationUrl': illustrationUrl,
    };
  }

  factory FirstAidData.fromMap(Map<String, dynamic> map) {
    final dynamic iconNameVal = map['iconName'] ?? map['iconname'] ?? map['icon_name'];
    final dynamic videoUrlVal = map['videoUrl'] ?? map['videourl'] ?? map['video_url'];
    final dynamic illustrationUrlVal = map['illustrationUrl'] ?? map['illustrationurl'] ?? map['illustration_url'];

    return FirstAidData(
      id: map['id'],
      category: map['category'],
      title: map['title'],
      description: map['description'],
      treatment: map['treatment'] ?? '',
      warnings: map['warnings'] ?? '',
      symptoms: map['symptoms'] ?? '',
      iconName: (iconNameVal ?? 'medical') as String,
      priority: map['priority'] ?? 1,
      videoUrl: (videoUrlVal ?? '') as String,
      illustrationUrl: (illustrationUrlVal ?? '') as String,
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