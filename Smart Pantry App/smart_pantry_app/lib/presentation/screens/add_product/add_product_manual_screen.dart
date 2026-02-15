import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/custom_text_field.dart';
import 'widgets/quantity_selector.dart';
import 'widgets/date_picker_field.dart';

class AddProductManualScreen extends StatefulWidget {
  final ProductModel? productToEdit;
  final int? hiveKey;

  const AddProductManualScreen({super.key, this.productToEdit, this.hiveKey});

  @override
  State<AddProductManualScreen> createState() => _AddProductManualScreenState();
}

class _AddProductManualScreenState extends State<AddProductManualScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _categoryController;
  late TextEditingController _imageUrlController;
  late TextEditingController _notesController;

  late int _quantity;
  DateTime? _expiryDate;

  bool get isEditing => widget.productToEdit != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.productToEdit?.name ?? '',
    );
    _brandController = TextEditingController(
      text: widget.productToEdit?.brand ?? '',
    );
    _categoryController = TextEditingController(
      text: widget.productToEdit?.category ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.productToEdit?.imageUrl ?? '',
    );
    _notesController = TextEditingController(
      text: widget.productToEdit?.notes ?? '',
    );
    _quantity = widget.productToEdit?.quantity ?? 1;
    _expiryDate = widget.productToEdit?.expiryDate;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now().add(const Duration(days: 7)),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 10)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryGreen,
              onPrimary: Colors.white,
              onSurface: AppColors.textDark,
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
      final String barcode = isEditing
          ? widget.productToEdit!.barcode
          : "MANUAL_${DateTime.now().millisecondsSinceEpoch}";

      // LÓGICA DE SUMA AUTOMÁTICA (Solo si no estamos editando uno existente)
      if (!isEditing) {
        final existingIndex = box.values.toList().indexWhere(
          (p) =>
              p.barcode == barcode &&
              p.expiryDate?.day == _expiryDate?.day &&
              p.expiryDate?.month == _expiryDate?.month &&
              p.expiryDate?.year == _expiryDate?.year,
        );

        if (existingIndex != -1) {
          final existingProduct = box.getAt(existingIndex)!;
          final updatedProduct = ProductModel(
            barcode: existingProduct.barcode,
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
            quantity: existingProduct.quantity + _quantity, // SUMA
            expiryDate: existingProduct.expiryDate,
            dateAdded: existingProduct.dateAdded,
          );
          await box.putAt(existingIndex, updatedProduct);
          _showSnackBar("¡Cantidad sumada al producto existente!");
          if (mounted) Navigator.pop(context);
          return;
        }
      }

      // GUARDADO NORMAL O EDICIÓN
      final productData = ProductModel(
        barcode: barcode,
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
        dateAdded: isEditing ? widget.productToEdit!.dateAdded : DateTime.now(),
      );

      if (isEditing) {
        await box.put(widget.hiveKey, productData);
        _showSnackBar("¡Producto actualizado!");
      } else {
        await box.add(productData);
        _showSnackBar("¡Producto añadido correctamente!");
      }

      if (mounted) Navigator.pop(context);
    }
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
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditing
                        ? "Editar\nProducto"
                        : "Añadir Producto\nManualmente",
                    style: const TextStyle(
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
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryGreen,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: _saveProduct,
        icon: Icon(isEditing ? Icons.save : Icons.add, color: Colors.white),
        label: Text(
          isEditing ? "Guardar Cambios" : "Añadir",
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
