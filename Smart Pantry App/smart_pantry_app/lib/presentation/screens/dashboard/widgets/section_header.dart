import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A reusable header component for dashboard sections.
///
/// It provides a consistent visual anchor consisting of a primary-colored icon
/// and a bold title, helping the user distinguish between different functional
/// areas of the screen.
class SectionHeader extends StatelessWidget {
  /// The icon that visually represents the section's content.
  final IconData icon;

  /// The localized title string for the section.
  final String title;

  const SectionHeader({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          // ICON: Primary brand color to draw attention
          Icon(icon, color: AppColors.primaryGreen, size: 22),

          const SizedBox(width: 10),

          // TITLE: Bold and dark for high legibility
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40), // Consistent dark teal for headers
            ),
          ),
        ],
      ),
    );
  }
}
