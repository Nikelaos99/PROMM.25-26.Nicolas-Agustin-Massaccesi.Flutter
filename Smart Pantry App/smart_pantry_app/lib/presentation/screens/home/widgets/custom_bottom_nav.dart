import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
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
      shape: const CircularNotchedRectangle(),
      notchMargin: 8,
      // Eliminamos clipBehavior para que la sombra del notch fluya mejor
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Lado izquierdo: Inicio y Lista
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavItem(Icons.home_outlined, "Inicio", 0),
                  _buildNavItem(Icons.list_alt_outlined, "Lista", 1),
                ],
              ),
            ),

            // Espacio central reservado para el FloatingActionButton
            const SizedBox(width: 75),

            // Lado derecho: Escanear y Alertas
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

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;

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
