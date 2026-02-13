import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool isRequired;
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8, top: 20),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark, // Usando AppColors.textDark
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          cursorColor: AppColors.primaryGreen,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColors.textGray, fontSize: 14),
            filled: true,
            fillColor: Colors.grey[50],
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 1.5,
              ),
            ),
          ),
          validator: isRequired
              ? (value) => value!.isEmpty ? "Este campo es obligatorio" : null
              : null,
        ),
      ],
    );
  }
}
