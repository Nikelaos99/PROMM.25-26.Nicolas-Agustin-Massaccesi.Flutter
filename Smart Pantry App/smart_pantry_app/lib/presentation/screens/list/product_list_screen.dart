import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/product_card.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  // Controlador para el campo de texto
  final TextEditingController _searchController = TextEditingController();
  // Variable para almacenar el término de búsqueda
  String _searchQuery = "";

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Función para eliminar acentos y diacríticos
  String _removeAccents(String text) {
    const withAccents = 'áéíóúüñÁÉÍÓÚÜÑ';
    const withoutAccents = 'aeiouunAEIOUUN';

    for (int i = 0; i < withAccents.length; i++) {
      text = text.replaceAll(withAccents[i], withoutAccents[i]);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box<ProductModel>('pantry_box');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Buscador superior
          TextField(
            controller: _searchController,
            textInputAction:
                TextInputAction.search, // Cambia botón "Intro" por Lupa
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
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
                        setState(() {
                          _searchQuery = "";
                        });
                      },
                    )
                  : null,
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Lista de productos filtrada
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: productBox.listenable(),
              builder: (context, Box<ProductModel> box, _) {
                if (box.isEmpty) {
                  return const Center(
                    child: Text("Tu despensa está vacía. ¡Empieza a escanear!"),
                  );
                }

                // 1. Obtener lista base
                final allProducts = box.values.toList().reversed.toList();

                // 2. Normalizar la consulta de búsqueda una sola vez
                final queryNormalized = _removeAccents(
                  _searchQuery.toLowerCase(),
                );

                // 3. Aplicar el filtro ignorando acentos en nombre, marca y categoría
                final filteredProducts = allProducts.where((product) {
                  final nameNorm = _removeAccents(product.name.toLowerCase());
                  final brandNorm = _removeAccents(
                    (product.brand ?? "").toLowerCase(),
                  );
                  final catNorm = _removeAccents(
                    (product.category ?? "").toLowerCase(),
                  );

                  return nameNorm.contains(queryNormalized) ||
                      brandNorm.contains(queryNormalized) ||
                      catNorm.contains(queryNormalized);
                }).toList();

                if (filteredProducts.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.search_off,
                          size: 60,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "No hay resultados para \"$_searchQuery\"",
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ],
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
                      onEdit: () {
                        // Implementaremos luego
                      },
                      onDelete: () => product.delete(),
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
