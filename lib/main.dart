import 'package:cooky_app/providers/favorite_provider.dart';
import 'package:cooky_app/providers/meal_detail_provider.dart';
import 'package:cooky_app/providers/meal_provider.dart';
import 'package:cooky_app/providers/recepie_provider.dart';
import 'package:cooky_app/providers/search_provider.dart';
import 'package:cooky_app/screens/main_navigation_screen.dart';
import 'package:cooky_app/screens/onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// import 'screens/home_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('favoritesBox');
  runApp(const RecipeApp());
}

class RecipeApp extends StatelessWidget {
  const RecipeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RecipeProvider()),
        ChangeNotifierProvider(create: (_) => MealProvider()),
        ChangeNotifierProvider(create: (_) => MealDetailProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => SearchProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Recipe App',
        theme: ThemeData(primarySwatch: Colors.deepOrange),
        home: const OnboardingScreen(),
      ),
    );
  }
}
