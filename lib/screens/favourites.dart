import 'package:flutter/material.dart';
import '../widgets/meal_card.dart';
import '../utils/favorites_manager.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Favorites"),
        actions: [
          if (_favoritesManager.favoriteMeals.isNotEmpty)
            IconButton(
              icon: Icon(Icons.clear_all),
              tooltip: "Clear all favorites",
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Clear Favorites"),
                      content: Text("Are you sure you want to remove all favorite meals?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            _favoritesManager.clearAllFavorites();
                            Navigator.of(context).pop();
                          },
                          child: Text("Clear All"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
        ],
      ),
      body: _favoritesManager.favoriteMeals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    "No favorite meals yet",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Tap the heart icon on any meal to add it to favorites",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            )
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                physics: BouncingScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 0.8,
                ),
                itemCount: _favoritesManager.favoriteMeals.length,
                itemBuilder: (context, index) {
                  final meal = _favoritesManager.favoriteMeals[index];
                  return MealCard(
                    meal: meal,
                    isFavorite: true,
                    onToggleFavorite: () {
                      _favoritesManager.toggleFavorite(meal);
                    },
                  );
                },
              ),
            ),
    );
  }
}
