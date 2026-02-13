import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class CategoryItem extends StatelessWidget {
  final String name;
  final int productCount;
  final int totalUnits;

  const CategoryItem({
    super.key,
    required this.name,
    required this.productCount,
    required this.totalUnits,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.bgLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primaryGreen,
            radius: 12,
            child: Text(
              "$productCount",
              style: const TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // --- FIX AQUÍ ---
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF004D40),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis, // Esto pone los "..."
            ),
          ),
          // ----------------
          const SizedBox(width: 8), // Espacio mínimo de seguridad
          Text(
            "$totalUnits unidades",
            style: const TextStyle(
              color: AppColors.primaryGreen,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
