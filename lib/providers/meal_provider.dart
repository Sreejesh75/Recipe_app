import 'package:cooky_app/models/meal.dart';
import 'package:cooky_app/services/meal_api_services.dart';
import 'package:flutter/material.dart';

class MealProvider with ChangeNotifier {
  final MealApiService _apiService = MealApiService();

  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Meal> get meals => _meals;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMealsByCategory(String category) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _meals = await _apiService.fetchMealsByCategory(category);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
