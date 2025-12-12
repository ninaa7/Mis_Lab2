import '../models/meal_modal.dart';

class FavoritesManager {
  static final FavoritesManager _instance = FavoritesManager._internal();
  factory FavoritesManager() => _instance;
  FavoritesManager._internal();

  final List<Meal> _favoriteMeals = [];
  final List<Function()> _listeners = [];

  List<Meal> get favoriteMeals => List.unmodifiable(_favoriteMeals);

  bool isFavorite(int mealId) {
    return _favoriteMeals.any((meal) => meal.id == mealId);
  }

  void addListener(Function() listener) {
    _listeners.add(listener);
  }

  void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  void _notifyListeners() {
    for (final listener in _listeners) {
      listener();
    }
  }

  void toggleFavorite(Meal meal) {
    final existingIndex = _favoriteMeals.indexWhere((m) => m.id == meal.id);

    if (existingIndex >= 0) {
      _favoriteMeals.removeAt(existingIndex);
    } else {
      _favoriteMeals.add(meal);
    }

    _notifyListeners();
  }

  void clearAllFavorites() {
    _favoriteMeals.clear();
    _notifyListeners();
  }

  void removeFavorite(int mealId) {
    _favoriteMeals.removeWhere((meal) => meal.id == mealId);
    _notifyListeners();
  }
}
