import 'dart:convert';

import 'package:cooky_app/models/meal.dart';
import 'package:flutter/foundation.dart';
import 'package:cooky_app/models/category.dart' as cooky;
import 'package:cooky_app/services/category_service.dart';
import 'package:http/http.dart' as http;

class RecipeProvider with ChangeNotifier {
  final CategoryService _apiService = CategoryService();

  List<cooky.Category> _categories = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<cooky.Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCategories() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _categories = await _apiService.fetchCategories();
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // ------------------ Meal of the Day ------------------
  Meal? _randomMeal;
  Meal? get randomMeal => _randomMeal;

  Future<void> loadRandomMeal() async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final mealData = data['meals'][0];
        _randomMeal = Meal.fromJson(mealData);
        notifyListeners();
      } else {
        throw Exception('Failed to load random meal');
      }
    } catch (e) {
      debugPrint('Error loading random meal: $e');
    }
  }
}
