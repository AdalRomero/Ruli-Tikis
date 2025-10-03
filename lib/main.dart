import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_man_who_sold_the_world/Pages/Home.dart';
import 'package:the_man_who_sold_the_world/Plugins/navegacion._controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la conexión con tu proyecto Supabase
  await initializeSupabase();

  runApp(const Configuration());
}

// Función para inicializar Supabase
Future<void> initializeSupabase() async {
  try {
    await Supabase.initialize(
      url: 'https://frvfszgxacbdzhbfowvw.supabase.co', // 🔹 URL de tu proyecto
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZydmZzemd4YWNiZHpoYmZvd3Z3Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTk0MjE1MzAsImV4cCI6MjA3NDk5NzUzMH0.Bzxa1tl_ABmijTvoIewTzJnR-j4jjsPyM93e27A3AEs', // 🔹 API key pública (anon key)
    );
    print("Conexión con Supabase inicializada");
  } catch (e) {
    print(e);
  }
}

//Configuracion de la aplicacion
class Configuration extends StatelessWidget {
  const Configuration({super.key});

  @override
  Widget build(BuildContext context) {
    Widget app = MaterialApp(
      title: 'Man Who Sold The World',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const NavigationController(),
      routes: {'/home': (context) => const Home()},
    );

    // Solo para desarrollo: fuerza el tamaño de la pantalla
    return Center(child: SizedBox(width: 480, height: 1600, child: app));
  }
}
