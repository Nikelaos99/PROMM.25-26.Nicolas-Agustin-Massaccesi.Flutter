import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

/// Service responsible for bidirectional data synchronization between local storage and the cloud.
///
/// This service implements the **Singleton Pattern** to ensure a single instance
/// handles all synchronization tasks, preventing race conditions. It connects
/// the local [Hive] database with [Firebase Firestore].
class SyncService {
  /// Singleton instance of [SyncService].
  static final SyncService _instance = SyncService._internal();

  /// Factory constructor to return the existing [_instance].
  factory SyncService() => _instance;

  /// Private internal constructor for the singleton pattern.
  SyncService._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _boxName = 'pantry_box';

  /// Controller to manage and broadcast the current synchronization status.
  ///
  /// Emits `true` when a process is running and `false` when it completes.
  final _syncStatusController = StreamController<bool>.broadcast();

  /// Public [Stream] to allow the UI to react to synchronization state changes.
  Stream<bool> get isSyncingStream => _syncStatusController.stream;

  /// Uploads all local pantry products to the user's private [Firestore] document.
  ///
  /// It transforms the [ProductModel] objects into JSON maps and stores them
  /// under the user's unique ID. It uses a merge strategy to preserve other
  /// document fields like metadata.
  ///
  /// Requires an authenticated user.
  Future<void> uploadPantryToCloud() async {
    final user = _auth.currentUser;
    if (user == null) return;

    try {
      // Signals the start of the synchronization process
      _syncStatusController.add(true);

      final box = Hive.box<ProductModel>(_boxName);
      final List<Map<String, dynamic>> productsJson = box.values
          .map((p) => p.toJson())
          .toList();

      // Updates Firestore document with the current pantry list and a server-side timestamp
      await _firestore.collection('users').doc(user.uid).set({
        'pantry': productsJson,
        'last_updated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Visual delay to ensure the UI feedback is perceptible to the user
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      // Internal logging for debugging purposes
      print("❌ Error uploading data to Firestore: $e");
    } finally {
      // Signals the end of the synchronization process
      _syncStatusController.add(false);
    }
  }

  /// Downloads pantry data from [Firestore] and replaces the local [Hive] content.
  ///
  /// This method performs a complete overwrite of the local database with
  /// the data retrieved from the cloud to ensure consistency across devices.
  ///
  /// Requires an authenticated user and an existing Firestore document.
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

          // Clears local database before importing cloud data
          await box.clear();

          for (var item in remoteProducts) {
            final product = ProductModel.fromJson(
              Map<String, dynamic>.from(item),
            );
            await box.add(product);
          }
        }
      }
      await Future.delayed(const Duration(milliseconds: 500));
    } catch (e) {
      print("❌ Error downloading data from Firestore: $e");
    } finally {
      _syncStatusController.add(false);
    }
  }
}
