import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class QuantitySelector extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              "$quantity",
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: onDecrement,
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: quantity > 1
                      ? AppColors.primaryGreen
                      : AppColors.textGray,
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
