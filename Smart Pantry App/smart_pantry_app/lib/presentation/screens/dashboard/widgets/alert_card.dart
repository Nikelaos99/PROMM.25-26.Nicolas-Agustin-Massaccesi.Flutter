import 'package:flutter/material.dart';

/// A notification widget designed to display urgent information or status updates.
///
/// It uses a compact layout with an icon, a title, and a list of affected items.
/// Ideally used within the Dashboard to show stock or expiration alerts.
class AlertCard extends StatelessWidget {
  /// The category or type of alert (e.g., "Low Stock").
  final String title;

  /// A comma-separated string or description of the items triggering the alert.
  final String items;

  /// The fill color of the card's background.
  final Color backgroundColor;

  /// The color applied to the text and the icon for contrast.
  final Color textColor;

  /// The icon that represents the nature of the alert.
  final IconData icon;

  const AlertCard({
    super.key,
    required this.title,
    required this.items,
    required this.backgroundColor,
    required this.textColor,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    // We check if items is truly empty or just contains whitespace
    final String displayItems = items.trim().isEmpty ? "None" : items;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // Tip: Using a slight opacity on background can make the UI feel more modern
        color: backgroundColor.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        // Adding a subtle border of the same color to define the shape better
        border: Border.all(color: backgroundColor.withOpacity(0.3), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADER: Icon + Title
          Row(
            children: [
              Icon(icon, color: textColor, size: 18),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          // CONTENT: Item list
          Text(
            displayItems,
            style: TextStyle(
              color: textColor.withOpacity(0.9),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
