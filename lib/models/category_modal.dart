class Category {
  int id;
  String category_name;
  String img;
  String description;

  Category({
    required this.id,
    required this.category_name,
    required this.img,
    required this.description,
  });

  Category.fromJson(Map<String, dynamic> data)
      : id = data['idCategory'] is int
      ? data['idCategory']
      : int.parse(data['idCategory'].toString()),
        category_name = data['strCategory']?? '',
        img =
            data['strCategoryThumb']?? 'No description',
        description = data['strCategoryDescription']?? '';

  Map<String, dynamic> toJson() => {
    'id': id,
    'category_name': category_name,
    'img': img,
    'description': description,
  };
}
