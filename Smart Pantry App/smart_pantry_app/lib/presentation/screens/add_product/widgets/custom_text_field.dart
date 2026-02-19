import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A customized [TextFormField] wrapped with a label and consistent styling.
///
/// This widget provides a standardized look for all text inputs in the app,
/// supporting mandatory field validation and multi-line input.
class CustomTextField extends StatelessWidget {
  /// Controls the text being edited.
  final TextEditingController controller;

  /// The text displayed above the input field.
  final String label;

  /// Suggestion text shown inside the field when it is empty.
  final String hint;

  /// If true, the field will display an error if left empty upon form validation.
  final bool isRequired;

  /// The maximum number of lines allowed for this input.
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.isRequired = false,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    // Shared border style to keep the code DRY
    final outlineBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: Colors.grey.shade300),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // INPUT LABEL
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),

        // TEXT FORM FIELD
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: AppColors.primaryGreen,
          style: const TextStyle(fontSize: 15, color: AppColors.textDark),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            border: outlineBorder,
            enabledBorder: outlineBorder,
            focusedBorder: outlineBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 1.5,
              ),
            ),
            errorBorder: outlineBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.errorText,
                width: 1,
              ),
            ),
            focusedErrorBorder: outlineBorder.copyWith(
              borderSide: const BorderSide(
                color: AppColors.errorText,
                width: 1.5,
              ),
            ),
          ),
          // Spanish validation message for the end user
          validator: isRequired
              ? (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Este campo es obligatorio";
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}
