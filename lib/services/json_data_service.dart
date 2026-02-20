import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/first_aid_data.dart';
import '../models/category_model.dart';

class JsonDataService {
  static final JsonDataService _instance = JsonDataService._internal();
  factory JsonDataService() => _instance;
  JsonDataService._internal();

  Map<String, dynamic>? _cachedData;
  List<CategoryModel>? _categories;
  List<FirstAidData>? _items;

  Future<void> loadData() async {
    if (_cachedData != null) return;

    final String jsonString =
        await rootBundle.loadString('assets/data/first_aid_data.json');
    _cachedData = json.decode(jsonString);

    _categories = (_cachedData!['categories'] as List)
        .map((c) => CategoryModel.fromJson(c))
        .toList();

    _items = (_cachedData!['items'] as List)
        .map((i) => FirstAidData.fromJson(i))
        .toList();
  }

  List<CategoryModel> get categories {
    if (_categories == null) {
      throw Exception('Data not loaded. Call loadData() first.');
    }
    return _categories!;
  }

  List<FirstAidData> get items {
    if (_items == null) {
      throw Exception('Data not loaded. Call loadData() first.');
    }
    return _items!;
  }

  List<String> get categoryNames {
    return categories.map((c) => c.name).toList();
  }

  List<FirstAidData> getDataByCategory(String category) {
    return items.where((item) => item.category == category).toList();
  }

  List<FirstAidData> searchData(String query) {
    final lowerQuery = query.toLowerCase();
    return items
        .where((item) =>
            item.title.toLowerCase().contains(lowerQuery) ||
            item.description.toLowerCase().contains(lowerQuery) ||
            item.symptoms.toLowerCase().contains(lowerQuery) ||
            item.treatment.toLowerCase().contains(lowerQuery))
        .toList();
  }

  FirstAidData? getDataById(int id) {
    try {
      return items.firstWhere((item) => item.id == id);
    } catch (e) {
      return null;
    }
  }

  CategoryModel? getCategoryByName(String name) {
    try {
      return categories.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }
}
