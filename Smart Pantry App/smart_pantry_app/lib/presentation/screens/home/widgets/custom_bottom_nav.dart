import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

/// A custom Bottom Navigation Bar that supports a floating action button notch.
///
/// This widget uses [BottomAppBar] to create a "cut-out" effect for a centered FAB.
/// It notifies the parent of tab changes through the [onTap] callback.
class CustomBottomNav extends StatelessWidget {
  /// The currently active tab index.
  final int currentIndex;

  /// Callback function triggered when a navigation item is pressed.
  final Function(int) onTap;

  const CustomBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 20,
      color: Colors.white,
      // Creates the curved notch for the FAB
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      child: SizedBox(
        height: 60,
        child: Row(
          children: [
            // LEFT SIDE: Home and List
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_outlined, "Inicio", 0),
                  _buildNavItem(Icons.list_alt_outlined, "Lista", 1),
                ],
              ),
            ),

            // CENTRAL GAP: Reserved for the FloatingActionButton
            const SizedBox(width: 75),

            // RIGHT SIDE: Scan and Alerts
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.barcode_reader, "Escanear", 2),
                  _buildNavItem(
                    Icons.notifications_none_outlined,
                    "Alertas",
                    3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds an individual navigation item with an icon and a label.
  ///
  /// The appearance changes based on whether the item is [isSelected].
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = currentIndex == index;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(15),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4),
        width: 60,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.primaryGreen
                  : Colors.blueGrey.shade300,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: isSelected
                    ? AppColors.primaryGreen
                    : Colors.blueGrey.shade300,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
