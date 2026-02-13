import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';

class AlertSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color bgColor;
  final Color contentColor;
  final List<ProductModel> products;
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
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: contentColor),
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
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];
              return Card(
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: p.imageUrl != null && p.imageUrl!.isNotEmpty
                        ? Image.network(
                            p.imageUrl!,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            // Se usan nombres distintos para evitar el error de duplicado
                            errorBuilder: (context, error, stackTrace) =>
                                _buildPlaceholder(),
                          )
                        : _buildPlaceholder(),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF004D40),
                    ),
                  ),
                  subtitle: Text(
                    "${p.category} | Cant: ${p.quantity}",
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  trailing: Text(
                    subtitleBuilder(p),
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: contentColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

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
