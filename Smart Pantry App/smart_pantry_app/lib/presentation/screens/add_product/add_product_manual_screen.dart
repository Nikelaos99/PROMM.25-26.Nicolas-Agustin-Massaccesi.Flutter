import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/date_picker_field.dart';

class AddProductManualScreen extends StatefulWidget {
  const AddProductManualScreen({super.key});

  @override
  State<AddProductManualScreen> createState() => _AddProductManualScreenState();
}

class _AddProductManualScreenState extends State<AddProductManualScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _brandController = TextEditingController();
  final _categoryController = TextEditingController();
  final _imageUrlController = TextEditingController();
  final _notesController = TextEditingController();

  int _quantity = 1;
  DateTime? _expiryDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark, // Usando AppColors
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _expiryDate = picked);
    }
  }

  void _saveProduct() async {
    if (_formKey.currentState!.validate()) {
      if (_expiryDate == null) {
        _showSnackBar(
          "Por favor, selecciona una fecha de caducidad",
          isError: true,
        );
        return;
      }

      final box = Hive.box<ProductModel>('pantry_box');
      final String manualId = "MANUAL_${DateTime.now().millisecondsSinceEpoch}";

      final newProduct = ProductModel(
        barcode: manualId,
        name: _nameController.text.trim(),
        brand: _brandController.text.trim().isEmpty
            ? null
            : _brandController.text.trim(),
        category: _categoryController.text.trim(),
        imageUrl: _imageUrlController.text.trim().isEmpty
            ? null
            : _imageUrlController.text.trim(),
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        quantity: _quantity,
        expiryDate: _expiryDate,
        dateAdded: DateTime.now(),
      );

      await box.add(newProduct);

      if (mounted) {
        _showSnackBar("¡Producto añadido correctamente!");
        Navigator.pop(context);
      }
    }
  }

  void _clearForm() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _brandController.clear();
    _categoryController.clear();
    _imageUrlController.clear();
    _notesController.clear();
    setState(() {
      _quantity = 1;
      _expiryDate = null;
    });
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? AppColors.errorText : AppColors.primaryGreen,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _categoryController.dispose();
    _imageUrlController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Smart Pantry App",
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Añadir Producto\nManualmente",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 8),

                  CustomTextField(
                    controller: _nameController,
                    label: "Nombre del Producto *",
                    hint: "Ej: Leche entera",
                    isRequired: true,
                  ),

                  const Padding(
                    padding: EdgeInsets.only(top: 20, bottom: 8),
                    child: Text(
                      "Cantidad *",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  QuantitySelector(
                    quantity: _quantity,
                    onIncrement: () => setState(() => _quantity++),
                    onDecrement: () => setState(() {
                      if (_quantity > 1) _quantity--;
                    }),
                  ),

                  CustomTextField(
                    controller: _categoryController,
                    label: "Categoría *",
                    hint: "Ej: Lácteos",
                    isRequired: true,
                  ),

                  DatePickerField(
                    label: "Fecha de Caducidad *",
                    selectedDate: _expiryDate,
                    onTap: () => _selectDate(context),
                  ),

                  CustomTextField(
                    controller: _brandController,
                    label: "Marca (opcional)",
                    hint: "Ej: Alpura",
                  ),

                  CustomTextField(
                    controller: _imageUrlController,
                    label: "URL de Imagen (opcional)",
                    hint: "https://ejemplo.com/imagen.jpg",
                  ),

                  CustomTextField(
                    controller: _notesController,
                    label: "Notas (opcional)",
                    hint: "Información adicional",
                    maxLines: 3,
                  ),

                  const SizedBox(height: 40),
                  _buildActionButtons(),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen, // Usando AppColors
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            onPressed: _saveProduct,
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text(
              "Añadir",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xFFECEFF1),
              side: BorderSide.none,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: _clearForm,
            child: const Text(
              "Limpiar",
              style: TextStyle(
                color: AppColors.textGray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
