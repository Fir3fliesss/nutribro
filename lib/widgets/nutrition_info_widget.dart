// lib/widgets/nutrition_info_widget.dart

import 'package:flutter/material.dart';
import '../services/nutrition_service.dart';

class NutritionInfoWidget extends StatelessWidget {
  final Nutrition nutrition;

  const NutritionInfoWidget({super.key, required this.nutrition});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Calories: ${nutrition.calories}'),
            Text('Fat: ${nutrition.fat}g'),
            Text('Carbohydrates: ${nutrition.carbs}g'),
            Text('Protein: ${nutrition.protein}g'),
          ],
        ),
      ),
    );
  }
}