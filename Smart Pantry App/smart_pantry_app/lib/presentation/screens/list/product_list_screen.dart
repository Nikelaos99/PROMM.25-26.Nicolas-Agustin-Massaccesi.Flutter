import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import '../add_product/add_product_manual_screen.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _removeAccents(String text) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';
    for (int i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return text;
  }

  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar producto?"),
        content: Text("Se borrará '${product.name}' definitivamente."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () {
              product.delete();
              Navigator.pop(context);
            },
            child: const Text(
              "ELIMINAR",
              style: TextStyle(color: AppColors.errorText),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box<ProductModel>('pantry_box');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          TextField(
            controller: _searchController,
            textInputAction: TextInputAction.search,
            onChanged: (value) => setState(() => _searchQuery = value),
            decoration: InputDecoration(
              hintText: "Buscar productos...",
              prefixIcon: const Icon(
                Icons.search,
                color: AppColors.primaryGreen,
              ),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _searchQuery = "");
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: productBox.listenable(),
              builder: (context, Box<ProductModel> box, _) {
                if (box.isEmpty)
                  return const Center(child: Text("Tu despensa está vacía."));

                final queryNormalized = _removeAccents(
                  _searchQuery.toLowerCase(),
                );
                final filteredProducts = box.values.toList().reversed.where((
                  product,
                ) {
                  final nameNorm = _removeAccents(product.name.toLowerCase());
                  final brandNorm = _removeAccents(
                    (product.brand ?? "").toLowerCase(),
                  );
                  return nameNorm.contains(queryNormalized) ||
                      brandNorm.contains(queryNormalized);
                }).toList();

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onEdit: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddProductManualScreen(
                            productToEdit: product,
                            hiveKey: product.key as int?,
                          ),
                        ),
                      ),
                      onDelete: () => _confirmDelete(context, product),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
