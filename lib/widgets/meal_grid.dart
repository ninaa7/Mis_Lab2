import 'package:flutter/material.dart';
import 'package:lab_2/widgets/meal_card.dart';

import '../models/meal_modal.dart';

class MealGrid extends StatefulWidget {
  final List<Meal> meal;

  const MealGrid({super.key, required this.meal});

  @override
  State<StatefulWidget> createState() => _MealGridState();
}

class _MealGridState extends State<MealGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 200/244
      ),
      itemCount: widget.meal.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return MealCard(meal: widget.meal[index]);
      },
    );
  }
}
