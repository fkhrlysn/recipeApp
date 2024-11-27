import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:recipe_app/home.dart';
import 'package:recipe_app/splash_screen.dart';

void main() async {
//initialize Hive
  await Hive.initFlutter();

  //open the box called recipeDB, a database representation.
  var _recipe = await Hive.openBox('recipeDB');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
