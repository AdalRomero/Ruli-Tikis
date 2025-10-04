import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

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
    final activos = clientes.where((c) => c['eliminado'] != true).toList();
    if (_filtro.isEmpty) return activos;

    final query = _filtro.toLowerCase();
    return activos.where((c) {
      return (c['nombre'] ?? '').toLowerCase().contains(query) ||
          (c['ciudad'] ?? '').toLowerCase().contains(query) ||
          (c['edad']?.toString() ?? '').contains(query) ||
          (c['sexo'] ?? '').toLowerCase().contains(query);
    }).toList();
  }

  // 🔹 Cargar clientes desde Supabase
  Future<void> cargarClientes() async {
    final response = await supabase.from('Clientes').select();
    // Filtrar eliminados al cargar
    clientes = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  // 🔹 Agregar cliente
  Future<void> agregarCliente(Map<String, dynamic> cliente) async {
    cliente['eliminado'] = false; // Por defecto activo
    final response = await supabase.from('Clientes').insert(cliente).select();
    if (response.isNotEmpty) {
      clientes.add(response.first);
      notifyListeners();
    }
  }

  // 🔹 Eliminar cliente (borrado lógico)
  Future<void> eliminarCliente(int id) async {
    await supabase
        .from('Clientes')
        .update({'eliminado': true})
        .eq('id_clientes', id);
    // Solo remover de la lista activa
    clientes.removeWhere((c) => c['id_clientes'] == id);
    notifyListeners();
  }

  // 🔹 Actualizar cliente
  Future<void> actualizarCliente(int id, Map<String, dynamic> cliente) async {
    final response = await supabase
        .from('Clientes')
        .update(cliente)
        .eq('id_clientes', id)
        .select();
    if (response.isNotEmpty) {
      final index = clientes.indexWhere((c) => c['id_clientes'] == id);
      if (index != -1) {
        clientes[index] = response.first;
        notifyListeners();
      }
    }
  }

  void escucharCambios() {
    supabase
        .channel('public:Clientes')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Clientes',
          callback: (payload) async {
            print('Cambio detectado: $payload');
            await cargarClientes();
          },
        )
        .subscribe();
  }
}
