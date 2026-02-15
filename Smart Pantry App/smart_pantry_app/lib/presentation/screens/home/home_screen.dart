import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/local_storage.dart';
import '../../../data/providers/hive_provider.dart';

// Importación de pantallas
import '../scanner/scanner_screen.dart';
import '../list/product_list_screen.dart';
import '../add_product/add_product_manual_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../alerts/alerts_screen.dart';

// Importación de widgets personalizados
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/json_options_panel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _showJsonPanel = false;

  // Instancias de servicios
  final LocalStorageService _storageService = LocalStorageService();
  final HiveProvider _hiveProvider = HiveProvider();

  /// Maneja la exportación delegando al servicio de almacenamiento
  Future<void> _handleExport() async {
    try {
      await _storageService.exportProductsToFile();
      setState(() => _showJsonPanel = false);
      _showSnackBar("Exportación finalizada");
    } catch (e) {
      _showSnackBar("Error al exportar: $e", isError: true);
    }
  }

  /// Maneja la importación delegando al servicio y refrescando la UI
  Future<void> _handleImport(bool replaceAll) async {
    try {
      final success = await _storageService.importProductsFromFile(
        replaceAll: replaceAll,
      );

      if (success) {
        setState(() {
          _showJsonPanel = false;
          // Forzamos un rebuild para que las listas reflejen los nuevos datos
        });
        _showSnackBar(
          replaceAll
              ? "Inventario reemplazado con éxito"
              : "Productos añadidos con éxito",
        );
      }
    } catch (e) {
      _showSnackBar("Error en la importación: $e", isError: true);
    }
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.errorText : AppColors.primaryGreen,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      resizeToAvoidBottomInset: false,
      extendBody: true,

      appBar: CustomAppBar(
        onToggleJsonPanel: () =>
            setState(() => _showJsonPanel = !_showJsonPanel),
      ),

      body: Column(
        children: [
          // Panel de JSON dinámico
          if (_showJsonPanel)
            JsonOptionsPanel(
              productCount: _hiveProvider.getAllProducts().length,
              onExport: _handleExport,
              onImport: (replaceAll) => _handleImport(replaceAll),
            ),

          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const DashboardScreen(),
                const ProductListScreen(),
                // Se activa la cámara solo si el índice es 2
                ScannerScreen(isActive: _currentIndex == 2),
                const AlertsScreen(),
              ],
            ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddProductManualScreen(),
          ),
        ),
        backgroundColor: AppColors.primaryGreen,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            // Cerramos el panel si cambiamos de pestaña para no estorbar
            _showJsonPanel = false;
          });
        },
      ),
    );
  }
}
