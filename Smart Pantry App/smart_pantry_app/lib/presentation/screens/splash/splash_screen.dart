import 'package:flutter/material.dart';
import 'widgets/three_dots_loading.dart';

/// Initial entry screen displayed during application startup.
///
/// This screen provides a branded experience while the app performs background
/// initialization tasks, such as determining authentication status via [AuthWrapper]
/// or loading local databases.
class SplashScreen extends StatelessWidget {
  /// Creates a [SplashScreen] instance.
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00A67E),
      body: Center(
        // Ensures all content blocks are perfectly centered on the screen
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. Logo Branding: A white container holding the scaled pantry icon.
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

            // 2. Application Main Title
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

            // 3. Application Slogan for branding reinforcement
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

            // 4. Custom loading indicator to signal background activity
            const SizedBox(height: 20, child: ThreeDotsLoading()),
          ],
        ),
      ),
    );
  }
}
