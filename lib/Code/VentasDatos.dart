import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class VentaDatos extends ChangeNotifier {
  static final VentaDatos current = VentaDatos();

  List<Map<String, dynamic>> ventas = [];
  String _filtro = '';

  String get filtro => _filtro;
  set filtro(String value) {
    _filtro = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get ventasFiltradas {
    if (_filtro.isEmpty) return ventas;
    final query = _filtro.toLowerCase();
    return ventas.where((v) {
      return (v['ID_Producto']?.toString() ?? '').contains(query) ||
          (v['ID_Cliente']?.toString() ?? '').contains(query) ||
          (v['cantidad']?.toString() ?? '').contains(query) ||
          (v['fecha']?.toString() ?? '').contains(query);
    }).toList();
  }

  // 🔹 Cargar ventas desde Supabase
  Future<void> cargarVentas() async {
    final response = await supabase.from('Ventas').select();
    ventas = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  // 🔹 Agregar venta
  Future<void> agregarVenta(Map<String, dynamic> venta) async {
    final response = await supabase.from('Ventas').insert(venta).select();
    if (response.isNotEmpty) {
      ventas.add(response.first);
      notifyListeners();
    }
  }

  // 🔹 Actualizar venta
  Future<void> actualizarVenta(
    int id_ventas,
    Map<String, dynamic> venta,
  ) async {
    final response = await supabase
        .from('Ventas')
        .update(venta)
        .eq('id_ventas', id_ventas)
        .select();
    if (response.isNotEmpty) {
      final index = ventas.indexWhere((v) => v['id_ventas'] == id_ventas);
      if (index != -1) {
        ventas[index] = response.first;
        notifyListeners();
      }
    }
  }

  // 🔹 Eliminar venta
  Future<void> eliminarVenta(int id_ventas) async {
    await supabase.from('Ventas').delete().eq('id_ventas', id_ventas);
    ventas.removeWhere((v) => v['id_ventas'] == id_ventas);
    notifyListeners();
  }

  // 🔹 Escuchar cambios en tiempo real
  void escucharCambios() {
    supabase
        .channel('public:Ventas')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Ventas',
          callback: (payload) async {
            print('Cambio en ventas detectado: $payload');
            await cargarVentas();
          },
        )
        .subscribe();
  }
}
