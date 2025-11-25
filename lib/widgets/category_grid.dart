import 'package:flutter/material.dart';
import '../models/category_modal.dart';
import 'category_cart.dart';

class CategoryGrid extends StatefulWidget {
  final List<Category> category;

  const CategoryGrid({super.key, required this.category});

  @override
  State<StatefulWidget> createState() => _CategoryGridState();
}

class _CategoryGridState extends State<CategoryGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 200/244
      ),
      itemCount: widget.category.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CategoryCard(category: widget.category[index]);
      },
    );
  }
}
