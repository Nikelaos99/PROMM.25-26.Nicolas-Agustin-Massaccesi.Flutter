import 'package:flutter/material.dart';

/// Static class that defines the color palette for the Smart Pantry application.
///
/// This class centralizes all [Color] definitions to ensure visual consistency
/// across the app and to simplify global theme modifications.
class AppColors {
  /// The main brand color used for primary buttons, logos, and active states.
  static const Color primaryGreen = Color(0xFF00BC7D);

  /// A soft mint-tinted white used for the application's background.
  static const Color bgLight = Color(0xFFF1FBF9);

  // --- Alert System: Backgrounds ---
  // These soft colors are used as background fills for alert containers.

  /// Soft background color for high-priority or expired item alerts.
  static const Color errorRed = Color(0xFFFFF1F1);

  /// Soft background color for warnings, such as items nearing expiration.
  static const Color warningAmber = Color(0xFFFFF8E1);

  /// Soft background color for informational messages or tips.
  static const Color infoBlue = Color(0xFFE3F2FD);

  // --- Alert System: Text & Icons ---
  // High-contrast colors used to ensure readability over the soft background fills.

  /// High-contrast red for text and icons in error alerts.
  static const Color errorText = Color(0xFFD32F2F);

  /// High-contrast amber for text and icons in warning alerts.
  static const Color warningText = Color(0xFFF57C00);

  /// High-contrast blue for text and icons in informational alerts.
  static const Color infoText = Color(0xFF1976D2);

  // --- General Typography ---

  /// Neutral gray used for secondary labels and descriptive body text.
  static const Color textGray = Color(0xFF666666);

  /// Deep teal-based dark color for primary body text.
  static const Color textDark = Color(0xFF004D40);

  /// Specialized color for card headings and section titles.
  static const Color cardTitle = Color(0xFF004D40);
}
