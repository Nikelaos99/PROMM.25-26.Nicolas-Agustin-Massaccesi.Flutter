import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A custom input widget that allows users to increment or decrement a numeric value.
///
/// This stateless widget relies on parent callbacks to manage its state,
/// adhering to the "Lifting State Up" pattern in Flutter.
class QuantitySelector extends StatelessWidget {
  /// The current numeric value to display.
  final int quantity;

  /// Callback executed when the plus button is pressed.
  final VoidCallback onIncrement;

  /// Callback executed when the minus button is pressed.
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
          // QUANTITY DISPLAY
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Row(
              children: [
                Text(
                  "$quantity",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  quantity == 1 ? "unidad" : "unidades",
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),

          // CONTROL BUTTONS
          Row(
            children: [
              IconButton(
                onPressed: quantity > 1 ? onDecrement : null,
                tooltip: "Disminuir cantidad",
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: quantity > 1
                      ? AppColors.primaryGreen
                      : AppColors.textGray.withOpacity(0.5),
                ),
              ),
              IconButton(
                onPressed: onIncrement,
                tooltip: "Aumentar cantidad",
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
