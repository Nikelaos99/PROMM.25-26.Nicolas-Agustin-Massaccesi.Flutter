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

  // --- LÓGICA DE DATOS REALES ---

  String _getExpiryText() {
    if (product.expiryDate == null) return "Sin fecha";

    // Calculamos la diferencia real con el día de hoy
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
    final difference = product.expiryDate!.difference(DateTime.now()).inDays;
    return difference >= 0 && difference <= 3;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGEN DEL PRODUCTO (DINÁMICA)
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            child: Container(
              height: 160,
              width: double.infinity,
              color: Colors
                  .white, // Fondo blanco para que luzca como producto real
              child: product.imageUrl != null && product.imageUrl!.isNotEmpty
                  ? Image.network(
                      product.imageUrl!,
                      fit: BoxFit
                          .contain, // Muestra el producto completo sin recortar
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        product.name, // NOMBRE REAL
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // CANTIDAD REAL
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
                Text(
                  product.brand ?? "Marca genérica", // MARCA REAL
                  style: const TextStyle(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 16),

                // FILAS DE INFORMACIÓN
                _buildInfoRow(
                  "Categoría:",
                  product.category ?? "General", // CATEGORÍA REAL
                ),
                _buildInfoRow(
                  "Vence:",
                  _getExpiryText(), // FECHA REAL CALCULADA
                  isUrgent: _isUrgent(),
                ),

                const Divider(height: 32),

                // BOTONES DE ACCIÓN
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: const Text("Editar"),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.blue.shade700,
                          side: BorderSide(color: Colors.blue.shade100),
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
                          foregroundColor: Colors.red.shade700,
                          side: BorderSide(color: Colors.red.shade100),
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
      color: Colors.grey.shade100,
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
          SizedBox(height: 8),
          Text(
            "Sin imagen",
            style: TextStyle(color: Colors.grey, fontSize: 12),
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
              color: Colors.black87,
              fontWeight: FontWeight.w400,
            ),
          ),
          if (isUrgent)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFFFEBEE),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          else
            Text(
              value,
              style: const TextStyle(
                color: Color(0xFF004D40),
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
