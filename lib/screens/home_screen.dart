import 'package:cooky_app/screens/meal_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:cooky_app/providers/recepie_provider.dart';
import '../widgets/category_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<RecipeProvider>(context, listen: false);
      provider.loadCategories();
      provider.loadRandomMeal();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<RecipeProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text(
          'Discover Recipes 🍳',
          style: GoogleFonts.poppins(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.deepOrangeAccent,
          ),
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
            )
          : provider.errorMessage != null
          ? Center(
              child: Text(
                provider.errorMessage!,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.redAccent,
                ),
              ),
            )
          : CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(12),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // 🍽️ Meal of the Day Section
                      if (provider.randomMeal != null) ...[
                        Text(
                          'Meal of the Day',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[900],
                          ),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => MealDetailScreen(
                                  mealId: provider.randomMeal!.id,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              image: DecorationImage(
                                image: NetworkImage(
                                  provider.randomMeal!.imgaeUrl,
                                ),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.6),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Text(
                                    provider.randomMeal!.name,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                      Text(
                        'Categories',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[900],
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),

                // 🍴 Category Grid (now scrolls as part of same view)
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final category = provider.categories[index];
                      return CategoryCard(category: category);
                    }, childCount: provider.categories.length),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 20)),
              ],
            ),
    );
  }
}
