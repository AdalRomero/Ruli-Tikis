import 'package:flutter/material.dart';

// Clase para el AppBar genérico
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color shadowColor;
  final Color textColor;
  final Color primaryColor;
  final Color accentColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    required this.shadowColor,
    required this.textColor,
    required this.primaryColor,
    required this.accentColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      toolbarHeight: 90,
      elevation: 10,
      shadowColor: shadowColor,
      actions: actions,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [primaryColor, accentColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: textColor,
        ),
      ),
    );
  }

  // Necesario para que funcione como AppBar
  @override
  Size get preferredSize => const Size.fromHeight(90);
}
