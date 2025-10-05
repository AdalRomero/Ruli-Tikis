import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class MetricasService extends ChangeNotifier {
  static final MetricasService instance = MetricasService._privateConstructor();
  MetricasService._privateConstructor();

  int totalVentasMes = 0;
  int ventasTotales = 0;
  double promedioVentasCliente = 0;
  String productoMasVendido = '';
  Map<String, int> clientesPorCiudad = {};
  Map<String, double> porcentajeVentasCategoria = {};
  String clienteMayorGasto = '';

  bool cargando = true;

  Future<void> inicializar() async {
    cargando = true;
    notifyListeners();

    final now = DateTime.now();
    final inicioMes = DateTime(now.year, now.month, 1);
    final finMes = DateTime(now.year, now.month + 1, 0);

    // 🔹 Traer datos necesarios
    final ventasResp = await supabase.from('Ventas').select();
    final clientesResp = await supabase.from('Clientes').select();
    final productosResp = await supabase
        .from('Productos')
        .select()
        .eq('eliminado', false);

    List<Map<String, dynamic>> ventas = List<Map<String, dynamic>>.from(
      ventasResp,
    );
    List<Map<String, dynamic>> clientes = List<Map<String, dynamic>>.from(
      clientesResp,
    );
    List<Map<String, dynamic>> productos = List<Map<String, dynamic>>.from(
      productosResp,
    );

    // Total ventas
    ventasTotales = ventas.fold(
      0,
      (sum, v) => sum + ((v['cantidad'] ?? 0) as num).toInt(),
    );

    // Total ventas mes
    totalVentasMes = ventas
        .where((v) {
          final fecha = DateTime.tryParse(v['fecha'] ?? '');
          return fecha != null &&
              fecha.isAfter(inicioMes.subtract(const Duration(days: 1))) &&
              fecha.isBefore(finMes.add(const Duration(days: 1)));
        })
        .fold(0, (sum, v) => sum + ((v['cantidad'] ?? 0) as num).toInt());

    // Promedio por cliente
    Map<int, int> ventasClienteMap = {};
    for (var v in ventas) {
      final idCliente = v['ID_Cliente'];
      ventasClienteMap[idCliente] =
          ((ventasClienteMap[idCliente] ?? 0) + (v['cantidad'] ?? 0) as int);
    }
    promedioVentasCliente = ventasClienteMap.isNotEmpty
        ? ventasClienteMap.values.reduce((a, b) => a + b) /
              ventasClienteMap.length
        : 0;

    // Producto más vendido
    Map<int, int> ventasProductoMap = {};
    for (var v in ventas) {
      final idProd = v['ID_Producto'];
      ventasProductoMap[idProd] =
          ((ventasProductoMap[idProd] ?? 0) + (v['cantidad'] ?? 0) as int);
    }
    if (ventasProductoMap.isNotEmpty) {
      int idProd = ventasProductoMap.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      final prod = productos.firstWhere(
        (p) => p['id_productos'] == idProd,
        orElse: () => {},
      );
      productoMasVendido = prod['nombre'] ?? '';
    }

    // Clientes por ciudad
    clientesPorCiudad = {};
    for (var c in clientes) {
      final ciudad = c['ciudad'] ?? 'Desconocida';
      clientesPorCiudad[ciudad] = (clientesPorCiudad[ciudad] ?? 0) + 1;
    }

    // Porcentaje ventas por categoría
    Map<String, int> ventasCategoriaMap = {};
    for (var v in ventas) {
      final idProd = v['ID_Producto'];
      final prod = productos.firstWhere(
        (p) => p['id_productos'] == idProd,
        orElse: () => {},
      );
      final cat = prod['categoria'] ?? 'Sin categoría';
      ventasCategoriaMap[cat] =
          ((ventasCategoriaMap[cat] ?? 0) + (v['cantidad'] ?? 0) as int);
    }
    int totalCat = ventasCategoriaMap.values.fold(0, (a, b) => a + b);
    porcentajeVentasCategoria = {};
    ventasCategoriaMap.forEach((k, v) {
      porcentajeVentasCategoria[k] = totalCat > 0 ? (v / totalCat * 100) : 0;
    });

    // Cliente mayor gasto
    Map<int, double> gastoClienteMap = {};
    for (var v in ventas) {
      final idProd = v['ID_Producto'];
      final prod = productos.firstWhere(
        (p) => p['id_productos'] == idProd,
        orElse: () => {},
      );
      final precio = (prod['precio'] ?? 0).toDouble();
      final idCliente = v['ID_Cliente'];
      gastoClienteMap[idCliente] =
          (gastoClienteMap[idCliente] ?? 0) +
          precio * ((v['cantidad'] ?? 0) as int);
    }
    if (gastoClienteMap.isNotEmpty) {
      int idCliente = gastoClienteMap.entries
          .reduce((a, b) => a.value > b.value ? a : b)
          .key;
      final cli = clientes.firstWhere(
        (c) => c['id_clientes'] == idCliente,
        orElse: () => {},
      );
      clienteMayorGasto = cli['nombre'] ?? '';
    }

    cargando = false;
    notifyListeners();
  }
}
