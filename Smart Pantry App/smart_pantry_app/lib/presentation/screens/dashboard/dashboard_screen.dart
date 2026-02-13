import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/summary_card.dart';
import 'widgets/category_item.dart';
import 'widgets/alert_card.dart';
import 'widgets/section_header.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box<ProductModel>('pantry_box');

    return ValueListenableBuilder(
      valueListenable: productBox.listenable(),
      builder: (context, Box<ProductModel> box, _) {
        final products = box.values.toList();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // Lógica de filtrado
        final lowStock = products.where((p) => p.quantity <= 2).toList();
        final expired = products
            .where((p) => p.expiryDate != null && p.expiryDate!.isBefore(today))
            .toList();
        final soon = products
            .where(
              (p) =>
                  p.expiryDate != null &&
                  p.expiryDate!.isAfter(
                    today.subtract(const Duration(seconds: 1)),
                  ) &&
                  p.expiryDate!.isBefore(today.add(const Duration(days: 4))),
            )
            .toList();

        // Estadísticas por categoría
        Map<String, List<int>> catStats = {};
        for (var p in products) {
          String cat = p.category ?? "General";
          if (!catStats.containsKey(cat)) catStats[cat] = [0, 0];
          catStats[cat]![0]++;
          catStats[cat]![1] += p.quantity;
        }

        return Scaffold(
          backgroundColor: AppColors.bgLight,
          body: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Grid de Resumen
                GridView.count(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.5,
                  children: [
                    SummaryCard(
                      title: "Total Productos",
                      value: "${products.length}",
                      icon: Icons.inventory_2,
                      iconColor: AppColors.primaryGreen,
                      iconBgColor: const Color(0xFFE1F5EA),
                    ),
                    SummaryCard(
                      title: "Bajo Stock",
                      value: "${lowStock.length}",
                      icon: Icons.trending_down,
                      iconColor: AppColors.infoText,
                      iconBgColor: AppColors.infoBlue,
                    ),
                    SummaryCard(
                      title: "Por Vencer (3 d)",
                      value: "${soon.length}",
                      icon: Icons.warning_amber_rounded,
                      iconColor: AppColors.warningText,
                      iconBgColor: AppColors.warningAmber,
                    ),
                    SummaryCard(
                      title: "Vencidos",
                      value: "${expired.length}",
                      icon: Icons.error_outline,
                      iconColor: AppColors.errorText,
                      iconBgColor: AppColors.errorRed,
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // 2. SECCIÓN: CATEGORÍAS
                _buildWhiteContainer(
                  child: Column(
                    children: [
                      const SectionHeader(
                        icon: Icons.grid_view,
                        title: "Productos por Categoría",
                      ),
                      const SizedBox(height: 16),
                      if (catStats.isEmpty)
                        const Text(
                          "No hay datos",
                          style: TextStyle(color: Colors.grey),
                        )
                      else
                        Column(
                          children: catStats.entries
                              .map(
                                (e) => CategoryItem(
                                  name: e.key,
                                  productCount: e.value[0],
                                  totalUnits: e.value[1],
                                ),
                              )
                              .toList(),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // 3. SECCIÓN: ALERTAS
                _buildWhiteContainer(
                  child: Column(
                    children: [
                      const SectionHeader(
                        icon: Icons.notifications_none,
                        title: "Resumen de Alertas",
                      ),
                      const SizedBox(height: 16),
                      AlertCard(
                        title: "Bajo Stock",
                        items: lowStock.map((p) => p.name).join(", "),
                        backgroundColor: AppColors.infoBlue,
                        textColor: AppColors.infoText,
                        icon: Icons.trending_down,
                      ),
                      const SizedBox(height: 10),
                      AlertCard(
                        title: "Vencidos",
                        items: expired.map((p) => p.name).join(", "),
                        backgroundColor: AppColors.errorRed,
                        textColor: AppColors.errorText,
                        icon: Icons.error_outline,
                      ),
                      const SizedBox(height: 10),
                      AlertCard(
                        title: "Próximos a Vencer",
                        items: soon.map((p) => p.name).join(", "),
                        backgroundColor: AppColors.warningAmber,
                        textColor: AppColors.warningText,
                        icon: Icons.warning_amber_rounded,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildWhiteContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}
