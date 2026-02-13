import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class DatePickerField extends StatelessWidget {
  final DateTime? selectedDate;
  final String label;
  final VoidCallback onTap;

  const DatePickerField({
    super.key,
    required this.selectedDate,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark, // Usando AppColors.textDark
            ),
          ),
        ),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.grey[50],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  selectedDate == null
                      ? "Seleccionar fecha"
                      : "${selectedDate!.day.toString().padLeft(2, '0')}/${selectedDate!.month.toString().padLeft(2, '0')}/${selectedDate!.year}",
                  style: TextStyle(
                    color: selectedDate == null
                        ? AppColors.textGray
                        : Colors.black87,
                  ),
                ),
                const Icon(
                  Icons.calendar_today_outlined,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
