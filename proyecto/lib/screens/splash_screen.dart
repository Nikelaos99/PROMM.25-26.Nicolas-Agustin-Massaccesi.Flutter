import 'package:flutter/material.dart';
import 'package:proyecto/routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    // Espera 3 segundos y navega al home_screen
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detecta si el tema es oscuro o claro
    final bool esOscuro = Theme.of(context).brightness == Brightness.dark;

    // Fondo azul en claro, negro en oscuro
    final Color fondo = esOscuro ? Colors.black : Colors.blue;

    // Texto blanco en ambos casos (para contraste)
    final Color textoColor = Colors.white;

    return Scaffold(
      backgroundColor: fondo, // Fondo dinámico
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo o imagen decorativa
            Container(
              width: 120,
              height: 120,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage('assets/images/instagram/retrato.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // ✨ Texto con estilo
            Text(
              "Bienvenido/a",
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: textoColor, // texto dinámico
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 10),

            // Animación decorativa con CircularProgressIndicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(textoColor),
            ),
          ],
        ),
      ),
    );
  }
}
