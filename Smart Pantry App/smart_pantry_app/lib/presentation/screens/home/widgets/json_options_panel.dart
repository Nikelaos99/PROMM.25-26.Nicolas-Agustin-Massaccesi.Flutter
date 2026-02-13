import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class JsonOptionsPanel extends StatelessWidget {
  final VoidCallback onExport;
  final VoidCallback onImport;
  final int productCount;

  const JsonOptionsPanel({
    super.key,
    required this.onExport,
    required this.onImport,
    required this.productCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
      decoration: const BoxDecoration(
        color:
            AppColors.bgLight, // Fondo verde claro como en el área de usuario
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Indicador visual de que es un panel desplegable
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Botón Exportar
          _buildButton(
            label: "Exportar a JSON",
            icon: Icons.upload_file_rounded,
            color: AppColors.primaryGreen,
            onTap: onExport,
          ),
          const SizedBox(height: 12),
          // Botón Importar
          _buildButton(
            label: "Importar desde JSON",
            icon: Icons.file_download_outlined,
            color: const Color(0xFF00BFA5), // El tono turquesa/verde agua
            onTap: onImport,
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.inventory_2_outlined,
                size: 14,
                color: Colors.grey,
              ),
              const SizedBox(width: 6),
              Text(
                "$productCount productos en inventario",
                style: const TextStyle(
                  color: AppColors.textGray,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 52, // Un poco más alto para mejor ergonomía táctil
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 22, color: Colors.white),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          elevation: 2, // Un toque de sombra para resaltar sobre el fondo claro
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
