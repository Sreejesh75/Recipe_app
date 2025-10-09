import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/meal.dart';

class SearchProvider extends ChangeNotifier {
  bool isLoading = false;
  String? errorMessage;
  List<Meal> searchResults = [];

  Future<void> searchMeals(String query) async {
    if (query.isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      final url = Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/search.php?s=$query',
      );
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          searchResults = (data['meals'] as List)
              .map((json) => Meal.fromJson(json))
              .toList();
        } else {
          searchResults = [];
        }
      } else {
        errorMessage = "Failed to fetch meals.";
      }
    } catch (e) {
      errorMessage = "Something went wrong!";
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
