import 'package:hive_flutter/hive_flutter.dart';
import '../models/product_model.dart';

/// Provider class that abstracts [Hive] operations for the pantry box.
///
/// This class serves as the direct interface between the application logic
/// and the local NoSQL database, centralizing all CRUD (Create, Read, Update, Delete)
/// operations related to [ProductModel].
class HiveProvider {
  /// The unique identifier for the Hive box where products are stored.
  static const String boxName = 'pantry_box';

  /// Persists a single [ProductModel] instance into the local storage.
  ///
  /// This method retrieves the opened box and appends the new product.
  /// Use this when adding items via manual entry or barcode scanning.
  Future<void> addProduct(ProductModel product) async {
    final box = Hive.box<ProductModel>(boxName);
    await box.add(product);
  }

  /// Retrieves all stored products as a synchronous [List].
  ///
  /// Since Hive keeps data in memory for fast access, this operation is
  /// efficient and provides a snapshot of the current inventory.
  List<ProductModel> getAllProducts() {
    final box = Hive.box<ProductModel>(boxName);
    return box.values.toList();
  }

  /// Removes all entries from the pantry box.
  ///
  /// This is a destructive operation typically used during a full data reset
  /// or when the user chooses to "Replace All" during a JSON import.
  Future<void> clearAllProducts() async {
    final box = Hive.box<ProductModel>(boxName);
    await box.clear();
  }
}
