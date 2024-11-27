import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/custom_app_bar.dart';

class FormPage extends StatefulWidget {
  const FormPage({Key? key}) : super(key: key);

  @override
  State<FormPage> createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final _recipe = Hive.box('recipeDB'); // Hive box reference

  final TextEditingController _nameController = TextEditingController(); // Recipe name
  final TextEditingController _descriptionController = TextEditingController(); // Recipe description
  String? _selectedType; // Selected recipe type
  List<String> _recipeTypes = []; // Dynamic recipe types from JSON

  @override
  void initState() {
    super.initState();
    _loadRecipeTypes(); // Load recipe types on init
  }

  // Load recipe types from JSON
  Future<void> _loadRecipeTypes() async {
    try {
      // Load the JSON file
      final String response = await rootBundle.loadString('assets/recipetypes.json');
      final data = json.decode(response);

      // Extract recipe types and update the state
      setState(() {
        _recipeTypes = List<String>.from(data['recipeTypes']);
      });
    } catch (e) {
      print("Error loading recipe types: $e");
    }
  }

  // Save recipe to Hive
  void _saveRecipe() {
    final name = _nameController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && description.isNotEmpty && _selectedType != null) {
      // Add recipe to Hive
      _recipe.add([_selectedType, name, description]);

      // Show confirmation and navigate back
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe added successfully!')),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Add Recipe'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _recipeTypes.isEmpty
            ? const Center(child: CircularProgressIndicator()) // Show loader until data is ready
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dropdown for recipe type
                  DropdownButtonFormField<String>(
                    value: _selectedType,
                    hint: const Text('Select Recipe Type'),
                    onChanged: (value) {
                      setState(() {
                        _selectedType = value;
                      });
                    },
                    items: _recipeTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Text field for recipe name
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Recipe Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Text field for recipe description
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),

                  // Save button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color.fromARGB(255, 13, 69, 114), // Standard button color
                      // Set minimum button size
                    ),
                    onPressed: _saveRecipe,
                    child: const Text('Save Recipe'),
                  ),
                ],
              ),
      ),
    );
  }
}
