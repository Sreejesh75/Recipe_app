import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'main_navigation_screen.dart'; // <- same folder import (adjust if different)

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _pageIndex = 0;

  final List<_OnboardPageData> _pages = [
    _OnboardPageData(
      image: 'assets/images/cheif1.dart.jpg',
      title: 'Discover Delicious Recipes',
      subtitle: 'Explore meals from around the world and cook like a pro.',
    ),
    _OnboardPageData(
      image: 'assets/images/cheif2.dart.jpg',
      title: 'Save Your Favorites',
      subtitle: 'Bookmark recipes you love and access them anytime.',
    ),
    _OnboardPageData(
      image: 'assets/images/cheif3.dart.jpg',
      title: 'Cook With Confidence',
      subtitle: 'Step-by-step instructions and videos for every dish.',
    ),
  ];

  void _goToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainNavigationScreen()),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildDots() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(_pages.length, (i) {
        final bool active = i == _pageIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: const EdgeInsets.symmetric(horizontal: 6),
          height: 8,
          width: active ? 22 : 8,
          decoration: BoxDecoration(
            color: active
                ? Colors.deepOrangeAccent
                : Colors.white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(6),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: Colors.deepOrangeAccent.withOpacity(0.2),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      // extendBodyBehindAppBar if you want full-bleed images under system bar
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          height:
              double.infinity, // explicit constraint -> avoids infinite height
          child: Stack(
            children: [
              PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) => setState(() => _pageIndex = index),
                itemBuilder: (context, index) {
                  final p = _pages[index];
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      // Background image (fills the page)
                      Positioned.fill(
                        child: Image.asset(
                          p.image,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stack) {
                            // helpful placeholder if image missing
                            return Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(
                                  Icons.image_not_supported,
                                  size: 56,
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      // Gradient overlay for text readability
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.black.withOpacity(0.65),
                                Colors.black.withOpacity(0.25),
                                Colors.transparent,
                              ],
                              stops: const [0.0, 0.4, 0.9],
                            ),
                          ),
                        ),
                      ),

                      // Bottom text card (pinned)
                      Positioned(
                        left: 20,
                        right: 20,
                        bottom: 64,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.w700,
                                height: 1.05,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              p.subtitle,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),

              // Top-right: Skip
              Positioned(
                right: 16,
                top: 12,
                child: TextButton(
                  onPressed: _goToMain,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    backgroundColor: Colors.black.withOpacity(0.25),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Skip',
                    style: GoogleFonts.poppins(color: Colors.white),
                  ),
                ),
              ),

              // Bottom controls (dots + next/start)
              Positioned(
                left: 0,
                right: 0,
                bottom: 18,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDots(),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 28),
                      child: Row(
                        children: [
                          // Previous button (optional)
                          if (_pageIndex > 0)
                            GestureDetector(
                              onTap: () {
                                final prev = _pageIndex - 1;
                                _pageController.animateToPage(
                                  prev,
                                  duration: const Duration(milliseconds: 350),
                                  curve: Curves.easeOut,
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 10,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.9),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                            )
                          else
                            const SizedBox(width: 56), // keeps spacing

                          const Spacer(),

                          // Next or Get Started button
                          ElevatedButton(
                            onPressed: () {
                              if (_pageIndex == _pages.length - 1) {
                                _goToMain();
                              } else {
                                _pageController.nextPage(
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.easeOut,
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrangeAccent,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 22,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                            ),
                            child: Text(
                              _pageIndex == _pages.length - 1
                                  ? 'Get Started'
                                  : 'Next',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// simple data holder
class _OnboardPageData {
  final String image;
  final String title;
  final String subtitle;
  _OnboardPageData({
    required this.image,
    required this.title,
    required this.subtitle,
  });
}
