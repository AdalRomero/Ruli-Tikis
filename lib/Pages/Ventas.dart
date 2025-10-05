import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Code/ClientesDatos.dart';
import 'package:the_man_who_sold_the_world/Code/ProductosDatos.dart';
import 'package:the_man_who_sold_the_world/Code/VentasDatos.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/textField.dart';

class Ventas extends StatefulWidget {
  const Ventas({super.key});

  @override
  State<Ventas> createState() => _VentasState();
}

TextEditingController buscador = TextEditingController();

int? selectedClienteId;
final c = Colores();
ValueNotifier<List<Map<String, dynamic>>> carritoNotifier = ValueNotifier([]);

class _VentasState extends State<Ventas> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: c.backgroundDark,
      appBar: CustomAppBar(
        title: 'Leo & Chilanguitos',
        shadowColor: c.appBarSombra.withOpacity(0.38),
        textColor: c.textPrimary,
        primaryColor: c.primaryGreen,
        accentColor: c.accentGreen,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: c.textPrimary, size: 35),
            onPressed: verCarrito,
          ),
          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 28.0,
              bottom: 28.0,
            ),
            child: Column(
              spacing: 20,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedClienteId, // null al inicio
                  dropdownColor: c.surfaceDark,
                  style: TextStyle(color: c.textPrimary),
                  decoration: InputDecoration(
                    icon: Icon(Icons.person, color: c.textPrimary),
                    labelText: 'Cliente',
                    labelStyle: TextStyle(color: c.textPrimary),
                    filled: true,
                    fillColor: c.backgroundDark,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  hint: Text(
                    'Selecciona un cliente',
                    style: TextStyle(color: c.textPrimary, fontSize: 18),
                  ),
                  items: Clientesdatos.current.clientesFiltrados.map((cliente) {
                    return DropdownMenuItem<int>(
                      value: cliente['id_clientes'],
                      child: Text(
                        cliente['nombre'],
                        style: TextStyle(color: c.textPrimary, fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedClienteId =
                          val; // actualiza el valor seleccionado
                    });
                  },
                ),
                SizedBox(height: 10),
                CustomContainer(
                  width: double.infinity,
                  height: altura(selectedClienteId).toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        spacing: 20,
                        children: [
                          Text(
                            'Productos a la venta',
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (selectedClienteId != null) ...[
                            CustomTextField(
                              controller: buscador,
                              label: 'Buscar',
                              hint: 'Nombre, categoria',
                              prefixIcon: Icons.search,
                              onChanged: (value) {
                                setState(() {
                                  ProductosDatos.current.filtro = value;
                                });
                              },
                            ),
                            AnimatedBuilder(
                              animation: ProductosDatos.current,
                              builder: (__, _) {
                                final productosFiltrados =
                                    ProductosDatos.current.productosFiltrados;
                                if (productosFiltrados.isEmpty) {
                                  return Text(
                                    "No hay productos que coincidan con la búsqueda.",
                                    style: TextStyle(color: c.textSecondary),
                                  );
                                }
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: productosFiltrados.length,
                                  itemBuilder: (context, index) {
                                    final producto = productosFiltrados[index];
                                    return ListTile(
                                      leading: producto['imagenBytes'] != null
                                          ? Image.memory(
                                              producto['imagenBytes'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : (producto['img'] != null
                                                ? Image.network(
                                                    producto['img'],
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  )
                                                : Icon(
                                                    Icons.inventory,
                                                    color: c.textPrimary,
                                                  )),
                                      title: Text(
                                        producto['nombre'] ?? '',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                      subtitle: Text(
                                        'Categoría: ${producto['categoria'] ?? ''} - Precio: \$${producto['precio'] ?? ''} \r\n Cantidad: ${producto['cantidad']}',
                                        style: TextStyle(
                                          color: c.textSecondary,
                                        ),
                                      ),
                                      trailing: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: c.accentGreen,
                                        ),
                                        onPressed: () {
                                          agregarAlCarrito(producto);
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "Agregado al carrito",
                                              ),
                                              duration: Duration(
                                                milliseconds: 260,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ] else ...[
                            Text(
                              'Ningún cliente seleccionado',
                              style: TextStyle(color: c.textSecondary),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  int altura(int? clienteId) {
    try {
      if (clienteId != null) {
        // Si hay cliente seleccionado, altura grande
        return 450;
      } else {
        // Si no hay cliente seleccionado, altura pequeña
        return 105;
      }
    } catch (e) {
      print(e);
      return 10;
    }
  }

  void agregarAlCarrito(Map<String, dynamic> producto) {
    final int stock = (producto['cantidad'] ?? 0).toInt();
    String mensaje;

    if (stock <= 0) {
      mensaje = 'No hay stock disponible de este producto';
    } else {
      final index = carritoNotifier.value.indexWhere(
        (p) => p['producto']['id_productos'] == producto['id_productos'],
      );

      if (index != -1) {
        if (carritoNotifier.value[index]['cantidad'] >= stock) {
          mensaje = 'No puedes agregar más unidades de este producto';
        } else {
          carritoNotifier.value[index]['cantidad'] += 1;
          mensaje = 'Agregado al carrito';
        }
      } else {
        carritoNotifier.value.add({'producto': producto, 'cantidad': 1});
        mensaje = 'Agregado al carrito';
      }

      carritoNotifier.notifyListeners();
    }

    // Mostrar solo un SnackBar según el mensaje
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: Duration(seconds: 1)),
    );
  }

  void verCarrito() {
    final scaffoldContext = context; // para SnackBars

    showModalBottomSheet(
      context: scaffoldContext,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: c.surfaceDark,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(25),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Lista de productos
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 80,
                    ), // espacio para el footer
                    child: ValueListenableBuilder<List<Map<String, dynamic>>>(
                      valueListenable: carritoNotifier,
                      builder: (context, carrito, _) {
                        if (carrito.isEmpty) {
                          return Center(
                            child: Text(
                              "El carrito está vacío",
                              style: TextStyle(color: c.textSecondary),
                            ),
                          );
                        }

                        return ListView.builder(
                          controller: scrollController,
                          itemCount: carrito.length,
                          itemBuilder: (context, index) {
                            final item = carrito[index];
                            final prod = item['producto'];

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    c.primaryGreen.withOpacity(0.3),
                                    c.accentGreen.withOpacity(0.3),
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: prod['img'] != null
                                        ? Image.network(
                                            prod['img'],
                                            width: 60,
                                            height: 60,
                                            fit: BoxFit.cover,
                                          )
                                        : Icon(
                                            Icons.inventory,
                                            color: c.textPrimary,
                                            size: 60,
                                          ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prod['nombre'] ?? '',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: c.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Cantidad: ${item['cantidad']}  •  Precio: \$${prod['precio']}',
                                          style: TextStyle(
                                            color: c.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          if (item['cantidad'] <
                                              prod['cantidad']) {
                                            item['cantidad']++;
                                            carritoNotifier.notifyListeners();
                                          }
                                        },
                                        icon: Icon(
                                          Icons.add_circle_outline,
                                          color: c.accentGreen,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          if (item['cantidad'] > 1) {
                                            item['cantidad']--;
                                            carritoNotifier.notifyListeners();
                                          } else {
                                            ScaffoldMessenger.of(
                                              scaffoldContext,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "La cantidad mínima es 1",
                                                ),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        },
                                        icon: Icon(
                                          Icons.remove_circle_outline,
                                          color: c.warning,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          carritoNotifier.value.removeAt(index);
                                          carritoNotifier.notifyListeners();
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.redAccent,
                                        ),
                                        tooltip: 'Eliminar del carrito',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // Footer flotante con total y comprar
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: c.backgroundDark,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ValueListenableBuilder<List<Map<String, dynamic>>>(
                            valueListenable: carritoNotifier,
                            builder: (context, carrito, _) {
                              double total = 0;
                              for (var item in carrito) {
                                double precio =
                                    (item['producto']['precio'] ?? 0)
                                        .toDouble();
                                total += precio * item['cantidad'];
                              }
                              return Text(
                                'Total: \$${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: c.textPrimary,
                                ),
                              );
                            },
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.accentGreen,
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 20,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: carritoNotifier.value.isNotEmpty
                                ? () async {
                                    // Guardar las ventas y restar stock
                                    for (var item in carritoNotifier.value) {
                                      final prod = item['producto'];
                                      final cantidad = item['cantidad'];

                                      // 🔹 Guardar venta en la base de datos
                                      await VentaDatos.current.agregarVenta({
                                        'ID_Producto': prod['id_productos'],
                                        'ID_Cliente': selectedClienteId,
                                        'cantidad': cantidad,
                                        'fecha': DateTime.now()
                                            .toIso8601String()
                                            .split('T')
                                            .first,
                                      });

                                      // 🔹 Restar cantidad del stock
                                      await ProductosDatos.current.restarStock(
                                        prod['id_productos'],
                                        cantidad,
                                      );
                                    }

                                    // Notificar a ProductosDatos para actualizar UI
                                    ProductosDatos.current.notifyListeners();

                                    // Vaciar carrito
                                    carritoNotifier.value.clear();
                                    carritoNotifier.notifyListeners();

                                    Navigator.pop(context); // cerrar carrito
                                    ScaffoldMessenger.of(
                                      scaffoldContext,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Compra realizada y registrada con éxito",
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                            icon: Icon(Icons.shopify, color: c.textPrimary),
                            label: Text(
                              'Comprar',
                              style: TextStyle(color: c.textPrimary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
