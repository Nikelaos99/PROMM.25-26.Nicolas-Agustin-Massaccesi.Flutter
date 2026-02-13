// lib/presentation/screens/splash/splash_screen.dart
import 'package:flutter/material.dart';
import 'widgets/three_dots_loading.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00A67E),
      body: Center(
        // Asegura que todo el bloque de contenido esté perfectamente centrado
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Logo: Contenedor blanco con bolsa escalada
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Transform.scale(
                scale: 1.8,
                child: Image.asset(
                  'assets/images/icon_pantry.png',
                  color: const Color(0xFF00A67E),
                  fit: BoxFit.contain,
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 2. Título Principal
            const Text(
              "Smart Pantry App",
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              ),
            ),

            const SizedBox(height: 12),

            // 3. Eslogan (Añadido)
            const Text(
              "Gestiona tu despensa inteligentemente",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
            ),

            const SizedBox(height: 50),

            // 4. Animación de tres puntos
            const SizedBox(height: 20, child: ThreeDotsLoading()),
          ],
        ),
      ),
    );
  }
}
