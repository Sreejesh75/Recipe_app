import 'package:cooky_app/models/meal.dart';
import 'package:cooky_app/services/meals_details_api_service.dart';
import 'package:flutter/material.dart';

class MealDetailProvider with ChangeNotifier {
  final MealDetailApiService _apiService = MealDetailApiService();

  Meal? _mealDetail;
  bool _isLoading = false;
  String? _errorMessage;

  Meal? get mealDetail => _mealDetail;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadMealDetail(String id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _mealDetail = await _apiService.fetchMealDetail(id);
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
