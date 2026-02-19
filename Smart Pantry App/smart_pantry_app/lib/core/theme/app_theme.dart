import 'package:flutter/material.dart';

/// Class that centralizes the visual configuration and styling of the application.
///
/// It provides a [ThemeData] instance that defines the colors, typography,
/// and component styles used globally throughout the Smart Pantry App.
class AppTheme {
  /// Generates the light theme configuration for the application.
  ///
  /// This getter returns a [ThemeData] object that sets [Colors.teal] as the
  /// primary swatch and allows for further customization of widgets,
  /// such as buttons, inputs, and text styles, ensuring a cohesive UI.
  static ThemeData get lightTheme {
    return ThemeData(
      // Defines the primary color palette based on teal tones
      primarySwatch: Colors.teal,

      // The scaffoldBackgroundColor is typically set to AppColors.bgLight
      // in the full implementation to maintain the brand's aesthetic.
      useMaterial3: true,

      // Future configurations like textTheme or appBarTheme should be
      // added here to maintain global consistency.
    );
  }
}
