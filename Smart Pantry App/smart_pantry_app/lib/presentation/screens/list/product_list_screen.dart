import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import '../add_product/add_product_manual_screen.dart';
import 'widgets/product_card.dart';

/// A screen that displays the list of products currently in the pantry.
///
/// It features a real-time search engine, automatic UI updates via [Hive],
/// and provides access to product editing and deletion functionalities.
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  /// Controller for the search bar text field.
  final TextEditingController _searchController = TextEditingController();

  /// Current string used to filter the product list.
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Removes accents and diacritics from a string to normalize search.
  ///
  /// This ensures that searching for "Cafe" matches "Café".
  String _removeAccents(String text) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';
    for (int i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return text;
  }

  /// Filters the [allProducts] list based on the user's search query.
  ///
  /// Compares normalized names and brands for a more flexible user experience.
  List<ProductModel> _getFilteredProducts(List<ProductModel> allProducts) {
    if (_searchQuery.isEmpty) return allProducts.reversed.toList();

    final queryNormalized = _removeAccents(_searchQuery.toLowerCase());

    return allProducts
        .where((product) {
          final nameNorm = _removeAccents(product.name.toLowerCase());
          final brandNorm = _removeAccents((product.brand ?? "").toLowerCase());

          return nameNorm.contains(queryNormalized) ||
              brandNorm.contains(queryNormalized);
        })
        .toList()
        .reversed
        .toList();
  }

  /// Displays a confirmation dialog before permanently deleting a product.
  void _confirmDelete(BuildContext context, ProductModel product) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar producto?"),
        content: Text(
          "¿Estás seguro de que quieres eliminar '${product.name}'? Esta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("CANCELAR"),
          ),
          TextButton(
            onPressed: () {
              product.delete(); // HiveObject method to remove from box
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
          _buildSearchBar(),
          const SizedBox(height: 20),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: productBox.listenable(),
              builder: (context, Box<ProductModel> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text(
                      "Tu despensa está vacía. ¡Empieza escaneando productos!",
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                final filteredProducts = _getFilteredProducts(
                  box.values.toList(),
                );

                if (filteredProducts.isEmpty) {
                  return const Center(
                    child: Text(
                      "No hay productos que coincidan con tu búsqueda.",
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(bottom: 100),
                  itemCount: filteredProducts.length,
                  itemBuilder: (context, index) {
                    final product = filteredProducts[index];
                    return ProductCard(
                      product: product,
                      onEdit: () => _navigateToEdit(product),
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

  /// Navigates to the manual entry screen in edit mode.
  void _navigateToEdit(ProductModel product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductManualScreen(
          productToEdit: product,
          hiveKey: product.key as int?,
        ),
      ),
    );
  }

  /// Builds the stylized search text field.
  Widget _buildSearchBar() {
    return TextField(
      controller: _searchController,
      textInputAction: TextInputAction.search,
      onChanged: (value) => setState(() => _searchQuery = value),
      decoration: InputDecoration(
        hintText: "Buscar productos...",
        prefixIcon: const Icon(Icons.search, color: AppColors.primaryGreen),
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
    );
  }
}
