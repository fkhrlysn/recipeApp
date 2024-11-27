import 'package:flutter/material.dart';
import 'package:recipe_app/home.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the HomePage after a delay (e.g., 3 seconds)
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 13, 69, 114), // You can customize the background color
      body: Center(
        child: Image.asset(
          'assets/images/recipeApp_icon.png', // Path to your image in assets
          height: 200, // Adjust the size as needed
          width: 200,
          fit: BoxFit.cover, // Adjust fit as needed
        ),
      ),
    );
  }
}
