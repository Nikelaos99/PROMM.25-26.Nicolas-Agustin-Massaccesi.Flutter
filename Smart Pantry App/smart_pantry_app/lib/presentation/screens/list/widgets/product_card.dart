import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';
import '../../../../core/constants/colors.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onDelete,
  });

  // --- LÓGICA DE FECHAS Y ESTADOS ---

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

    if (difference < 0) return "Vencido";
    if (difference == 0) return "Vence hoy";
    if (difference == 1) return "Vence mañana";
    return "En $difference días";
  }

  bool _isUrgent() {
    if (product.expiryDate == null) return false;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final difference = product.expiryDate!.difference(today).inDays;
    return difference >= 0 && difference <= 3;
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
          // IMAGEN DEL PRODUCTO
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors.white,
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primaryGreen,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (_, __, ___) => _buildPlaceholder(),
                    )
                  : _buildPlaceholder(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // NOMBRE Y CANTIDAD
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
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.bgLight,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        "${product.quantity}",
                        style: const TextStyle(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                // MARCA
                Text(
                  product.brand ?? "Marca genérica",
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 16),

                // FILAS DE INFORMACIÓN (Categoría y Vencimiento)
                _buildInfoRow("Categoría:", product.category ?? "General"),
                _buildInfoRow(
                  "Vence:",
                  _getExpiryText(),
                  isUrgent: _isUrgent(),
                ),

                const Divider(height: 32, thickness: 0.5),

                // BOTONES DE ACCIÓN
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Editar"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: BorderSide(
                            color: AppColors.primaryGreen.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onDelete,
                        icon: const Icon(Icons.delete_outline, size: 18),
                        label: const Text("Eliminar"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.errorText,
                          side: BorderSide(
                            color: AppColors.errorText.withOpacity(0.3),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                        ),
                      ),
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

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[50],
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 40, color: AppColors.textGray),
          SizedBox(height: 8),
          Text(
            "Sin imagen",
            style: TextStyle(color: AppColors.textGray, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isUrgent = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: AppColors.textGray,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isUrgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.errorRed,
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
}
