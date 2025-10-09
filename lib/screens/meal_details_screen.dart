import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/meal_detail_provider.dart';
import '../providers/favorite_provider.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;

  const MealDetailScreen({super.key, required this.mealId});

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MealDetailProvider>(
        context,
        listen: false,
      ).loadMealDetail(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MealDetailProvider>(context);
    final favProvider = Provider.of<FavoritesProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F6F1),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.deepOrangeAccent),
            )
          : provider.errorMessage != null
          ? Center(child: Text(provider.errorMessage!))
          : provider.mealDetail == null
          ? const Center(child: Text('No details found'))
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  expandedHeight: 300,
                  pinned: true,
                  backgroundColor: Colors.deepOrangeAccent,
                  actions: [
                    IconButton(
                      icon: Icon(
                        favProvider.isFavorite(widget.mealId)
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        favProvider.toggleFavorite(widget.mealId, {
                          'id': widget.mealId,
                          'name': provider.mealDetail!.name,
                          'image': provider.mealDetail!.imgaeUrl,
                        });
                      },
                    ),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    title: Text(
                      provider.mealDetail!.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    background: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.network(
                          provider.mealDetail!.imgaeUrl,
                          fit: BoxFit.cover,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.6),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Category & Area ---
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildChip(
                              provider.mealDetail!.category,
                              Icons.category,
                            ),
                            _buildChip(
                              provider.mealDetail!.area,
                              Icons.location_pin,
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // --- Title ---
                        Text(
                          'Cooking Instructions',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrangeAccent,
                          ),
                        ),
                        const SizedBox(height: 10),

                        // --- Instructions ---
                        Text(
                          provider.mealDetail!.instructions,
                          textAlign: TextAlign.justify,
                          style: GoogleFonts.poppins(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.grey[800],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // --- YouTube Button ---
                        if (provider.mealDetail!.youtubeUrl.isNotEmpty)
                          Center(
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.redAccent,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                  horizontal: 20,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                provider.mealDetail!.youtubeUrl;
                              },
                              icon: const Icon(
                                Icons.play_circle_fill,
                                color: Colors.white,
                              ),
                              label: Text(
                                'Watch on YouTube',
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildChip(String text, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.deepOrangeAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.deepOrangeAccent),
          const SizedBox(width: 6),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: Colors.deepOrangeAccent,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
