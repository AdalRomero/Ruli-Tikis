import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final supabase = Supabase.instance.client;

class ProductosDatos extends ChangeNotifier {
  static final ProductosDatos current = ProductosDatos();

  List<Map<String, dynamic>> productos = [];
  String _filtro = '';

  String get filtro => _filtro;
  set filtro(String value) {
    _filtro = value;
    notifyListeners();
  }

  List<Map<String, dynamic>> get productosFiltrados {
    if (_filtro.isEmpty) return productos;
    final query = _filtro.toLowerCase();
    return productos.where((producto) {
      final nombre = producto['nombre']?.toLowerCase() ?? '';
      final categoria = producto['categoria']?.toLowerCase() ?? '';
      return nombre.contains(query) || categoria.contains(query);
    }).toList();
  }

  // 🔹 Cargar productos desde Supabase
  Future<void> cargarProductos() async {
    final response = await supabase.from('Productos').select();
    productos = List<Map<String, dynamic>>.from(response);
    notifyListeners();
  }

  // 🔹 Subir imagen al Storage
  Future<String?> subirImagen(Uint8List bytes, String fileName) async {
    try {
      await supabase.storage
          .from('img_prod')
          .uploadBinary(
            'productos/$fileName',
            bytes,
            fileOptions: FileOptions(upsert: true),
          );

      // Devuelve la URL pública
      final url = supabase.storage
          .from('img_prod')
          .getPublicUrl('productos/$fileName');
      return url;
    } catch (e) {
      print('Error subiendo imagen: $e');
      return null;
    }
  }

  // 🔹 Escuchar cambios en la tabla Productos
  void escucharCambios() {
    supabase
        .channel('public:Productos')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'Productos',
          callback: (payload) async {
            print('Cambio detectado en Productos: $payload');
            await cargarProductos(); // recarga productos automáticamente
          },
        )
        .subscribe();
  }

  // 🔹 Agregar producto
  Future<void> agregarProducto(Map<String, dynamic> producto) async {
    String? urlImagen;
    if (producto['imagenBytes'] != null) {
      urlImagen = await subirImagen(
        producto['imagenBytes'],
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
    }

    final response = await supabase.from('Productos').insert({
      'nombre': producto['nombre'],
      'categoria': producto['categoria'],
      'precio': double.tryParse(producto['precio'].toString()) ?? 0.0,
      'img': urlImagen,
    }).select();

    if (response.isNotEmpty) {
      final newProducto = Map<String, dynamic>.from(response.first);
      newProducto['imagenBytes'] =
          producto['imagenBytes']; // mantener localmente para mostrar
      productos.add(newProducto);
      notifyListeners();
    }
  }

  // 🔹 Actualizar producto
  Future<void> actualizarProducto(
    int index,
    Map<String, dynamic> producto,
  ) async {
    final id = productos[index]['id_productos'];
    if (id == null) return;

    String? urlImagen = producto['img']; // URL existente
    if (producto['imagenBytes'] != null) {
      urlImagen = await subirImagen(
        producto['imagenBytes'],
        '${DateTime.now().millisecondsSinceEpoch}.png',
      );
    }

    final response = await supabase
        .from('Productos')
        .update({
          'nombre': producto['nombre'],
          'categoria': producto['categoria'],
          'precio': double.tryParse(producto['precio'].toString()) ?? 0.0,
          'img': urlImagen,
        })
        .eq('id_productos', id)
        .select();

    if (response.isNotEmpty) {
      final updatedProducto = Map<String, dynamic>.from(response.first);
      updatedProducto['imagenBytes'] =
          producto['imagenBytes']; // mantener local
      productos[index] = updatedProducto;
      notifyListeners();
    }
  }

  // 🔹 Eliminar producto
  Future<void> eliminarProducto(int index) async {
    final id = productos[index]['id_productos'];
    if (id == null) return;
    await supabase.from('Productos').delete().eq('id_productos', id);
    productos.removeAt(index);
    notifyListeners();
  }
}
