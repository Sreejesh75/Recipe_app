import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class FavoritesProvider extends ChangeNotifier {
  final _favoritesBox = Hive.box('favoritesBox');

  List<String> get favoriteMealIds =>
      _favoritesBox.keys.cast<String>().toList();

  bool isFavorite(String mealId) => _favoritesBox.containsKey(mealId);

  void toggleFavorite(String mealId, Map<String, dynamic> mealData) {
    if (isFavorite(mealId)) {
      _favoritesBox.delete(mealId);
    } else {
      _favoritesBox.put(mealId, mealData);
    }
    notifyListeners();
  }

  List<Map<String, dynamic>> get allFavorites {
    return _favoritesBox.values
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }
}
