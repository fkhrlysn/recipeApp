import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:hive_flutter/hive_flutter.dart';

class RecipeDetailsPage extends StatefulWidget {
  final int recipeKey; // Recipe key from Hive
  String type;
  String name;
  String description;

  RecipeDetailsPage({
    Key? key,
    required this.recipeKey,
    required this.type,
    required this.name,
    required this.description,
  }) : super(key: key);

  @override
  State<RecipeDetailsPage> createState() => _RecipeDetailsPageState();
}

class _RecipeDetailsPageState extends State<RecipeDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;

  bool _isEditing = false; // Flag to toggle editing mode
  List<String> _recipeTypes = []; // List to store the recipe types loaded from JSON
  String? _selectedType;

  final _recipeBox = Hive.box('recipeDB');

  @override
  void initState() {
    super.initState();
    _loadRecipeTypes(); // Load recipe types when the page is initialized

    // Initialize controllers with existing recipe values
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.description);

    // Ensure the selected type is a valid value
    // If the selected type is not found in the list, use the first available type
    _selectedType = _recipeTypes.contains(widget.type)
        ? widget.type
        : _recipeTypes.isNotEmpty
            ? _recipeTypes.first
            : null;
  }

  @override
  void dispose() {
    // Dispose the controllers when the page is disposed
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  // Method to load recipe types from JSON
  Future<void> _loadRecipeTypes() async {
    try {
      // Load the JSON file
      final String response = await rootBundle.loadString('assets/recipetypes.json');
      final data = json.decode(response);

      // Extract recipe types from the JSON and update the state
      setState(() {
        _recipeTypes = List<String>.from(data['recipeTypes']);
      });
    } catch (e) {
      print("Error loading recipe types: $e");
    }
  }

  // Method to save the updated recipe data to Hive
  void _saveRecipe() {
    final updatedType = _selectedType;
    final updatedName = _nameController.text;
    final updatedDescription = _descriptionController.text;

    if (updatedName.isNotEmpty && updatedDescription.isNotEmpty && updatedType != null) {
      // Update recipe in Hive
      _recipeBox.put(widget.recipeKey, [updatedType, updatedName, updatedDescription]);

      // Update the widget state with the new values
      setState(() {
        _isEditing = false; // Exit editing mode
        widget.type = updatedType;
        widget.name = updatedName;
        widget.description = updatedDescription;
      });

      // Show a confirmation message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Recipe updated successfully!')),
      );

      setState(() {
        _isEditing = false; // Exit editing mode
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields!')),
      );
    }
  }

  // Method to delete the recipe
  void _deleteRecipe() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this recipe?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _recipeBox.delete(widget.recipeKey); // Delete the recipe from Hive
                Navigator.pop(context); // Close the dialog
                Navigator.pop(context); // Go back to the previous page
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Recipe deleted successfully!')),
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recipe Details'),
        backgroundColor: Color.fromARGB(255, 13, 69, 114),
        actions: [
          // Edit button
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              setState(() {
                _isEditing = true; // Allow editing when "Edit" button is pressed
              });
            },
          ),
          // Save button
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.save),
              onPressed: _saveRecipe,
            ),
          // Delete button
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _deleteRecipe,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Name field (TextField based on _isEditing)
            if (_isEditing)
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
              )
            else
              Text(
                'Name: ${widget.name}',
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),
            // Recipe Type field (Dropdown for selecting type)
            if (_isEditing)
              DropdownButtonFormField<String>(
                value: _selectedType,
                hint: const Text('Select Recipe Type'),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value; // Update the selected recipe type
                  });
                },
                items: _recipeTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
              )
            else
              Text(
                'Type: ${widget.type}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            const SizedBox(height: 10),

            if (_isEditing)
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    widget.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
