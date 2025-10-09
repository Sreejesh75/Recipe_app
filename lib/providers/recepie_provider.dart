import 'package:flutter/foundation.dart';
import 'package:cooky_app/models/category.dart' as cooky;
import 'package:cooky_app/services/category_service.dart';

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
}
