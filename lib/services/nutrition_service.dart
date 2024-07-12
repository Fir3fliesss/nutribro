// lib/services/nutrition_service.dart

import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

Future<Map<String, Nutrition>> loadNutritionData() async {
  final data = await rootBundle.loadString('assets/models/nutrition.json');
  final Map<String, dynamic> jsonResult = json.decode(data);

  return jsonResult.map((key, value) {
    return MapEntry(key, Nutrition.fromJson(value));
  });
}

class Nutrition {
  final int calories;
  final double fat;
  final double carbs;
  final double protein;

  Nutrition({
    required this.calories,
    required this.fat,
    required this.carbs,
    required this.protein,
  });

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'],
      fat: json['fat'],
      carbs: json['carbs'],
      protein: json['protein'],
    );
  }
}