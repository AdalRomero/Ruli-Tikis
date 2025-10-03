import 'package:flutter/material.dart';
import 'package:the_man_who_sold_the_world/Pages/Clientes.dart';
import 'package:the_man_who_sold_the_world/Pages/Home.dart';
import 'package:the_man_who_sold_the_world/Pages/Productos.dart';
import 'package:the_man_who_sold_the_world/Pages/Ventas.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';

class NavigationController extends StatefulWidget {
  const NavigationController({super.key});

  @override
  State<NavigationController> createState() => _NavigationControllerState();
}

class _NavigationControllerState extends State<NavigationController> {
  int _selectedIndex = 1;

  final List<Widget> _screens = [Clientes(), Home(), Ventas(), Productos()];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  final c = Colores();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 40,
        unselectedIconTheme: IconThemeData(size: 34),
        selectedFontSize: 18,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: c.primaryGreen,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: c.textPrimary,
        unselectedItemColor: c.textSecondary,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add_alt_1_sharp),
            label: 'Clientes',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale),
            label: 'Ventas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2),
            label: 'Productos',
          ),
        ],
      ),
    );
  }
}
