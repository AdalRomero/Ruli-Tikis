import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Code/ProductosDatos.dart';
import 'package:the_man_who_sold_the_world/Pages/Clientes.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/image.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/textField.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

TextEditingController nombre = TextEditingController();
TextEditingController precio = TextEditingController();
TextEditingController cantidad = TextEditingController();
TextEditingController categoria = TextEditingController();
Uint8List? _selectedImage;
//------------------------------------------------------------------------------
TextEditingController nombreEdit = TextEditingController();
TextEditingController precioEdit = TextEditingController();
TextEditingController cantidadEdit = TextEditingController();
TextEditingController categoriaEdit = TextEditingController();
Uint8List? _selectedImageEdit;

final c = Colores();
bool buttonPressed = false;

class _ProductosState extends State<Productos> {
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
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 20,
              children: [
                if (buttonPressed == false) ...[
                  Container(
                    height: 60,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: c.surfaceDark,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: TextButton.icon(
                      onPressed: () {
                        setState(() {
                          buttonPressed = !buttonPressed;
                        });
                      },
                      label: Text(
                        'Agregar Producto',
                        style: TextStyle(fontSize: 22, color: c.textPrimary),
                      ),
                      icon: Icon(
                        Icons.view_module_rounded,
                        color: c.textPrimary,
                        size: 40,
                      ),
                    ),
                  ),
                ],

                if (buttonPressed == true) ...[
                  Center(
                    child: CustomContainer(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          spacing: 20,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Agregar Producto",
                                  style: TextStyle(
                                    color: c.textPrimary,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                                Spacer(),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      buttonPressed = false;
                                    });
                                  },
                                  icon: Icon(
                                    Icons.close,
                                    color: c.textPrimary,
                                    size: 28,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 16,
                              children: [
                                Expanded(
                                  child: Column(
                                    spacing: 16,
                                    children: [
                                      ImageSelector(
                                        key: ValueKey(_selectedImage),
                                        initialImageBytes: _selectedImage,
                                        onImageSelected: (img) {
                                          setState(() {
                                            _selectedImage = img;
                                          });
                                        },
                                      ),
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: c.warning,
                                          padding: EdgeInsets.symmetric(
                                            vertical: 14,
                                            horizontal: 14,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _selectedImage = null;
                                          });
                                        },
                                        label: Text(
                                          'Borrar Imagen',
                                          style: TextStyle(
                                            color: c.textPrimary,
                                          ),
                                        ),
                                        icon: Icon(
                                          Icons.no_photography,
                                          color: c.textPrimary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    spacing: 12,
                                    children: [
                                      CustomTextField(
                                        controller: nombre,
                                        label: 'Nombre',
                                        hint: 'Nombre del producto',
                                        prefixIcon: Icons.label,
                                        keyboardType: TextInputType.text,
                                      ),
                                      CustomTextField(
                                        controller: precio,
                                        label: 'Precio',
                                        hint: 'Precio del producto',
                                        prefixIcon: Icons.monetization_on,
                                        keyboardType: TextInputType.number,
                                      ),
                                      CustomTextField(
                                        controller: cantidad,
                                        label: 'Cantidad',
                                        hint: 'Cantidad de producto',
                                        prefixIcon: Icons.format_list_numbered,
                                        keyboardType: TextInputType.text,
                                      ),
                                      CustomTextField(
                                        controller: categoria,
                                        label: 'Categoría',
                                        hint: 'Categoría del producto',
                                        prefixIcon: Icons.description,
                                        keyboardType: TextInputType.text,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              spacing: 16,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: c.danger,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        clearFields();
                                      });
                                    },
                                    icon: Icon(
                                      Icons.cleaning_services,
                                      color: c.textPrimary,
                                    ),
                                    splashRadius: 24,
                                    tooltip: 'Limpiar',
                                  ),
                                ),
                                //guardar
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: c.primaryGreen,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                    ),
                                    onPressed: () {
                                      if (verificaciones()) {
                                        setState(() {
                                          ProductosDatos.current
                                              .agregarProducto({
                                                'nombre': nombre.text,
                                                'categoria': categoria.text,
                                                'cantidad': cantidad.text,
                                                'precio': precio.text,
                                                'imagenBytes': _selectedImage,
                                              });
                                          clearFields();
                                        });
                                      }
                                    },
                                    child: Text(
                                      'Guardar',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: c.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 10),

                CustomContainer(
                  width: double.infinity,
                  height: altura(
                    ProductosDatos.current.productos.isEmpty,
                  ).toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: [
                          Text(
                            "Productos Ingresados",
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (ProductosDatos.current.productos.isNotEmpty) ...[
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
                          ],
                          SizedBox(height: 10),
                          if (ProductosDatos.current.productos.isEmpty) ...[
                            Text(
                              "No hay Productos registrados.",
                              style: TextStyle(color: c.textSecondary),
                            ),
                          ] else ...[
                            AnimatedBuilder(
                              animation: ProductosDatos.current,
                              builder: (__, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: ProductosDatos
                                      .current
                                      .productosFiltrados
                                      .length,
                                  itemBuilder: (context, index) {
                                    final producto = ProductosDatos
                                        .current
                                        .productosFiltrados[index];
                                    return ListTile(
                                      leading: producto['imagenBytes'] != null
                                          ? Image.memory(
                                              producto['imagenBytes'],
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            )
                                          : Icon(
                                              Icons.inventory,
                                              color: c.textPrimary,
                                            ),
                                      title: Text(
                                        producto['nombre'] ?? '',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                      subtitle: Text(
                                        'Categoría: ${producto['categoria']}, Cantidad: ${producto['cantidad']}, Precio: ${producto['precio']}',
                                        style: TextStyle(
                                          color: c.textSecondary,
                                        ),
                                      ),
                                      trailing: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.edit,
                                              color: c.warning,
                                            ),
                                            onPressed: () {
                                              showModalBottomSheet(
                                                context: context,
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    c.backgroundDark,
                                                builder: (context) => FractionallySizedBox(
                                                  heightFactor: 0.8,
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: c.backgroundDark,
                                                      borderRadius:
                                                          const BorderRadius.vertical(
                                                            top:
                                                                Radius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                    ),
                                                    child: editar(
                                                      index,
                                                      ProductosDatos
                                                          .current
                                                          .productosFiltrados[index],
                                                    ),
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          IconButton(
                                            icon: Icon(
                                              Icons.delete,
                                              color: c.danger,
                                            ),
                                            onPressed: () {
                                              final originalIndex =
                                                  ProductosDatos
                                                      .current
                                                      .productos
                                                      .indexOf(producto);
                                              ProductosDatos.current
                                                  .eliminarProducto(
                                                    originalIndex,
                                                  );
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
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

  void clearFields() {
    nombre.clear();
    precio.clear();
    cantidad.clear();
    categoria.clear();
    setState(() {
      _selectedImage = null;
    });
  }

  bool verificaciones() {
    if (nombre.text.isEmpty ||
        precio.text.isEmpty ||
        cantidad.text.isEmpty ||
        categoria.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Por favor, completa todos los campos.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }
    final cantidadInt = int.tryParse(cantidad.text);
    if (cantidadInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La cantidad debe ser un número válido.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }
    if (cantidadInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La cantidad debe ser mayor a 0.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }

    final precioDouble = double.tryParse(precio.text);
    if (precioDouble == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El precio debe ser un número válido.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }

    if (precioDouble <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'El precio debe ser mayor a 0.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }

    return true; // Si pasa todas las validaciones
  }

  Widget editar(int index, Map<String, dynamic> producto) {
    // Inicializamos los controladores y la imagen localmente
    final nombreCtrl = TextEditingController(text: producto['nombre'] ?? '');
    final precioCtrl = TextEditingController(text: producto['precio'] ?? '');
    final cantidadCtrl = TextEditingController(
      text: producto['cantidad'] ?? '',
    );
    final categoriaCtrl = TextEditingController(
      text: producto['categoria'] ?? '',
    );
    Uint8List? imagenBytes = producto['imagenBytes'] as Uint8List?;

    final c = Colores();

    return StatefulBuilder(
      builder: (context, setModalState) {
        void clearFieldsLocal() {
          nombreCtrl.clear();
          precioCtrl.clear();
          cantidadCtrl.clear();
          categoriaCtrl.clear();
          setState(() {
            imagenBytes = null;
          });

          setModalState(() {});
        }

        bool verificacionesLocal() {
          if (nombreCtrl.text.isEmpty ||
              precioCtrl.text.isEmpty ||
              cantidadCtrl.text.isEmpty ||
              categoriaCtrl.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Por favor, completa todos los campos.',
                  style: TextStyle(color: c.textPrimary),
                ),
                backgroundColor: c.danger,
              ),
            );
            return false;
          }
          if (int.tryParse(cantidadCtrl.text) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'La cantidad debe ser un número válido.',
                  style: TextStyle(color: c.textPrimary),
                ),
                backgroundColor: c.danger,
              ),
            );
            return false;
          }
          if (double.tryParse(precioCtrl.text) == null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'El precio debe ser un número válido.',
                  style: TextStyle(color: c.textPrimary),
                ),
                backgroundColor: c.danger,
              ),
            );
            return false;
          }
          return true;
        }

        return CustomContainer(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              spacing: 20,
              children: [
                Row(
                  children: [
                    Text(
                      "Editar Producto",
                      style: TextStyle(
                        color: c.textPrimary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(Icons.close, color: c.textPrimary, size: 28),
                    ),
                  ],
                ),
                Row(
                  spacing: 16,
                  children: [
                    Expanded(
                      child: Column(
                        spacing: 16,
                        children: [
                          ImageSelector(
                            key: ValueKey(imagenBytes),
                            initialImageBytes: imagenBytes,
                            onImageSelected: (img) =>
                                setModalState(() => imagenBytes = img),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: c.warning,
                              padding: EdgeInsets.symmetric(
                                vertical: 14,
                                horizontal: 14,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            onPressed: () {
                              setModalState(() {
                                imagenBytes =
                                    null; // Limpiamos la imagen local del modal
                              });
                            },
                            label: Text(
                              'Borrar Imagen',
                              style: TextStyle(color: c.textPrimary),
                            ),
                            icon: Icon(
                              Icons.no_photography,
                              color: c.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        spacing: 12,
                        children: [
                          CustomTextField(
                            controller: nombreCtrl,
                            label: 'Nombre',
                            hint: 'Nombre del producto',
                          ),
                          CustomTextField(
                            controller: precioCtrl,
                            label: 'Precio',
                            hint: 'Precio',
                            keyboardType: TextInputType.number,
                          ),
                          CustomTextField(
                            controller: cantidadCtrl,
                            label: 'Cantidad',
                            hint: 'Cantidad',
                          ),
                          CustomTextField(
                            controller: categoriaCtrl,
                            label: 'Categoría',
                            hint: 'Categoría',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  spacing: 16,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: c.danger,
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        onPressed: clearFieldsLocal,
                        icon: Icon(
                          Icons.cleaning_services,
                          color: c.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: c.primaryGreen,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        onPressed: () {
                          if (verificacionesLocal()) {
                            ProductosDatos.current.actualizarProducto(index, {
                              'nombre': nombreCtrl.text,
                              'precio': precioCtrl.text,
                              'cantidad': cantidadCtrl.text,
                              'categoria': categoriaCtrl.text,
                              'imagenBytes': imagenBytes,
                            });
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          'Guardar',
                          style: TextStyle(fontSize: 18, color: c.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
