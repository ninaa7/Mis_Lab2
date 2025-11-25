class Meal {
  int id;
  String name;
  String img;

  Meal({
    required this.id,
    required this.name,
    required this.img,
  });

  Meal.fromJson(Map<String, dynamic> data)
      : id = data['idMeal'] is int
      ? data['idMeal']
      : int.parse(data['idMeal'].toString()),
        name = data['strMeal']?? '',
        img =
            data['strMealThumb']?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'img': img,
  };
}
