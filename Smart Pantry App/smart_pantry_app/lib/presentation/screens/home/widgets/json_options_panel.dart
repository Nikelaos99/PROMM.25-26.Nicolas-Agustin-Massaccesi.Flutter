import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';

class JsonOptionsPanel extends StatelessWidget {
  final VoidCallback onExport;
  // Cambiamos el onImport para que reciba el booleano de 'replaceAll'
  final Function(bool) onImport;
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
        color: AppColors.bgLight,
        border: Border(bottom: BorderSide(color: Color(0xFFE0E0E0), width: 1)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          _buildButton(
            label: "Exportar a JSON",
            icon: Icons.upload_file_rounded,
            color: AppColors.primaryGreen,
            onTap: onExport,
          ),
          const SizedBox(height: 12),
          _buildButton(
            label: "Importar desde JSON",
            icon: Icons.file_download_outlined,
            color: const Color(0xFF00BFA5),
            onTap: () => _showImportDialog(context),
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

  // Diálogo para elegir modo de importación
  void _showImportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Importar Inventario"),
        content: const Text(
          "¿Deseas añadir los productos al inventario actual o reemplazar todo el contenido?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onImport(false); // Añadir
            },
            child: const Text("Añadir"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onImport(true); // Reemplazar
            },
            child: const Text(
              "Reemplazar Todo",
              style: TextStyle(color: Colors.red),
            ),
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
      height: 52,
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
          elevation: 2,
          shadowColor: color.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
