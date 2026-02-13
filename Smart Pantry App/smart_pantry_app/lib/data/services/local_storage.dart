import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';
import '../providers/hive_provider.dart';

class LocalStorageService {
  final HiveProvider _hiveProvider = HiveProvider();

  // Genera el String JSON a partir de los datos actuales de Hive
  Future<String> exportProductsToJson() async {
    try {
      final products = _hiveProvider.getAllProducts();
      final List<Map<String, dynamic>> jsonData = products
          .map((p) => p.toJson())
          .toList();

      return jsonEncode(jsonData);
    } catch (e) {
      throw Exception("Error al procesar datos para exportar: $e");
    }
  }

  // Importa datos desde un String JSON
  // replaceAll: true borra lo actual, false añade a lo existente
  Future<void> importProductsFromJson(
    String jsonString, {
    required bool replaceAll,
  }) async {
    try {
      final List<dynamic> decodedData = jsonDecode(jsonString);
      final box = Hive.box<ProductModel>(HiveProvider.boxName);

      if (replaceAll) {
        await box.clear();
      }

      for (var item in decodedData) {
        final product = ProductModel.fromJson(item as Map<String, dynamic>);
        // Usamos add para generar una nueva clave de Hive automáticamente
        await box.add(product);
      }
    } catch (e) {
      throw Exception("Error al importar datos: $e");
    }
  }
}
