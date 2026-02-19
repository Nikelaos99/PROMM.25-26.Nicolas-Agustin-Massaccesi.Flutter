import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Service that interacts with the OpenFoodFacts API to retrieve product details.
///
/// This service handles the network logic to fetch information based on
/// barcodes, providing a bridge between the physical product and the
/// application's data model.
class FoodApiService {
  /// The base endpoint for the OpenFoodFacts V2 API.
  static const String _baseUrl =
      "https://world.openfoodfacts.org/api/v2/product";

  /// Fetches product data from the external API using a [barcode].
  ///
  /// Requests the information in Spanish (`lc=es`) and optimizes the
  /// response by filtering only the necessary fields: `product_name`,
  /// `brands`, `image_url`, `categories`, and `code`.
  ///
  /// Returns a [Map] containing the product data if found,
  /// or `null` if the product does not exist or a network error occurs.
  Future<Map<String, dynamic>?> fetchProductByBarcode(String barcode) async {
    try {
      // Construction of the optimized query URL
      final url = Uri.parse(
        "$_baseUrl/$barcode.json?lc=es&fields=product_name,brands,image_url,categories,code",
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Status 1 indicates the product was successfully located in the database
        if (data['status'] == 1 && data['product'] != null) {
          debugPrint("✅ Product found: ${data['product']['product_name']}");
          return data['product'];
        } else {
          debugPrint("⚠️ Product not found in OpenFoodFacts (Status 0)");
        }
      } else {
        debugPrint("❌ Server error: Code ${response.statusCode}");
      }
      return null;
    } catch (e) {
      // debugPrint is used to keep production logs clean
      debugPrint("❌ Error in FoodApiService: $e");
      return null;
    }
  }
}
