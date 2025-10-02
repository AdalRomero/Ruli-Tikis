import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa la conexión con tu proyecto Supabase
  await initializeSupabase();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(body: Center(child: Text('Hello World!'))),
    );
  }
}

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
