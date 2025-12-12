import 'package:flutter/material.dart';
import 'package:lab_2/models/category_modal.dart';
import 'package:lab_2/models/meal_modal.dart';
import 'package:lab_2/services/api_service.dart';
import 'package:lab_2/widgets/meal_grid.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({super.key});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Category? category; // allow nullable and avoid reassigning a `final`
  List<Meal> _meals = [];
  List<Meal> _filteredMeals = [];

  bool _isLoading = true;
  bool _isSearching = false;
  String _searchQuery = '';

  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;

    if (args is Category) {
      if (category == null) {
        category = args;
        _loadMealList();
      }
    } else {
      // Invalid argument passed — notify and go back to avoid type cast crash
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid argument for category details')),
        );
        Navigator.pop(context);
      });
    }
  }

  void _loadMealList() async {
    if (category == null) return;
    final list = await _apiService.loadMealList(category!.category_name);

    setState(() {
      _meals = list;
      _filteredMeals = list;
      _isLoading = false;
    });
  }

  void _filterMeals(String query) {
    setState(() {
      _searchQuery = query;
      if (query.isEmpty) {
        _filteredMeals = _meals;
      } else {
        _filteredMeals = _meals
            .where((m) => m.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Future<void> _searchMealByName(String name) async {
    if (name.isEmpty) return;

    setState(() => _isSearching = true);

    final meal = await _apiService.searchMealByName(name);

    setState(() {
      _isSearching = false;
      if (meal != null) {
        _filteredMeals = [meal];
      } else {
        _filteredMeals = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // If category is null (invalid arg) show a simple screen while we pop
    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Category')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("Meals in ${category!.category_name}"),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search meals by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _filterMeals(value);
              },
            ),
          ),
          Expanded(
            child: _filteredMeals.isEmpty && _searchQuery.isNotEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off,
                      size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  const Text(
                    'No meals found',
                    style:
                    TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isSearching
                        ? null
                        : () async {
                      await _searchMealByName(_searchQuery);
                    },
                    child: _isSearching
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2),
                    )
                        : const Text('Search in API'),
                  ),
                ],
              ),
            )
                : MealGrid(meal: _filteredMeals),
          ),
        ],
      ),
    );
  }
}
