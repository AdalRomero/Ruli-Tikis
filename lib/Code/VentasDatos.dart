import 'package:flutter/material.dart';

class VentaDatos extends ChangeNotifier {
  static final VentaDatos current = VentaDatos();
  List<Map<String, dynamic>> ventas = [];

  void agregarVenta(Map<String, dynamic> venta) {
    ventas.add(venta);
    notifyListeners();
  }

  void eliminarVenta(int index) {
    ventas.removeAt(index);
    notifyListeners();
  }

  void actualizarVenta(int index, Map<String, dynamic> venta) {
    ventas[index] = venta;
    notifyListeners();
  }
}
