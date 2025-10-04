import 'package:flutter/material.dart';

class Clientesdatos extends ChangeNotifier {
  static final Clientesdatos current = Clientesdatos();
  List<Map<String, dynamic>> clientes = [];
  String _filtro = '';

  String get filtro => _filtro;
  set filtro(String value) {
    _filtro = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get clientesFiltrados {
    if (_filtro.isEmpty) return clientes;

    return clientes.where((clienteFiltro) {
      final nombre = clienteFiltro['nombre']?.toLowerCase() ?? '';
      final ciudad = clienteFiltro['ciudad']?.toLowerCase() ?? '';
      final edad = clienteFiltro['edad']?.toString() ?? '';
      final sexo = clienteFiltro['sexo']?.toLowerCase() ?? '';

      final query = _filtro.toLowerCase();

      return nombre.contains(query) ||
          ciudad.contains(query) ||
          edad.contains(query) ||
          sexo.contains(query);
    }).toList();
  }

  void agregarCliente(Map<String, dynamic> cliente) {
    clientes.add(cliente);
    notifyListeners();
  }

  void eliminarCliente(int index) {
    clientes.removeAt(index);
    notifyListeners();
  }

  void actualizarCliente(int index, Map<String, dynamic> cliente) {
    clientes[index] = cliente;
    notifyListeners();
  }
}
