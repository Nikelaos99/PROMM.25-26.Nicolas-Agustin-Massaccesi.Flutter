import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/local_storage.dart';
import '../../../data/providers/hive_provider.dart';

// Screens
import '../scanner/scanner_screen.dart';
import '../list/product_list_screen.dart';
import '../add_product/add_product_manual_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../alerts/alerts_screen.dart';

// Widgets
import 'widgets/custom_app_bar.dart';
import 'widgets/custom_bottom_nav.dart';
import 'widgets/json_options_panel.dart';

/// The main application container and navigation orchestrator.
///
/// This screen uses an [IndexedStack] to maintain the state of its sub-screens
/// and provides a centralized interface for global actions like JSON import/export.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Current active tab index for navigation.
  int _currentIndex = 0;

  /// Visibility flag for the administrative JSON tools panel.
  bool _showJsonPanel = false;

  final LocalStorageService _storageService = LocalStorageService();
  final HiveProvider _hiveProvider = HiveProvider();

  /// Triggers the product export process via [LocalStorageService].
  Future<void> _handleExport() async {
    try {
      await _storageService.exportProductsToFile();
      setState(() => _showJsonPanel = false);
      _showSnackBar("Exportación completada con éxito");
    } catch (e) {
      _showSnackBar("Error al exportar: $e", isError: true);
    }
  }

  /// Orchestrates the product import process.
  ///
  /// [replaceAll] determines if the current database should be purged before import.
  Future<void> _handleImport(bool replaceAll) async {
    try {
      final success = await _storageService.importProductsFromFile(
        replaceAll: replaceAll,
      );
      if (success) {
        setState(() => _showJsonPanel = false);
        _showSnackBar(
          replaceAll ? "Base de datos reemplazada" : "Inventario actualizado",
        );
      }
    } catch (e) {
      _showSnackBar("Error al importar: $e", isError: true);
    }
  }

  /// Displays visual feedback to the user via a [SnackBar].
  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isError ? AppColors.errorText : AppColors.primaryGreen,
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
          // Collapsible panel for file management
          if (_showJsonPanel)
            JsonOptionsPanel(
              productCount: _hiveProvider.getAllProducts().length,
              onExport: _handleExport,
              onImport: _handleImport,
            ),
          Expanded(
            child: IndexedStack(
              index: _currentIndex,
              children: [
                const DashboardScreen(),
                const ProductListScreen(),
                // Manual camera lifecycle management via isActive flag
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
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() {
          _currentIndex = index;
          _showJsonPanel = false;
        }),
      ),
    );
  }
}
