import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A dashboard widget that displays a key metric with an associated icon.
///
/// It features a clean, card-like design with a subtle shadow and a color-coded
/// icon container to provide quick visual context for the data shown.
class SummaryCard extends StatelessWidget {
  /// The descriptive label of the metric (e.g., "Total Products").
  final String title;

  /// The numeric or textual value of the metric.
  final String value;

  /// The icon representing the data type.
  final IconData icon;

  /// The color applied to the icon.
  final Color iconColor;

  /// The background color for the icon's container, usually a light shaded version
  /// of the iconColor.
  final Color iconBgColor;

  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // DATA SECTION: Title and Metric Value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textGray,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 22, // Slightly adjusted for better grid fit
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF004D40), // Dark teal for readability
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // ICON SECTION: Stylized container for the indicator icon
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 20, // Scaled down for a more refined look
            ),
          ),
        ],
      ),
    );
  }
}
