import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:cooky_app/models/category.dart';

class CategoryService {
  static const String baseUrl = 'http://www.themealdb.com/api/json/v1/1';

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(Uri.parse('$baseUrl/categories.php'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      final List catergories = jsonResponse['categories'];
      return catergories.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
