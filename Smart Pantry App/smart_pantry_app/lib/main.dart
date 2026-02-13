import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // <--- Añadido para los settings
import 'package:hive_flutter/hive_flutter.dart';

// Importaciones de tu proyecto
import 'firebase_options.dart';
import 'presentation/screens/auth/auth_wrapper.dart';
import 'core/theme/app_theme.dart';
import 'data/models/product_model.dart';
import 'data/services/sync_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Inicializar Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("🔥 Firebase inicializado correctamente");

  // Configuración de persistencia de Firestore
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  print("📊 Firestore: Persistencia activada");

  // 2. Inicializar Hive
  await Hive.initFlutter();
  print("📦 Hive: Inicializado");

  // 3. Registrar Adaptadores
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(ProductModelAdapter());
    print("🛠️ Hive: Adaptador ProductModel registrado");
  }

  // 4. Abrir las cajas (Boxes)
  await Hive.openBox('settings');
  await Hive.openBox<ProductModel>('pantry_box');
  print("📂 Hive: Cajas abiertas correctamente");

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final SyncService _syncService = SyncService();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    print("👀 App Observer: Registrado (Vigilando ciclo de vida)");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // --- LÓGICA DE SINCRONIZACIÓN AUTOMÁTICA ---
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("📱 Estado de la App: $state");

    if (state == AppLifecycleState.paused) {
      print("📤 App en segundo plano: Iniciando sincronización de subida...");
      _syncService.uploadPantryToCloud();
    } else if (state == AppLifecycleState.resumed) {
      print(
        "📥 App en primer plano: Comprobando actualizaciones en la nube...",
      );
      _syncService.downloadPantryFromCloud();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Pantry App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AuthWrapper(),
    );
  }
}
