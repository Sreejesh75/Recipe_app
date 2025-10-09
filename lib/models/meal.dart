class Meal {
  final String id;
  final String name;
  final String imgaeUrl;
  final String instructions;
  final String category;
  final String area;
  final String youtubeUrl;

  Meal({
    required this.id,
    required this.name,
    required this.imgaeUrl,
    required this.instructions,
    required this.category,
    required this.area,
    required this.youtubeUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['idMeal'],
      name: json['strMeal'] ?? '',
      imgaeUrl: json['strMealThumb'] ?? '',
      instructions: json['strInstructions'] ?? '',
      category: json['strCategory'] ?? '',
      area: json['strArea'] ?? '',
      youtubeUrl: json['strYoutube'] ?? '',
    );
  }
}
