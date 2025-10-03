import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';

class Ventas extends StatefulWidget {
  const Ventas({super.key});

  @override
  State<Ventas> createState() => _VentasState();
}

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
        child: Center(
          child: SingleChildScrollView(
            child: Column(children: const [Text('Welcome to the Home Page!')]),
          ),
        ),
      ),
    );
  }
}
