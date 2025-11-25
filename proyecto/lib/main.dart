import 'package:flutter/material.dart';
import 'package:proyecto/routes/app_routes.dart';

void main() {
  runApp(const MiAplicacion());
}

class MiAplicacion extends StatefulWidget {
  const MiAplicacion({super.key});

  @override
  State<MiAplicacion> createState() => _MiAplicacionEstado();
}

class _MiAplicacionEstado extends State<MiAplicacion> {
  ThemeMode _modoTema = ThemeMode.light;

  void _cambiarTema(bool activarOscuro) {
    setState(() {
      _modoTema = activarOscuro ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Proyecto',
      debugShowCheckedModeBanner: false,

      // 🎨 Tema claro con AppBar azulada
      theme: ThemeData.light().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue, // 👈 fuerza azul en ThemeLight
          foregroundColor: Colors.white, // texto e íconos en blanco
        ),
      ),

      // 🌑 Tema oscuro (puedes personalizar también si quieres)
      darkTheme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.grey, // AppBar oscura
          foregroundColor: Colors.white,
        ),
      ),

      themeMode: _modoTema,
      initialRoute: AppRoutes.splash,
      routes: AppRoutes.obtenerRutas(_cambiarTema, _modoTema),
    );
  }
}
