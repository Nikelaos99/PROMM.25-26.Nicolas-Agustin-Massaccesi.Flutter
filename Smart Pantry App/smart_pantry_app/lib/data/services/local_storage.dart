import 'dart:convert';
import 'dart:io';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import '../models/product_model.dart';
import '../providers/hive_provider.dart';

class LocalStorageService {
  final HiveProvider _hiveProvider = HiveProvider();

  /// EXPORTAR: Genera el JSON y abre el menú compartir del móvil
  Future<void> exportProductsToFile() async {
    try {
      final products = _hiveProvider.getAllProducts();
      final List<Map<String, dynamic>> jsonData = products
          .map((p) => p.toJson())
          .toList();

      final String jsonString = jsonEncode(jsonData);

      // Crear archivo temporal para compartir
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/pantry_backup.json');
      await file.writeAsString(jsonString);

      // Abrir selector nativo para compartir (WhatsApp, Drive, Guardar en Archivos...)
      await Share.shareXFiles([
        XFile(file.path),
      ], subject: 'Backup de Mi Despensa Inteligente');
    } catch (e) {
      throw Exception("Error al exportar archivo: $e");
    }
  }

  /// IMPORTAR: Abre el selector de archivos y carga los datos en Hive
  /// Devuelve true si la importación fue exitosa
  Future<bool> importProductsFromFile({required bool replaceAll}) async {
    try {
      // 1. Seleccionar el archivo .json
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final String content = await file.readAsString();

        // 2. Decodificar JSON
        final List<dynamic> decodedData = jsonDecode(content);
        final box = Hive.box<ProductModel>(HiveProvider.boxName);

        // 3. Limpiar si el usuario eligió reemplazar
        if (replaceAll) {
          await box.clear();
        }

        // 4. Insertar productos
        for (var item in decodedData) {
          final product = ProductModel.fromJson(item as Map<String, dynamic>);

          // Opcional: Evitar duplicados exactos por código de barras si no es reemplazo
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
      throw Exception("Error al importar datos: $e");
    }
  }
}
