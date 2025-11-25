class Mealdetail {
  final int id;
  final String name;
  final String img;
  final String instructions;
  final String link;
  final List<String> ingredients;

  Mealdetail({
    required this.id,
    required this.name,
    required this.img,
    required this.instructions,
    required this.link,
    required this.ingredients
  });

  factory Mealdetail.fromJson(Map<String, dynamic> data) {
    List<String> ingr = [];

    for (int i = 1; i <= 20; i++) {
      final ing = data['strIngredient$i'];
      if (ing != null &&
          ing.toString().trim().isNotEmpty &&
          ing.toString().trim() != "") {
        ingr.add(ing.toString());
      }
    }

    return Mealdetail(
        id: int.parse(data['idMeal']),
        name: data['strMeal'] ?? "",
        img: data['strMealThumb'] ?? "",
        instructions: data['strInstructions'] ?? "",
        link: data['strYoutube'] ?? "",
        ingredients: ingr
    );
  }

  Map<String, dynamic> toJson() => {
    "idMeal": id,
    "strMeal": name,
    "strMealThumb": img,
    "strInstructions": instructions,
    "strYoutube": link,
    "ingredients": ingredients
  };
}