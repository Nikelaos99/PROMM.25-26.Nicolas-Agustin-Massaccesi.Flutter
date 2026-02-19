import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:smart_pantry_app/presentation/screens/home/home_screen.dart';
import '../splash/splash_screen.dart';
import 'auth_screen.dart';

/// A root-level widget that manages the application's navigation state based
/// on the user's authentication status.
///
/// This widget acts as a router that listens to [FirebaseAuth] state changes.
/// It automatically switches between the [HomeScreen] and [AuthScreen]
/// without requiring manual navigation logic.
class AuthWrapper extends StatelessWidget {
  /// Creates an [AuthWrapper] widget.
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      // Listens to the real-time stream of authentication state changes
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // 1. Handle the initialization phase
        // While Firebase is determining the auth state, show the Splash Screen
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SplashScreen();
        }

        // 2. Handle the authenticated state
        // If the snapshot has user data, the user is logged in
        if (snapshot.hasData) {
          return const HomeScreen();
        }

        // 3. Handle the unauthenticated state
        // If no user is found, redirect to the Login/Registration screen
        return const AuthScreen();
      },
    );
  }
}
