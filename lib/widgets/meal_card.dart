import 'package:flutter/material.dart';

import '../models/meal_modal.dart';

class MealCard extends StatelessWidget {
  final Meal meal;

  const MealCard({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/meal-details", arguments: meal.id);
      },
      child: Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.pink, width: 3),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(child: Image.network(meal.img)),
              Divider(),
              Text(meal.name, style: TextStyle(fontSize: 20)),
            ],
          ),
        ),
      ),
    );
  }
}
