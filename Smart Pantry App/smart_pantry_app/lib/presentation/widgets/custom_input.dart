import 'package:flutter/material.dart';

/// A highly reusable and styled input field component used throughout the app.
///
/// This widget follows a consistent design pattern by wrapping a [TextField]
/// with a descriptive label and an icon, ensuring that all user inputs
/// (like login or registration forms) share the same aesthetic.
class CustomInput extends StatelessWidget {
  /// The descriptive title displayed above the input field.
  final String label;

  /// The placeholder text shown inside the field when it is empty.
  final String hint;

  /// The icon displayed at the beginning (prefix) of the input field.
  final IconData icon;

  /// Whether the text should be masked (e.g., for password entry).
  /// Defaults to `false`.
  final bool isPassword;

  /// The controller used to manage and retrieve the text being edited.
  final TextEditingController? controller;

  /// Creates a [CustomInput] widget.
  const CustomInput({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.isPassword = false,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Descriptive label styling
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: Color(0xFF37474F),
          ),
        ),
        const SizedBox(height: 8),
        // Main input field configuration
        TextField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.grey),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.grey),
            // Default border state
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            // Border state when the field is not focused
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
          ),
        ),
        const SizedBox(
          height: 16,
        ), // Consistent vertical spacing between inputs
      ],
    );
  }
}
