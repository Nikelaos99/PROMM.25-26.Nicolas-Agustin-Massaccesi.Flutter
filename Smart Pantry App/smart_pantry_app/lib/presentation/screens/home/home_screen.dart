import 'package:flutter/material.dart';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:share_plus/share_plus.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/local_storage.dart';
import '../../../data/providers/hive_provider.dart';

// Importación de pantallas
import '../scanner/scanner_screen.dart';
import '../list/product_list_screen.dart';
import '../add_product/add_product_manual_screen.dart';
import '../dashboard/dashboard_screen.dart';
import '../alerts/alerts_screen.dart';

// Importación de tus widgets personalizados (YA EXISTENTES)
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
  final LocalStorageService _storageService = LocalStorageService();
  final HiveProvider _hiveProvider = HiveProvider();

  // Función para manejar la exportación
  Future<void> _handleExport() async {
    try {
      final jsonString = await _storageService.exportProductsToJson();
      await Share.share(jsonString, subject: 'Backup Mi Despensa');
      setState(() => _showJsonPanel = false);
    } catch (e) {
      _showSnackBar("Error al exportar: $e", isError: true);
    }
  }

  // Función para manejar la importación
  Future<void> _handleImport() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null) {
        File file = File(result.files.single.path!);
        String content = await file.readAsString();
        if (!mounted) return;

        _showImportDialog(content);
      }
    } catch (e) {
      _showSnackBar("Error al importar: $e", isError: true);
    }
  }

  void _showImportDialog(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Importar Inventario"),
        content: const Text(
          "¿Deseas añadir los productos o reemplazarlo todo?",
        ),
        actions: [
          TextButton(
            onPressed: () => _executeImport(content, false),
            child: const Text("AÑADIR"),
          ),
          TextButton(
            onPressed: () => _executeImport(content, true),
            child: const Text(
              "REEMPLAZAR TODO",
              style: TextStyle(color: AppColors.errorText),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _executeImport(String content, bool replaceAll) async {
    await _storageService.importProductsFromJson(
      content,
      replaceAll: replaceAll,
    );
    if (mounted) Navigator.pop(context);
    setState(() => _showJsonPanel = false);
    _showSnackBar("Importación exitosa");
  }

  void _showSnackBar(String msg, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError ? AppColors.errorText : AppColors.primaryGreen,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      resizeToAvoidBottomInset: false,
      extendBody: true,

      // USANDO TU CUSTOM APP BAR
      appBar: CustomAppBar(
        onToggleJsonPanel: () =>
            setState(() => _showJsonPanel = !_showJsonPanel),
      ),

      body: Column(
        children: [
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
                ScannerScreen(
                  isActive: _currentIndex == 2,
                ), // Lógica de activación
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

      // USANDO TU CUSTOM BOTTOM NAV
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _showJsonPanel = false;
          });
        },
      ),
    );
  }
}
