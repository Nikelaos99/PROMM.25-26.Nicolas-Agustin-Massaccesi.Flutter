import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'presentation/screens/auth/auth_screen.dart';

void main() async {
  // 1. Asegurar que los bindings de Flutter estén listos
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Inicializar Firebase
  // Nota: Requiere haber configurado el archivo google-services.json (Android)
  // o GoogleService-Info.plist (iOS) vía FlutterFire CLI.
  await Firebase.initializeApp();

  // 3. Inicializar Hive para Flutter
  await Hive.initFlutter();

  // 4. Abrir tu primera "caja" de datos para la despensa
  await Hive.openBox('settings'); // Para configuraciones básicas
  await Hive.openBox('products_box'); // Donde guardaremos el inventario

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pantry App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const AuthScreen(),
    );
  }
}
