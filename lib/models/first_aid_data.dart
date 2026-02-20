import 'package:flutter/material.dart';

class FirstAidData {
  final int id;
  final String title;
  final String iconName;
  final String colorHex;
  final String description;
  final String treatment;
  final String warnings;
  final String symptoms;
  final int priority;
  final String videoUrl;
  final String illustrationUrl;

  FirstAidData({
    required this.id,
    required this.title,
    required this.iconName,
    required this.colorHex,
    required this.description,
    this.treatment = '',
    this.warnings = '',
    this.symptoms = '',
    this.priority = 1,
    this.videoUrl = '',
    this.illustrationUrl = '',
  });

  Color get color {
    try {
      return Color(int.parse(colorHex));
    } catch (e) {
      return const Color(0xFFEF5350);
    }
  }

  IconData get icon {
    switch (iconName) {
      case 'emergency':
        return Icons.emergency;
      case 'favorite':
        return Icons.favorite;
      case 'devices':
        return Icons.devices;
      case 'local_fire_department':
        return Icons.local_fire_department;
      case 'bloodtype':
        return Icons.bloodtype;
      case 'psychology':
        return Icons.psychology;
      case 'accessibility_new':
        return Icons.accessibility_new;
      case 'pest_control':
        return Icons.pest_control;
      case 'bug_report':
        return Icons.bug_report;
      case 'air':
        return Icons.air;
      case 'restaurant':
        return Icons.restaurant;
      case 'sports_gymnastics':
        return Icons.sports_gymnastics;
      default:
        return Icons.medical_services;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'icon': iconName,
      'color': colorHex,
      'description': description,
      'treatment': treatment,
      'warnings': warnings,
      'symptoms': symptoms,
      'priority': priority,
      'videoUrl': videoUrl,
      'illustrationUrl': illustrationUrl,
    };
  }

  factory FirstAidData.fromMap(Map<String, dynamic> map) {
    return FirstAidData(
      id: map['id'],
      title: map['title'] ?? '',
      iconName: map['icon'] ?? map['iconName'] ?? 'medical',
      colorHex: map['color'] ?? map['colorHex'] ?? '0xFFEF5350',
      description: map['description'] ?? '',
      treatment: map['treatment'] ?? '',
      warnings: map['warnings'] ?? '',
      symptoms: map['symptoms'] ?? '',
      priority: map['priority'] ?? 1,
      videoUrl: map['videoUrl'] ?? '',
      illustrationUrl: map['illustrationUrl'] ?? '',
    );
  }

  factory FirstAidData.fromJson(Map<String, dynamic> json) {
    return FirstAidData(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      iconName: json['icon'] ?? json['iconName'] ?? 'medical',
      colorHex: json['color'] ?? '0xFFEF5350',
      description: json['description'] ?? '',
      treatment: json['treatment'] ?? '',
      warnings: json['warnings'] ?? '',
      symptoms: json['symptoms'] ?? '',
      priority: json['priority'] ?? 1,
      videoUrl: json['videoUrl'] ?? '',
      illustrationUrl: json['illustrationUrl'] ?? '',
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
