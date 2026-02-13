import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

class SyncService {
  // Patrón Singleton: permite acceder a la misma instancia desde cualquier sitio
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _boxName = 'pantry_box';

  // --- CONTROLADOR DEL ESTADO DE SINCRONIZACIÓN ---
  // true = cargando, false = terminado
  final _syncStatusController = StreamController<bool>.broadcast();
  Stream<bool> get isSyncingStream => _syncStatusController.stream;

  /// Sincroniza los datos locales hacia la nube (Firestore)
  Future<void> uploadPantryToCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Avisamos que la carga ha comenzado
      _syncStatusController.add(true);

      final box = Hive.box<ProductModel>(_boxName);
      final List<Map<String, dynamic>> productsJson = box.values
          .map((p) => p.toJson())
          .toList();

      await _firestore.collection('users').doc(user.uid).set({
        'pantry': productsJson,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print("☁️ Sincronización exitosa: Datos subidos a Firestore");

      // Esperamos un segundo extra para que el usuario vea el spinner/nube
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      print("❌ Error al subir datos a Firestore: $e");
    } finally {
      // Avisamos que ha terminado (vuelve el icono de check)
      _syncStatusController.add(false);
    }
  }

  /// Descarga los datos de la nube hacia el almacenamiento local (Hive)
  Future<void> downloadPantryFromCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      _syncStatusController.add(true);

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data.containsKey('pantry')) {
          final List<dynamic> remoteProducts = data['pantry'];
          final box = Hive.box<ProductModel>(_boxName);

          await box.clear();

          for (var item in remoteProducts) {
            final product = ProductModel.fromJson(
              Map<String, dynamic>.from(item),
            );
            await box.add(product);
          }
          print("📥 Sincronización exitosa: Datos descargados de Firestore");
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print("❌ Error al descargar datos de Firestore: $e");
    } finally {
      _syncStatusController.add(false);
    }
  }
}
