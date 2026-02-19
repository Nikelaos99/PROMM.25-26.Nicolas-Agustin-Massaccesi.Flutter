import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A list item widget that displays summary statistics for a specific category.
///
/// Shows the unique product count in a badge and the total cumulative units
/// on the trailing edge. Designed for the category breakdown section in the Dashboard.
class CategoryItem extends StatelessWidget {
  /// The display name of the category.
  final String name;

  /// The number of unique product types within this category.
  final int productCount;

  /// The total sum of quantities for all products in this category.
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
          // BADGE: Unique product count
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
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

          // CATEGORY NAME: Flexible to prevent overflow
          Expanded(
            child: Text(
              name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Color(0xFF004D40), // Dark teal for visual consistency
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),

          const SizedBox(width: 12),

          // TRAILING INFO: Total stock units in category
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
