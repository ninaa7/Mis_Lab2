import 'package:flutter/material.dart';
import 'package:lab_2/widgets/meal_card.dart';
import '../models/meal_modal.dart';
import '../utils/favorites_manager.dart';

class MealGrid extends StatefulWidget {
  final List<Meal> meal;

  const MealGrid({super.key, required this.meal});

  @override
  State<MealGrid> createState() => _MealGridState();
}

class _MealGridState extends State<MealGrid> {
  final FavoritesManager _favoritesManager = FavoritesManager();

  @override
  void initState() {
    super.initState();
    _favoritesManager.addListener(_onFavoritesChanged);
  }

  @override
  void dispose() {
    _favoritesManager.removeListener(_onFavoritesChanged);
    super.dispose();
  }

  void _onFavoritesChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 2 cards per row
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.8, // Adjust this to control card height
        ),
        itemCount: widget.meal.length,
        itemBuilder: (context, index) {
          final currentMeal = widget.meal[index];

          return MealCard(
            meal: currentMeal,
            isFavorite: _favoritesManager.isFavorite(currentMeal.id),
            onToggleFavorite: () {
              _favoritesManager.toggleFavorite(currentMeal);
            },
          );
        },
      ),
    );
  }
}
