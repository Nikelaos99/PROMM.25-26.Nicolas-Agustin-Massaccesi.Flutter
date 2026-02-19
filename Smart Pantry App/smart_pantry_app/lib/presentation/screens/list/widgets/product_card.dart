import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';
import '../../../../core/constants/colors.dart';

/// A card widget that visually represents a [ProductModel].
///
/// Displays product imagery, quantity, and expiration status with
/// conditional styling based on urgency. Provides action buttons
/// for editing and deletion.
class ProductCard extends StatelessWidget {
  /// The product data to display.
  final ProductModel product;

  /// Callback triggered when the user taps the edit button.
  final VoidCallback onEdit;

  /// Callback triggered when the user taps the delete button.
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  // --- LOGIC: DATES AND STATES ---

  /// Returns a human-readable string representing the expiration status.
  String _getExpiryText() {
    if (product.expiryDate == null) return "Sin fecha";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final expiry = DateTime(
      product.expiryDate!.year,
      product.expiryDate!.month,
      product.expiryDate!.day,
    );

    final difference = expiry.difference(today).inDays;

    if (difference < 0) return "Caducado";
    if (difference == 0) return "Caduca hoy";
    if (difference == 1) return "Caduca mañana";
    return "En $difference días";
  }

  /// Determines if the product is expired or close to expiring (within 3 days).
  bool _isUrgent() {
    if (product.expiryDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = product.expiryDate!.difference(today).inDays;

    // Returns true if expired (negative) or expires in 3 days or less.
    return difference <= 3;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // PRODUCT IMAGE HEADER
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.white,
              child: _buildProductImage(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NAME AND QUANTITY ROW
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildQuantityBadge(),
                  ],
                ),

                // BRAND INFO
                Text(
                  product.brand ?? "Marca genérica",
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // INFORMATION ROWS
                _buildInfoRow("Categoría:", product.category ?? "General"),
                _buildInfoRow(
                  "Estado:",
                  _getExpiryText(),
                  isUrgent: _isUrgent(),
                ),

                const Divider(height: 32, thickness: 0.5),

                // ACTION BUTTONS
                Row(
                  children: [
                    _buildActionButton(
                      label: "Editar",
                      icon: Icons.edit_outlined,
                      onPressed: onEdit,
                      color: AppColors.primaryGreen,
                    ),
                    const SizedBox(width: 12),
                    _buildActionButton(
                      label: "Eliminar",
                      icon: Icons.delete_outline,
                      onPressed: onDelete,
                      color: AppColors.errorText,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- WIDGET BUILDERS (MODULARIZATION) ---

  /// Builds the product image using [Image.network] with error handling.
  Widget _buildProductImage() {
    if (product.imageUrl == null || product.imageUrl!.isEmpty) {
      return _buildPlaceholder();
    }

    return Image.network(
      product.imageUrl!,
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
          ),
        );
      },
      errorBuilder: (_, __, ___) => _buildPlaceholder(),
    );
  }

  /// Stylized badge to show the current stock quantity.
  Widget _buildQuantityBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "x${product.quantity.toInt()}",
        style: const TextStyle(
          color: AppColors.primaryGreen,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  /// Common placeholder for missing or broken images.
  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[50],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.textGray),
          SizedBox(height: 8),
          Text(
            "Imagen no disponible",
            style: TextStyle(color: AppColors.textGray, fontSize: 12),
          ),
        ],
      ),
    );
  }

  /// Helper to build a labeled info row with optional urgent styling.
  Widget _buildInfoRow(String label, String value, {bool isUrgent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textGray)),
          if (isUrgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.errorText,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: AppColors.textDark,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }

  /// Modular button builder for the action row.
  Widget _buildActionButton({
    required String label,
    required IconData icon,
    required VoidCallback onPressed,
    required Color color,
  }) {
    return Expanded(
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          foregroundColor: color,
          side: BorderSide(color: color.withOpacity(0.3)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
