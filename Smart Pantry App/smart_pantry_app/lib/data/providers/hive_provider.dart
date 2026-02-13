import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

class HiveProvider {
  static const String boxName = 'pantry_box';

  // Añade un producto individual
  Future<void> addProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(boxName);
    await box.add(product);
  }

  // Retorna todos los productos como una lista
  List<ProductModel> getAllProducts() {
    final box = Hive.box<ProductModel>(boxName);
    return box.values.toList();
  }

  // Borra todo el contenido de la caja
  Future<void> clearAllProducts() async {
    final box = Hive.box<ProductModel>(boxName);
    await box.clear();
  }
}
