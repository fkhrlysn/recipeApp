import 'package:flutter/material.dart';

// Reusable CustomAppBar widget
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const CustomAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: const Color.fromARGB(255, 13, 69, 114),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
