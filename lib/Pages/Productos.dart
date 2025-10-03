import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
