import 'package:flutter/material.dart';

class ProductosDatos extends ChangeNotifier {
  static final ProductosDatos current = ProductosDatos();
  List<Map<String, dynamic>> productos = [];
  String _filtro = '';

  // Getter y setter para filtro
  String get filtro => _filtro;
  set filtro(String value) {
    _filtro = value;
    notifyListeners();
  }

  // Lista filtrada por nombre o categoría
  List<Map<String, dynamic>> get productosFiltrados {
    if (_filtro.isEmpty) return productos;

    final query = _filtro.toLowerCase();

    return productos.where((producto) {
      final nombre = producto['nombre']?.toLowerCase() ?? '';
      final categoria = producto['categoria']?.toLowerCase() ?? '';
      return nombre.contains(query) || categoria.contains(query);
    }).toList();
  }

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
