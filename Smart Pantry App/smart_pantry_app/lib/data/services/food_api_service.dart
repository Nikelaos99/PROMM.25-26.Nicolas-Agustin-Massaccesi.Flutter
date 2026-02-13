import 'dart:convert';
import 'package:flutter/foundation.dart'; // Para debugPrint
import 'package:http/http.dart' as http;

class FoodApiService {
  // Usamos el dominio principal para máxima compatibilidad con el XML de seguridad
  static const String _baseUrl =
      "https://world.openfoodfacts.org/api/v2/product";

  Future<Map<String, dynamic>?> fetchProductByBarcode(String barcode) async {
    try {
      // 1. barcode: El código que recibimos.
      // 2. lc=es: Solicitamos que los nombres y categorías vengan en español.
      // 3. fields: Optimizamos la descarga pidiendo solo lo necesario para el ProductModel.
      final url = Uri.parse(
        "$_baseUrl/$barcode.json?lc=es&fields=product_name,brands,image_url,categories,code",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Status 1 = Producto encontrado en la base de datos de OpenFoodFacts
        if (data['status'] == 1 && data['product'] != null) {
          debugPrint(
            "✅ Producto encontrado: ${data['product']['product_name']}",
          );
          return data['product'];
        } else {
          debugPrint("⚠️ Producto no encontrado en OpenFoodFacts (Status 0)");
        }
      } else {
        debugPrint("❌ Error de servidor: Código ${response.statusCode}");
      }
      return null;
    } catch (e) {
      // debugPrint evita que los logs se filtren en versiones de producción
      debugPrint("❌ Error en FoodApiService: $e");
      return null;
    }
  }
}
