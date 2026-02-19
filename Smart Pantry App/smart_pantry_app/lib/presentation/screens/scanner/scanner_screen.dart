import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive/hive.dart';
import '../../../data/services/food_api_service.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';

/// Screen for identifying products through camera-based scanning or manual entry.
///
/// Implements [WidgetsBindingObserver] to pause the camera when the app
/// goes into the background, preventing resource leaks.
class ScannerScreen extends StatefulWidget {
  /// Flag provided by the parent to enable/disable camera hardware.
  final bool isActive;
  const ScannerScreen({super.key, required this.isActive});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final FoodApiService _apiService = FoodApiService();
  final TextEditingController _manualCodeController = TextEditingController();

  /// Hardware controller for the mobile scanner.
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
    detectionSpeed: DetectionSpeed.normal,
  );

  bool _isProcessing = false;
  bool _showManualInput = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.isActive) _scannerController.start();
  }

  @override
  void didUpdateWidget(ScannerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    // React to tab visibility changes in IndexedStack
    if (widget.isActive != oldWidget.isActive) {
      if (widget.isActive && !_showManualInput) {
        _scannerController.start();
      } else {
        _scannerController.stop();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _scannerController.dispose();
    _manualCodeController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!widget.isActive) return;
    // Manage camera based on app foreground/background state
    if (state == AppLifecycleState.paused) {
      _scannerController.stop();
    } else if (state == AppLifecycleState.resumed && !_showManualInput) {
      _scannerController.start();
    }
  }

  /// Processes the [BarcodeCapture] results from the camera.
  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || !widget.isActive) return;
    final code = capture.barcodes.firstOrNull?.rawValue;
    if (code != null && code.isNotEmpty) {
      _scannerController.stop();
      _searchAndConfirmProduct(code);
    }
  }

  /// Fetches product data from the OpenFoodFacts API service.
  Future<void> _searchAndConfirmProduct(String code) async {
    if (code.isEmpty) return;
    setState(() => _isProcessing = true);

    final data = await _apiService.fetchProductByBarcode(code);

    setState(() => _isProcessing = false);

    if (data != null) {
      _showConfirmationModal(code, data);
    } else {
      _showError("Producto no encontrado en la base de datos.");
      setState(() {
        _showManualInput = true;
        _scannerController.stop();
      });
    }
  }

  /// Shows a [ModalBottomSheet] to verify and refine product entry before saving.
  void _showConfirmationModal(String code, Map<String, dynamic> data) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    int quantity = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 24,
            right: 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                data['product_name'] ?? "Producto desconocido",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildQuantityRow(
                quantity,
                setModalState,
                (val) => quantity = val,
              ),
              _buildExpiryPicker(
                selectedDate,
                setModalState,
                (date) => selectedDate = date,
              ),
              const SizedBox(height: 16),
              _buildSaveButton(() {
                Navigator.pop(context);
                _saveToHive(code, data, selectedDate, quantity);
              }),
            ],
          ),
        ),
      ),
    ).then((_) {
      // Resume scanner if the user is still on the scanner tab
      if (widget.isActive && !_showManualInput) _scannerController.start();
    });
  }

  /// Saves or updates the product record in the Hive database.
  void _saveToHive(
    String code,
    Map<String, dynamic> data,
    DateTime expiry,
    int qty,
  ) async {
    final box = Hive.box<ProductModel>('pantry_box');

    // Check for identical products with same expiry to aggregate quantity
    final existingIndex = box.values.toList().indexWhere(
      (p) => p.barcode == code && p.expiryDate?.day == expiry.day,
    );

    if (existingIndex != -1) {
      final existing = box.getAt(existingIndex)!;
      await box.putAt(
        existingIndex,
        existing.copyWith(quantity: existing.quantity + qty),
      );
      _showSuccess("¡Cantidad actualizada!");
    } else {
      final newProduct = ProductModel(
        barcode: code,
        name: data['product_name'] ?? "Desconocido",
        brand: data['brands'],
        imageUrl: data['image_url'],
        dateAdded: DateTime.now(),
        quantity: qty,
        category:
            (data['categories'] as String?)?.split(',').first.trim() ??
            "General",
        expiryDate: expiry,
      );
      await box.add(newProduct);
      _showSuccess("¡Producto añadido a la despensa!");
    }
  }

  // UI Helpers (Modularized for readability)

  Widget _buildQuantityRow(
    int qty,
    StateSetter setState,
    Function(int) onUpdate,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Cantidad en stock:",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.remove),
              onPressed: () {
                if (qty > 1) setState(() => onUpdate(--qty));
              },
            ),
            Text(
              "$qty",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => setState(() => onUpdate(++qty)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildExpiryPicker(
    DateTime date,
    StateSetter setState,
    Function(DateTime) onUpdate,
  ) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text(
        "Fecha de caducidad",
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text("${date.day}/${date.month}/${date.year}"),
      trailing: const Icon(Icons.edit_calendar, color: AppColors.primaryGreen),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 1825)),
        );
        if (picked != null) setState(() => onUpdate(picked));
      },
    );
  }

  Widget _buildSaveButton(VoidCallback onSave) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        onPressed: onSave,
        child: const Text(
          "AÑADIR A LA DESPENSA",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  void _showSuccess(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.primaryGreen,
      behavior: SnackBarBehavior.floating,
    ),
  );
  void _showError(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.errorText,
      behavior: SnackBarBehavior.floating,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(_showManualInput ? "Entrada manual" : "Escanear código"),
        actions: [
          IconButton(
            icon: Icon(
              _showManualInput ? Icons.camera_alt : Icons.keyboard,
              color: AppColors.primaryGreen,
            ),
            onPressed: () => setState(() {
              _showManualInput = !_showManualInput;
              _showManualInput
                  ? _scannerController.stop()
                  : (widget.isActive ? _scannerController.start() : null);
            }),
          ),
        ],
      ),
      body: Visibility(
        visible: widget.isActive,
        replacement: const Center(child: CircularProgressIndicator()),
        child: _isProcessing
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
            : (_showManualInput ? _buildManualView() : _buildCameraView()),
      ),
    );
  }

  Widget _buildManualView() => SingleChildScrollView(
    padding: const EdgeInsets.all(20),
    child: TextField(
      controller: _manualCodeController,
      decoration: const InputDecoration(
        labelText: "Código EAN",
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.number,
      onSubmitted: _searchAndConfirmProduct,
    ),
  );
  Widget _buildCameraView() => Stack(
    children: [
      MobileScanner(controller: _scannerController, onDetect: _onDetect),
      Center(
        child: Container(
          width: 250,
          height: 200,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryGreen, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ],
  );
}
