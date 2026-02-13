import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 0)
class ProductModel extends HiveObject {
  @HiveField(0)
  final String barcode;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? brand;

  @HiveField(3)
  final String? imageUrl;

  @HiveField(4)
  final DateTime dateAdded;

  @HiveField(5)
  int quantity;

  @HiveField(6)
  String? category;

  @HiveField(7)
  DateTime? expiryDate;

  @HiveField(8)
  String? notes;

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

  // Convierte el objeto a un Mapa para exportación JSON
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

  // Crea una instancia desde un Mapa JSON para importación
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
