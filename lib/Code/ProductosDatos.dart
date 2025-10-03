import 'package:flutter/material.dart';

class ProductosDatos extends ChangeNotifier {
  static final ProductosDatos current = ProductosDatos();
  List<Map<String, dynamic>> productos = [];

  void agregarProducto(Map<String, dynamic> producto) {
    productos.add(producto);
    notifyListeners();
  }

  void eliminarProducto(int index) {
    productos.removeAt(index);
    notifyListeners();
  }

  void actualizarProducto(int index, Map<String, dynamic> producto) {
    productos[index] = producto;
    notifyListeners();
  }
}
