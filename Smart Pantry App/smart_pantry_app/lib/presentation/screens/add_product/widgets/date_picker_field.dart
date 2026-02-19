import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A custom form field that triggers a date picker when tapped.
///
/// This component displays a descriptive label and a stylized container
/// that shows either a placeholder text or the formatted [selectedDate].
class DatePickerField extends StatelessWidget {
  /// The currently selected date to be displayed.
  final DateTime? selectedDate;

  /// The text label displayed above the field.
  final String label;

  /// Callback function triggered when the user taps the field.
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
        // FIELD LABEL
        Padding(
          padding: const EdgeInsets.only(top: 20, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
        ),

        // INTERACTIVE FIELD CONTAINER
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
                // FORMATTED DATE OR PLACEHOLDER
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

                // CALENDAR ICON
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
