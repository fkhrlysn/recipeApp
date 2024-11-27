import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/recipe_list_page.dart';
import 'form_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _recipe = Hive.box('recipeDB');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/images/recipeApp_icon.png', // Path to your image
            height: 200, // Set the height of the image
            width: 200, // Set the width of the image
            fit: BoxFit.cover, // Adjust the fit according to your needs
          ),
          const SizedBox(height: 20),

          // Navigate to form page
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 13, 69, 114), // Standard button color
              minimumSize: const Size(200, 50), // Set minimum button size
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FormPage()),
              );
            },
            child: const Text('Add New Recipe'),
          ),
          const SizedBox(height: 20),

          // Navigate to form page
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Color.fromARGB(255, 13, 69, 114), // Standard button color
              minimumSize: const Size(200, 50), // Set minimum button size
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RecipeListPage()),
              );
            },
            child: const Text('View Recipes'),
          ),
        ],
      )),
    );
  }
}
