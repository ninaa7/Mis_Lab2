import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lab_2/models/meal_modal.dart';
import 'package:lab_2/models/mealdetail_modal.dart';
import '../models/category_modal.dart';

class ApiService {
  Future<List<Category>> loadCategoryList({required int n}) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List categories = data["categories"];
      return categories.take(n).map((item) => Category.fromJson(item)).toList();
    }else{
      throw Exception("Failed to load categories");
    }
  }

  Future<List<Meal>> loadMealList(String categoryName) async {
    final response = await http.get(
      Uri.parse(
          "https://www.themealdb.com/api/json/v1/1/filter.php?c=$categoryName"),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);

      final List meals = data['meals'] ?? [];
      return meals.map((item) => Meal.fromJson(item)).toList();
    } else {
      throw Exception("Failed to load meals");
    }
  }


  Future<Category?> searchCategoryByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categories = data['categories'] ?? [];

        final lower = name.toLowerCase();
        for (final item in categories) {
          final catName = (item['strCategory'] ?? '').toString().toLowerCase();
          if (catName == lower) {
            return Category.fromJson(item as Map<String, dynamic>);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Meal?> searchMealByName(String name) async {
    try {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/search.php?s={query}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List categories = data['categories'] ?? [];

        final lower = name.toLowerCase();
        for (final item in categories) {
          final catName = (item['strCategory'] ?? '').toString().toLowerCase();
          if (catName == lower) {
            return Meal.fromJson(item as Map<String, dynamic>);
          }
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Mealdetail?> getMealDetailById(String id) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/lookup.php?i=$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data['meals'];
      if (meals != null && meals.isNotEmpty) {
        return Mealdetail.fromJson(meals[0]);
      }
    }
    return null;
  }

  Future<Mealdetail?> getRandomMeal() async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/random.php'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final meals = data["meals"];
      if (meals != null && meals.isNotEmpty) {
        return Mealdetail.fromJson(meals[0]);
      }
    }
    return null;
  }
}

