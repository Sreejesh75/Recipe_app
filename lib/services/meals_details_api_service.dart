import 'dart:convert';
import 'package:cooky_app/models/meal.dart';
import 'package:http/http.dart' as http;

class MealDetailApiService {
  Future<Meal> fetchMealDetail(String id) async {
    final url = 'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Meal.fromJson(data['meals'][0]);
    } else {
      throw Exception('Failed to load meal details');
    }
  }
}
