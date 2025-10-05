import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:the_man_who_sold_the_world/Plugins/Colores.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/Containers.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/appBar.dart';
import 'package:the_man_who_sold_the_world/Plugins/Widgets/textField.dart';

class InicioSeccion extends StatefulWidget {
  const InicioSeccion({super.key});

  @override
  State<InicioSeccion> createState() => _InicioSeccionState();
}

TextEditingController nombre = TextEditingController();
TextEditingController password = TextEditingController();

final c = Colores();

class _InicioSeccionState extends State<InicioSeccion> {
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
            padding: const EdgeInsets.only(
              left: 20.0,
              right: 20.0,
              top: 28.0,
              bottom: 28.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 20,
              children: [
                CustomContainer(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 20,
                      children: [
                        Text(
                          'Bienvenido a Leo & Chilanguitos',
                          style: TextStyle(
                            color: c.textPrimary,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        CustomTextField(
                          controller: nombre,
                          label: 'Usuario',
                          hint: 'Ingresa el nombre de usuario',
                          prefixIcon: Icons.account_circle,
                        ),
                        CustomTextField(
                          controller: password,
                          label: 'Contraseña',
                          hint: 'Ingresa la contraseña',
                          prefixIcon: Icons.lock,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 2),

                TextButton.icon(
                  onPressed: () => signIn(context),
                  label: Text(
                    'Iniciar Sección',
                    style: TextStyle(fontSize: 22, color: c.textPrimary),
                  ),
                  icon: Icon(
                    Icons.sensor_occupied_rounded,
                    color: c.textPrimary,
                    size: 40,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: c.primaryGreen,
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
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
}

final supabase = Supabase.instance.client;

Future<void> signIn(BuildContext context) async {
  // Mostrar el pop-up de cargando
  showDialog(
    context: context,
    barrierDismissible: false, // no se puede cerrar tocando afuera
    builder: (context) {
      return const Center(child: CircularProgressIndicator());
    },
  );

  try {
    final supabase = Supabase.instance.client;
    final response = await supabase.auth.signInWithPassword(
      email: nombre.text.trim(),
      password: password.text.trim(),
    );

    Navigator.pop(context); // cerrar el loading

    if (response.session != null) {
      // ✅ Login correcto → mostrar check
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          icon: Icon(Icons.check_circle, color: Colors.green, size: 48),
          title: Text("Éxito"),
          content: Text("Sesión iniciada correctamente"),
        ),
      );

      if (context.mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      // ❌ Error → mostrar error
      await showDialog(
        context: context,
        builder: (_) => const AlertDialog(
          icon: Icon(Icons.error, color: Colors.red, size: 48),
          title: Text("Error"),
          content: Text("Credenciales incorrectas"),
        ),
      );
    }
  } catch (e) {
    Navigator.pop(context); // cerrar el loading si hubo error
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        icon: const Icon(Icons.error, color: Colors.red, size: 48),
        title: const Text("Error"),
        content: Text("Ocurrió un error: $e"),
      ),
    );
  }
}
