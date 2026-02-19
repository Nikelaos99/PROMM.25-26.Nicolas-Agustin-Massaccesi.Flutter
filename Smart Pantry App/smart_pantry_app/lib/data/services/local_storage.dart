import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';
import '../providers/hive_provider.dart';

/// Service class dedicated to handling file-based input/output operations.
///
/// This service facilitates data portability by allowing users to export their
/// local [Hive] database into a shared JSON file and import records from
/// existing backups.
class LocalStorageService {
  /// Internal instance of [HiveProvider] to access the local data store.
  final HiveProvider _hiveProvider = HiveProvider();

  /// Exports the current inventory state into a JSON file and triggers the
  /// native system share sheet.
  ///
  /// This method maps all [ProductModel] objects to JSON, writes them to a
  /// temporary file in the device's cache directory, and invokes the [Share]
  /// plugin to allow distribution via third-party apps (Email, Drive, etc.).
  ///
  /// Throws an [Exception] if the file system access or sharing fails.
  Future<void> exportProductsToFile() async {
    try {
      final products = _hiveProvider.getAllProducts();
      final List<Map<String, dynamic>> jsonData = products
          .map((p) => p.toJson())
          .toList();

      final String jsonString = jsonEncode(jsonData);

      // Create a temporary file in the system cache directory
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/pantry_backup.json');
      await file.writeAsString(jsonString);

      // Open the native share UI for the generated .json file
      await Share.shareXFiles([
        XFile(file.path),
      ], subject: 'Backup de Mi Despensa Inteligente');
    } catch (e) {
      throw Exception("Error exporting file: $e");
    }
  }

  /// Opens the native file picker to select a JSON backup and restores the data.
  ///
  /// The [replaceAll] parameter determines the restoration strategy:
  /// * If `true`: Wipes the existing database before importing new records.
  /// * If `false`: Merges new records, skipping items with existing barcodes.
  ///
  /// Returns `true` if the process completes successfully, or `false` if the
  /// user cancels the file selection.
  ///
  /// Throws an [Exception] if the JSON structure is invalid or file reading fails.
  Future<bool> importProductsFromFile({required bool replaceAll}) async {
    try {
      // 1. Invoke file picker for .json extension only
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final String content = await file.readAsString();

        // 2. Parse the JSON string into a dynamic list
        final List<dynamic> decodedData = jsonDecode(content);
        final box = Hive.box<ProductModel>(HiveProvider.boxName);

        // 3. Clear existing data if full replacement is requested
        if (replaceAll) {
          await box.clear();
        }

        // 4. Iterate and insert products into the local box
        for (var item in decodedData) {
          final product = ProductModel.fromJson(item as Map<String, dynamic>);

          // Basic deduplication logic: skip if barcode already exists in merge mode
          if (!replaceAll) {
            bool exists = box.values.any((p) => p.barcode == product.barcode);
            if (exists) continue;
          }

          await box.add(product);
        }
        return true;
      }
      return false;
    } catch (e) {
      throw Exception("Error importing data: $e");
    }
  }
}
