import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  final String title;
  final String items;
  final Color backgroundColor;
  final Color textColor;
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          const SizedBox(height: 4),
          Text(
            items.isEmpty ? "Ninguno" : items,
            style: TextStyle(color: textColor.withOpacity(0.8), fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
