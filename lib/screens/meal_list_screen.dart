// import 'package:cooky_app/models/meal.dart';
import 'package:cooky_app/screens/meal_details_screen.dart';
import 'package:cooky_app/widgets/meal_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/meal_provider.dart';

class MealsListScreen extends StatefulWidget {
  final String categoryName;

  const MealsListScreen({super.key, required this.categoryName});

  @override
  State<MealsListScreen> createState() => _MealsListScreenState();
}

class _MealsListScreenState extends State<MealsListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealProvider>(
        context,
        listen: false,
      ).loadMealsByCategory(widget.categoryName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final mealProvider = Provider.of<MealProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.categoryName,
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
      ),
      body: mealProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : mealProvider.errorMessage != null
          ? Center(child: Text(mealProvider.errorMessage!))
          : GridView.builder(
              padding: const EdgeInsets.all(10),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: mealProvider.meals.length,
              itemBuilder: (context, index) {
                final meal = mealProvider.meals[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(mealId: meal.id),
                      ),
                    );
                  },

                  child: Mealcard(meal: meal),
                );
              },
            ),
    );
  }
}



























// Card(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   elevation: 4,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       ClipRRect(
//                         borderRadius: const BorderRadius.vertical(
//                           top: Radius.circular(15),
//                         ),
//                         child: Image.network(
//                           meal.imgaeUrl,
//                           height: 120,
//                           width: double.infinity,
//                           fit: BoxFit.cover,
//                         ),
//                       ),
//                       const SizedBox(height: 10),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 6.0),
//                         child: Text(
//                           meal.name,
//                           textAlign: TextAlign.center,
//                           style: GoogleFonts.poppins(
//                             fontWeight: FontWeight.w500,
//                           ),
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );