import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/textField.dart';
import 'package:the_man_who_sold_the_world/Code/ClientesDatos.dart';

class Clientes extends StatefulWidget {
  const Clientes({super.key});

  @override
  State<Clientes> createState() => _ClientesState();
}

TextEditingController nombre = TextEditingController();
TextEditingController ciudad = TextEditingController();
TextEditingController edad = TextEditingController();
TextEditingController sexo = TextEditingController();
String? selectedSexo;
//--------------------------------------------------------------
TextEditingController nombreEdit = TextEditingController();
TextEditingController ciudadEdit = TextEditingController();
TextEditingController edadEdit = TextEditingController();
TextEditingController sexoEdit = TextEditingController();
String? selectedSexoEdit;
//--------------------------------------------------------------
TextEditingController buscador = TextEditingController();

final c = Colores();
bool buttonPressed = false;

class _ClientesState extends State<Clientes> {
  @override
  void initState() {
    super.initState();
  }

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
                        'Agregar Cliente',
                        style: TextStyle(fontSize: 22, color: c.textPrimary),
                      ),
                      icon: Icon(
                        Icons.group_add,
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
                                  "Registrar Cliente",
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
                            CustomTextField(
                              controller: nombre,
                              label: 'Nombre',
                              hint: 'Ingresa el nombre de cliente',
                              prefixIcon: Icons.person,
                            ),
                            CustomTextField(
                              controller: ciudad,
                              label: 'Ciudad',
                              hint: 'Ingresa el nombre de la ciudad',
                              prefixIcon: Icons.location_city,
                            ),
                            CustomTextField(
                              controller: edad,
                              label: 'Edad',
                              hint: 'Ingresa la edad del cliente',
                              prefixIcon: Icons.calendar_month,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {
                                final sanitized = value.replaceAll(
                                  RegExp(r'[^0-9]'),
                                  '',
                                );
                                edad.text = sanitized;
                                edad.selection = TextSelection.fromPosition(
                                  TextPosition(offset: edad.text.length),
                                );
                              },
                            ),
                            DropdownButtonFormField<String>(
                              value: selectedSexo, // inicialmente null
                              dropdownColor: c.surfaceDark,
                              style: TextStyle(color: c.textPrimary),
                              decoration: InputDecoration(
                                icon: Icon(Icons.wc, color: c.textPrimary),
                                labelText: 'Sexo',
                                labelStyle: TextStyle(color: c.textPrimary),
                                filled: true,
                                fillColor: c.backgroundDark,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              hint: Text(
                                'Selecciona el sexo',
                                style: TextStyle(
                                  color: c.textPrimary,
                                  fontSize: 18,
                                ),
                              ), // 🔹 placeholder visible solo en el campo
                              items: ['Masculino', 'Femenino', 'Otro']
                                  .map(
                                    (sexo) => DropdownMenuItem(
                                      value: sexo,
                                      child: Text(
                                        sexo,
                                        style: TextStyle(
                                          color: c.textPrimary,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (val) {
                                selectedSexo = val;
                                setState(() {
                                  sexo.text = val ?? '';
                                });
                              },
                            ),
                            Row(
                              spacing: 16,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: c.danger, // 🔹 color de fondo
                                    shape:
                                        BoxShape.circle, // hace que sea redondo
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      clearFields();
                                    },
                                    icon: Icon(
                                      Icons.cleaning_services,
                                      color: c.textPrimary,
                                    ),
                                    splashRadius: 24,
                                    tooltip: 'Limpiar',
                                  ),
                                ),
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
                                          Clientesdatos.current.agregarCliente({
                                            'nombre': nombre.text,
                                            'ciudad': ciudad.text,
                                            'edad': edad.text,
                                            'sexo': sexo.text,
                                          });
                                          print(Clientesdatos.current.clientes);
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
                    Clientesdatos.current.clientes.isEmpty,
                  ).toDouble(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 20,
                        children: [
                          Text(
                            "Clientes Registrados",
                            style: TextStyle(
                              color: c.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          if (Clientesdatos.current.clientes.isNotEmpty) ...[
                            CustomTextField(
                              controller: buscador,
                              label: 'Buscar',
                              hint: 'Nombre, ciudad, edad...',
                              prefixIcon: Icons.search,
                              onChanged: (value) {
                                setState(() {
                                  Clientesdatos.current.filtro = value;
                                });
                              },
                            ),
                          ],

                          if (Clientesdatos.current.clientes.isEmpty) ...[
                            Text(
                              "No hay clientes registrados.",
                              style: TextStyle(color: c.textSecondary),
                            ),
                          ] else ...[
                            AnimatedBuilder(
                              animation: Clientesdatos.current,
                              builder: (__, _) {
                                return ListView.builder(
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemCount: Clientesdatos
                                      .current
                                      .clientesFiltrados
                                      .length,
                                  itemBuilder: (context, index) {
                                    final cliente = Clientesdatos
                                        .current
                                        .clientesFiltrados[index];
                                    return ListTile(
                                      leading: Icon(
                                        Icons.person,
                                        color: c.textPrimary,
                                      ),
                                      title: Text(
                                        cliente['nombre'] ?? '',
                                        style: TextStyle(color: c.textPrimary),
                                      ),
                                      subtitle: Text(
                                        'Ciudad: ${cliente['ciudad']}, Edad: ${cliente['edad']}, Sexo: ${cliente['sexo']}',
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
                                                      Clientesdatos
                                                          .current
                                                          .clientesFiltrados[index],
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
                                                  Clientesdatos.current.clientes
                                                      .indexOf(cliente);
                                              Clientesdatos.current
                                                  .eliminarCliente(
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

  void clearFields() {
    nombre.clear();
    ciudad.clear();
    edad.clear();
    sexo.clear();
    selectedSexo = null;
  }

  void clearFieldsEdit() {
    nombreEdit.clear();
    ciudadEdit.clear();
    edadEdit.clear();
    sexoEdit.clear();
    selectedSexoEdit = null;
  }

  bool verificacionesEdit() {
    if (nombreEdit.text.isEmpty ||
        ciudadEdit.text.isEmpty ||
        edadEdit.text.isEmpty ||
        sexoEdit.text.isEmpty) {
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

    // Validar que edad sea un número entero
    final edadInt = int.tryParse(edadEdit.text);
    if (edadInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La edad debe ser un número entero válido.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }
    if (edadInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La edad debe ser mayor a 0.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }

    return true; // Si pasa todas las validaciones
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

  bool verificaciones() {
    if (nombre.text.isEmpty ||
        ciudad.text.isEmpty ||
        edad.text.isEmpty ||
        sexo.text.isEmpty) {
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

    // Validar que edad sea un número entero
    final edadInt = int.tryParse(edad.text);
    if (edadInt == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La edad debe ser un número entero válido.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }
    if (edadInt <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'La edad debe ser mayor a 0.',
            style: TextStyle(color: c.textPrimary),
          ),
          backgroundColor: c.danger,
        ),
      );
      return false;
    }

    return true; // Si pasa todas las validaciones
  }

  Widget editar(int index, Map<String, dynamic> cliente) {
    // Pre-cargar los campos con los datos actuales del cliente
    // Precargar los campos después de que el widget se haya construido
    WidgetsBinding.instance.addPostFrameCallback((_) {
      nombreEdit.text = cliente['nombre'] ?? '';
      ciudadEdit.text = cliente['ciudad'] ?? '';
      edadEdit.text = cliente['edad'] ?? '';
      sexoEdit.text = cliente['sexo'] ?? '';
      selectedSexoEdit = sexoEdit.text;
    });
    return Center(
      child: CustomContainer(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            spacing: 20,
            children: [
              Row(
                children: [
                  Text(
                    "Editar Cliente",
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
                        Navigator.pop(context);
                      });
                    },
                    icon: Icon(Icons.close, color: c.textPrimary, size: 28),
                  ),
                ],
              ),
              CustomTextField(
                controller: nombreEdit,
                label: 'Nombre',
                hint: 'Ingresa el nombre de cliente',
                prefixIcon: Icons.person,
              ),
              CustomTextField(
                controller: ciudadEdit,
                label: 'Ciudad',
                hint: 'Ingresa el nombre de la ciudad',
                prefixIcon: Icons.location_city,
              ),
              CustomTextField(
                controller: edadEdit,
                label: 'Edad',
                hint: 'Ingresa la edad del cliente',
                prefixIcon: Icons.calendar_month,
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  final sanitized = value.replaceAll(RegExp(r'[^0-9]'), '');
                  edadEdit.text = sanitized;
                  edadEdit.selection = TextSelection.fromPosition(
                    TextPosition(offset: edadEdit.text.length),
                  );
                },
              ),
              DropdownButtonFormField<String>(
                value: selectedSexoEdit, // inicialmente null
                dropdownColor: c.surfaceDark,
                style: TextStyle(color: c.textPrimary),
                decoration: InputDecoration(
                  icon: Icon(Icons.wc, color: c.textPrimary),
                  labelText: 'Sexo',
                  labelStyle: TextStyle(color: c.textPrimary),
                  filled: true,
                  fillColor: c.backgroundDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                hint: Text(
                  'Selecciona el sexo',
                  style: TextStyle(color: c.textPrimary, fontSize: 18),
                ), // 🔹 placeholder visible solo en el campo
                items: ['Masculino', 'Femenino', 'Otro']
                    .map(
                      (sexo) => DropdownMenuItem(
                        value: sexo,
                        child: Text(
                          sexo,
                          style: TextStyle(color: c.textPrimary, fontSize: 18),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: (val) {
                  selectedSexoEdit = val;
                  setState(() {
                    sexoEdit.text = val ?? '';
                  });
                },
              ),
              Row(
                spacing: 16,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: c.danger, // 🔹 color de fondo
                      shape: BoxShape.circle, // hace que sea redondo
                    ),
                    child: IconButton(
                      onPressed: () {
                        clearFieldsEdit();
                      },
                      icon: Icon(Icons.cleaning_services, color: c.textPrimary),
                      splashRadius: 24,
                      tooltip: 'Limpiar',
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: c.primaryGreen,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      onPressed: () {
                        if (verificacionesEdit()) {
                          setState(() {
                            Clientesdatos.current.actualizarCliente(
                              index, // 🔹 índice del cliente a editar
                              {
                                'nombre': nombreEdit.text,
                                'ciudad': ciudadEdit.text,
                                'edad': edadEdit.text,
                                'sexo': sexoEdit.text,
                              },
                            );
                            print(Clientesdatos.current.clientes);

                            clearFieldsEdit();
                            Navigator.pop(context); // cerrar modal al guardar
                          });
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
      ),
    );
  }
}
