import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Code/ClientesDatos.dart';
import 'package:the_man_who_sold_the_world/Code/ProductosDatos.dart';
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
                  value: selectedClienteId, // 🔹 será null al inicio
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
                      value: cliente['id'],
                      child: Text(
                        cliente['nombre'],
                        style: TextStyle(color: c.textPrimary, fontSize: 18),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedClienteId = val;
                      if (val != null) {
                        final clienteSel = Clientesdatos.current.clientes
                            .firstWhere((c) => c['id'] == val);
                        // aquí puedes hacer algo con clienteSel si quieres
                      }
                    });
                  },
                ),
                SizedBox(height: 10),
                CustomContainer(
                  width: double.infinity,
                  height: altura(
                    Clientesdatos.current.clientes.isEmpty,
                  ).toDouble(),
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
                                      title: Text(
                                        producto['nombre'] ?? '',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                      subtitle: Text(
                                        'Categoría: ${producto['categoria'] ?? ''} - Precio: \$${producto['precio'] ?? ''}',
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
                                          // Aquí puedes manejar la lógica para agregar el producto a la venta
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

  int altura(bool empity) {
    try {
      if (empity == false) {
        return 450;
      } else {
        return 105;
      }
    } catch (e) {
      print(e);
      return 10;
    }
  }
}
