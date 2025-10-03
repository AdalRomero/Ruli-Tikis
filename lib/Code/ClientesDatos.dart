import 'package:flutter/material.dart';

class Clientesdatos extends ChangeNotifier {
  static final Clientesdatos current = Clientesdatos();
  List<Map<String, dynamic>> clientes = [];

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
