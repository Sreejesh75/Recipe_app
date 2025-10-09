import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:cooky_app/models/meal.dart';

class MealApiService {
  static const String baseUrl = 'http://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> fetchMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('$baseUrl/filter.php?c=$category'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List meals = jsonResponse['meals'];
      return meals.map((data) => Meal.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load meals for category $category');
    }
  }
}
