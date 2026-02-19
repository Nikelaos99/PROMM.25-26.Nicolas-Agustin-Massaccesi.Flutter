import 'package:hive/hive.dart';

part 'product_model.g.dart';

/// Data model representing a product within the pantry inventory.
///
/// This class uses [Hive] for local persistence, allowing objects to be
/// stored in a NoSQL box. It includes essential information such as
/// tracking for expiration dates, quantities, and barcode identification.
@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  /// Unique barcode identifier for the product (EAN/UPC).
  @HiveField(0)
  final String barcode;

  /// The descriptive name of the product.
  @HiveField(1)
  final String name;

  /// Optional brand name of the product.
  @HiveField(2)
  final String? brand;

  /// Optional URL pointing to the product's image.
  @HiveField(3)
  final String? imageUrl;

  /// The timestamp indicating when the product was first added to the pantry.
  @HiveField(4)
  final DateTime dateAdded;

  /// Current stock quantity of the product.
  @HiveField(5)
  int quantity;

  /// Categorization label for organization (e.g., "Dairy", "Grains").
  @HiveField(6)
  String? category;

  /// Optional expiration date used for tracking food safety and alerts.
  @HiveField(7)
  DateTime? expiryDate;

  /// User-defined notes or descriptions for the specific item.
  @HiveField(8)
  String? notes;

  /// Default constructor for [ProductModel].
  ProductModel({
    required this.barcode,
    required this.name,
    this.brand,
    this.imageUrl,
    required this.dateAdded,
    this.quantity = 1,
    this.category = "General",
    this.expiryDate,
    this.notes,
  });

  /// Creates a copy of the current [ProductModel] with specific fields updated.
  ///
  /// This implementation follows the prototype pattern to handle immutable
  /// updates within the application state.
  ProductModel copyWith({
    String? barcode,
    String? name,
    String? brand,
    String? imageUrl,
    DateTime? dateAdded,
    int? quantity,
    String? category,
    DateTime? expiryDate,
    String? notes,
  }) {
    return ProductModel(
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      brand: brand ?? this.brand,
      imageUrl: imageUrl ?? this.imageUrl,
      dateAdded: dateAdded ?? this.dateAdded,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      expiryDate: expiryDate ?? this.expiryDate,
      notes: notes ?? this.notes,
    );
  }

  /// Converts the [ProductModel] instance into a [Map] for JSON serialization.
  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'name': name,
    'brand': brand,
    'imageUrl': imageUrl,
    'dateAdded': dateAdded.toIso8601String(),
    'quantity': quantity,
    'category': category,
    'expiryDate': expiryDate?.toIso8601String(),
    'notes': notes,
  };

  /// Creates a [ProductModel] instance from a JSON [Map].
  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    barcode: json['barcode'],
    name: json['name'],
    brand: json['brand'],
    imageUrl: json['imageUrl'],
    dateAdded: DateTime.parse(json['dateAdded']),
    quantity: json['quantity'] ?? 1,
    category: json['category'] ?? "General",
    expiryDate: json['expiryDate'] != null
        ? DateTime.parse(json['expiryDate'])
        : null,
    notes: json['notes'],
  );
}
