import 'package:flutter/material.dart';

class Colores with ChangeNotifier {
  // Define tus colores personalizados aquí
  final Color white = const Color(0xFFFFFFFF);
  final Color black = const Color(0xFF000000).withOpacity(0.87);
  Color appBarSombra = Colors.white.withOpacity(0.5);

  final Color backgroundDark = Color(0xFF121212);
  final Color surfaceDark = Color(0xFF1E1E1E);
  final Color primaryGreen = Colors.green;
  final Color accentGreen = Color(0xFF00FF88);
  final Color textPrimary = Colors.white;
  final Color textSecondary = Colors.white70;

  final Color warning = Colors.orange.withOpacity(0.8);
  final Color danger = Colors.red.withOpacity(0.8);

  // Método para notificar cambios (si es necesario)
  void updateColors() {
    notifyListeners();
  }
}
