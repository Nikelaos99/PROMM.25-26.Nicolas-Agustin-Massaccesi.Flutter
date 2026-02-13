import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_pantry_app/presentation/screens/home/home_screen.dart';
import '../splash/splash_screen.dart';
import 'auth_screen.dart'; // Tu pantalla donde está el login

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Mientras Firebase inicializa
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // Si el usuario ya está logueado
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // Si no está logueado
        return const AuthScreen();
      },
    );
  }
}
