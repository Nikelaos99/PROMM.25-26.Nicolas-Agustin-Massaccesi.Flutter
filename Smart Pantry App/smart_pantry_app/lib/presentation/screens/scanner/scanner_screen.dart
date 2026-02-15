import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:hive/hive.dart';
import '../../../data/services/food_api_service.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';

class ScannerScreen extends StatefulWidget {
  final bool isActive;

  const ScannerScreen({super.key, required this.isActive});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final FoodApiService _apiService = FoodApiService();
  final TextEditingController _manualCodeController = TextEditingController();
  final MobileScannerController _scannerController = MobileScannerController(
    autoStart: false,
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
    if (state == AppLifecycleState.paused) {
      _scannerController.stop();
    } else if (state == AppLifecycleState.resumed && !_showManualInput) {
      _scannerController.start();
    }
  }

  void _onDetect(BarcodeCapture capture) async {
    if (_isProcessing || !widget.isActive) return;
    final List<Barcode> barcodes = capture.barcodes;
    if (barcodes.isNotEmpty) {
      final String code = barcodes.first.rawValue ?? "";
      if (code.isNotEmpty) {
        _scannerController.stop();
        _searchAndConfirmProduct(code);
      }
    }
  }

  Future<void> _searchAndConfirmProduct(String code) async {
    if (code.isEmpty) return;
    setState(() => _isProcessing = true);
    final productData = await _apiService.fetchProductByBarcode(code);
    setState(() => _isProcessing = false);

    if (productData != null) {
      _showConfirmationModal(code, productData);
    } else {
      _showError("Producto no encontrado.");
      setState(() {
        _showManualInput = true;
        _scannerController.stop();
      });
    }
  }

  void _showConfirmationModal(String code, Map<String, dynamic> data) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 7));
    int quantity = 1;
    String productName = data['product_name'] ?? "Producto Desconocido";

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
                top: 20,
                left: 24,
                right: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    productName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Cantidad:",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          _quantityButton(Icons.remove, () {
                            if (quantity > 1) setModalState(() => quantity--);
                          }),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              "$quantity",
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          _quantityButton(
                            Icons.add,
                            () => setModalState(() => quantity++),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 32),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(
                      Icons.calendar_today,
                      color: AppColors.primaryGreen,
                    ),
                    title: const Text(
                      "Vencimiento",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}",
                    ),
                    trailing: const Icon(
                      Icons.edit_calendar,
                      color: AppColors.primaryGreen,
                    ),
                    onTap: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(
                          const Duration(days: 365 * 5),
                        ),
                      );
                      if (picked != null)
                        setModalState(() => selectedDate = picked);
                    },
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _saveToHive(code, data, selectedDate, quantity);
                        if (widget.isActive && !_showManualInput)
                          _scannerController.start();
                      },
                      child: const Text(
                        "Añadir a Despensa",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).then((_) {
      if (widget.isActive && !_showManualInput) _scannerController.start();
    });
  }

  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primaryGreen),
        ),
        child: Icon(icon, color: AppColors.primaryGreen, size: 20),
      ),
    );
  }

  void _saveToHive(
    String code,
    Map<String, dynamic> data,
    DateTime expiry,
    int qty,
  ) async {
    final box = Hive.box<ProductModel>('pantry_box');

    // BUSCAR SI YA EXISTE (Mismo código Y misma fecha)
    final existingIndex = box.values.toList().indexWhere(
      (p) =>
          p.barcode == code &&
          p.expiryDate?.day == expiry.day &&
          p.expiryDate?.month == expiry.month &&
          p.expiryDate?.year == expiry.year,
    );

    if (existingIndex != -1) {
      final existingProduct = box.getAt(existingIndex)!;
      final updatedProduct = ProductModel(
        barcode: existingProduct.barcode,
        name: existingProduct.name,
        brand: existingProduct.brand,
        imageUrl: existingProduct.imageUrl,
        dateAdded: existingProduct.dateAdded,
        quantity: existingProduct.quantity + qty, // SUMA
        category: existingProduct.category,
        expiryDate: existingProduct.expiryDate,
      );
      await box.putAt(existingIndex, updatedProduct);
      _showSuccess("¡Cantidad actualizada!");
    } else {
      // SI NO EXISTE, CREAR NUEVO
      String rawCat = data['categories'] ?? "General";
      String cleanCat = rawCat.split(',').first.split(':').last.trim();

      final newProduct = ProductModel(
        barcode: code,
        name: data['product_name'] ?? "Desconocido",
        brand: data['brands'],
        imageUrl: data['image_url'],
        dateAdded: DateTime.now(),
        quantity: qty,
        category: cleanCat.isEmpty ? "General" : cleanCat,
        expiryDate: expiry,
      );
      await box.add(newProduct);
      _showSuccess("¡Producto guardado!");
    }
    _manualCodeController.clear();
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryGreen,
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.errorText,
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      appBar: AppBar(
        title: Text(
          _showManualInput ? "Entrada Manual" : "Escanear Código",
          style: const TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(
              _showManualInput ? Icons.camera_alt : Icons.keyboard,
              color: AppColors.primaryGreen,
            ),
            onPressed: () {
              setState(() {
                _showManualInput = !_showManualInput;
                if (_showManualInput) {
                  _scannerController.stop();
                } else if (widget.isActive) {
                  _scannerController.start();
                }
              });
            },
          ),
        ],
      ),
      body: Visibility(
        visible: widget.isActive,
        replacement: const Center(child: Text("Cámara en pausa")),
        child: _isProcessing
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryGreen),
              )
            : (_showManualInput ? _buildManualInputView() : _buildCameraView()),
      ),
    );
  }

  Widget _buildManualInputView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildManualHeader(),
              const SizedBox(height: 24),
              const Text(
                "Código de Barras",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 12),
              _buildInputField(),
              const SizedBox(height: 24),
              _buildInstructions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen,
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.edit_note, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Búsqueda Manual",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: AppColors.textDark,
              ),
            ),
            Text(
              "Escribe el código EAN/UPC",
              style: TextStyle(color: AppColors.textGray, fontSize: 13),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildInputField() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _manualCodeController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              hintText: "750123456789...",
              filled: true,
              fillColor: Colors.grey[50],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
          ),
          onPressed: () => _searchAndConfirmProduct(_manualCodeController.text),
          child: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildInstructions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.infoBlue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Text(
        "• Ingresa el código numérico.\n• Verifica que los datos coincidan.\n• Selecciona la fecha de caducidad real.",
        style: TextStyle(color: AppColors.infoBlue, fontSize: 13, height: 1.5),
      ),
    );
  }

  Widget _buildCameraView() {
    return Stack(
      children: [
        MobileScanner(controller: _scannerController, onDetect: _onDetect),
        Center(
          child: Container(
            width: 260,
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primaryGreen, width: 3),
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        const Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Text(
            "Centra el código de barras aquí",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              backgroundColor: Colors.black26,
            ),
          ),
        ),
      ],
    );
  }
}
