import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/recipe_details_page.dart';
import 'package:recipe_app/custom_app_bar.dart';

class RecipeListPage extends StatefulWidget {
  RecipeListPage({Key? key}) : super(key: key);

  @override
  State<RecipeListPage> createState() => _RecipeListPageState();
}

class _RecipeListPageState extends State<RecipeListPage> {
  final _recipeBox = Hive.box('recipeDB');
  String? _selectedCategory; // Selected filter category
  List<String> _categories = []; // Categories to filter by

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  // Load all unique categories from the recipeBox
  void _loadCategories() {
    final recipes = _recipeBox.toMap();
    final allCategories = recipes.values
        .map((recipe) => recipe[0].toString()) // Ensure type is String
        .toSet(); // Extract unique categories
    setState(() {
      _categories = allCategories.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Recipe(s) List'),
      body: Column(
        children: [
          // Dropdown for filtering
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<String>(
              value: _selectedCategory,
              hint: const Text('Filter by Category'),
              isExpanded: true,
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value;
                });
              },
              items: _categories.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList()
                ..add(const DropdownMenuItem(
                  value: null,
                  child: Text('All Categories'),
                )), // Add an option for "All Categories"
            ),
          ),
          const Divider(height: 1, color: Colors.grey),

          // Recipe List
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _recipeBox.listenable(),
              builder: (context, Box box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text('No recipes added yet!'),
                  );
                }

                // Filter recipes based on the selected category
                final recipes = _recipeBox.toMap();
                final filteredRecipes = _selectedCategory == null
                    ? recipes.entries
                    : recipes.entries.where((entry) => entry.value[0] == _selectedCategory);

                if (filteredRecipes.isEmpty) {
                  return Center(
                    child: Text('No recipes found for $_selectedCategory.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredRecipes.length,
                  itemBuilder: (context, index) {
                    final key = filteredRecipes.elementAt(index).key;
                    final recipe = filteredRecipes.elementAt(index).value;

                    return ListTile(
                      title: Text(recipe[1]), // Recipe name
                      subtitle: Text(recipe[0]), // Recipe type
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RecipeDetailsPage(
                              recipeKey: key,
                              type: recipe[0],
                              name: recipe[1],
                              description: recipe[2],
                            ),
                          ),
                        );
                        print('Recipe tapped: $recipe');
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
