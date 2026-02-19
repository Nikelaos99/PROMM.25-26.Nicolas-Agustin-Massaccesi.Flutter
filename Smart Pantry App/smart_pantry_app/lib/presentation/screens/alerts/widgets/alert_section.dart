import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';

/// A specialized UI section that groups products based on a specific alert type.
///
/// It displays a titled container with an icon and a list of cards representing
/// products that fall under categories like "Expired", "Low Stock", etc.
class AlertSection extends StatelessWidget {
  /// The title of the alert section (e.g., "Productos Caducados").
  final String title;

  /// Icon representing the nature of the alert.
  final IconData icon;

  /// Background color of the main container.
  final Color bgColor;

  /// Main color for text and icons to ensure contrast.
  final Color contentColor;

  /// The list of products to be displayed in this section.
  final List<ProductModel> products;

  /// A function that generates the specific status text for each product.
  final String Function(ProductModel) subtitleBuilder;

  const AlertSection({
    super.key,
    required this.title,
    required this.icon,
    required this.bgColor,
    required this.contentColor,
    required this.products,
    required this.subtitleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: contentColor.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          // HEADER ROW: Icon and Title
          Row(
            children: [
              Icon(icon, color: contentColor, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // PRODUCT LIST
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return _buildProductAlertCard(p);
            },
          ),
        ],
      ),
    );
  }

  /// Builds an individual card for a product within the alert section.
  Widget _buildProductAlertCard(ProductModel p) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: ListTile(
          leading: _buildProductThumbnail(p.imageUrl),
          title: Text(
            p.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF004D40),
            ),
          ),
          subtitle: Text(
            "Categoría: ${p.category ?? 'Sin categoría'} | Cantidad: ${p.quantity.toInt()}",
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          trailing: _buildTrailingInfo(p),
        ),
      ),
    );
  }

  /// Builds a small thumbnail for the product with error handling.
  Widget _buildProductThumbnail(String? imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: (imageUrl != null && imageUrl.isNotEmpty)
          ? Image.network(
              imageUrl,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => _buildPlaceholder(),
            )
          : _buildPlaceholder(),
    );
  }

  /// Displays the status text and the expiration date if available.
  Widget _buildTrailingInfo(ProductModel p) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          subtitleBuilder(p),
          style: TextStyle(
            color: contentColor,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
          textAlign: TextAlign.right,
        ),
        if (p.expiryDate != null)
          Text(
            "${p.expiryDate!.day}/${p.expiryDate!.month}/${p.expiryDate!.year}",
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
      ],
    );
  }

  /// Default placeholder when no image is available.
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[100],
      width: 50,
      height: 50,
      child: const Icon(
        Icons.inventory_2_outlined,
        size: 20,
        color: Colors.grey,
      ),
    );
  }
}
