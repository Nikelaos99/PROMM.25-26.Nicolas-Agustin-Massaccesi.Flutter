import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/summary_card.dart';
import 'widgets/category_item.dart';
import 'widgets/alert_card.dart';
import 'widgets/section_header.dart';

/// The central hub of the application that provides an analytical overview
/// of the pantry status.
///
/// This screen processes raw data from [Hive] to display inventory metrics,
/// stock alerts, and category distribution in real-time.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Accessing the Hive box directly for reactive updates via ValueListenableBuilder
    final productBox = Hive.box<ProductModel>('pantry_box');

    return ValueListenableBuilder(
      valueListenable: productBox.listenable(),
      builder: (context, Box<ProductModel> box, _) {
        final products = box.values.toList();
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);

        // 1. Filtering logic for inventory alerts
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

        // 2. Statistical breakdown by category
        // Key: Category name, Value: [Product Count, Total Units]
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
                // METRICS GRID SECTION: Quick stats overview
                _buildSummaryGrid(
                  products.length,
                  lowStock.length,
                  soon.length,
                  expired.length,
                ),

                const SizedBox(height: 16),

                // CATEGORY DISTRIBUTION SECTION: Breakdown of inventory by group
                _buildWhiteContainer(
                  child: Column(
                    children: [
                      const SectionHeader(
                        icon: Icons.grid_view,
                        title: "Productos por Categoría",
                      ),
                      const SizedBox(height: 16),
                      if (catStats.isEmpty)
                        const _EmptyDashboardState(
                          message: "No hay datos de categorías disponibles",
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

                // ALERT SUMMARY SECTION: Important notifications for the user
                _buildWhiteContainer(
                  child: Column(
                    children: [
                      const SectionHeader(
                        icon: Icons.notifications_none,
                        title: "Resumen de Alertas",
                      ),
                      const SizedBox(height: 16),
                      _buildAlerts(lowStock, expired, soon),
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

  // --- PRIVATE UI COMPONENTS ---

  /// Builds a 2x2 grid of [SummaryCard] widgets for high-level metrics.
  Widget _buildSummaryGrid(int total, int low, int soon, int expired) {
    return GridView.count(
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
          value: "$total",
          icon: Icons.inventory_2,
          iconColor: AppColors.primaryGreen,
          iconBgColor: const Color(0xFFE1F5EA),
        ),
        SummaryCard(
          title: "Stock Bajo",
          value: "$low",
          icon: Icons.trending_down,
          iconColor: AppColors.infoText,
          iconBgColor: AppColors.infoBlue,
        ),
        SummaryCard(
          title: "Caduca (3d)",
          value: "$soon",
          icon: Icons.warning_amber_rounded,
          iconColor: AppColors.warningText,
          iconBgColor: AppColors.warningAmber,
        ),
        SummaryCard(
          title: "Caducados",
          value: "$expired",
          icon: Icons.error_outline,
          iconColor: AppColors.errorText,
          iconBgColor: AppColors.errorRed,
        ),
      ],
    );
  }

  /// Organizes and builds the list of [AlertCard] based on inventory status.
  Widget _buildAlerts(
    List<ProductModel> low,
    List<ProductModel> exp,
    List<ProductModel> soon,
  ) {
    return Column(
      children: [
        AlertCard(
          title: "Productos con poco stock",
          items: low.isEmpty ? "Ninguno" : low.map((p) => p.name).join(", "),
          backgroundColor: AppColors.infoBlue,
          textColor: AppColors.infoText,
          icon: Icons.trending_down,
        ),
        const SizedBox(height: 10),
        AlertCard(
          title: "Productos caducados",
          items: exp.isEmpty ? "Ninguno" : exp.map((p) => p.name).join(", "),
          backgroundColor: AppColors.errorRed,
          textColor: AppColors.errorText,
          icon: Icons.error_outline,
        ),
        const SizedBox(height: 10),
        AlertCard(
          title: "Caducan pronto",
          items: soon.isEmpty ? "Ninguno" : soon.map((p) => p.name).join(", "),
          backgroundColor: AppColors.warningAmber,
          textColor: AppColors.warningText,
          icon: Icons.warning_amber_rounded,
        ),
      ],
    );
  }

  /// A reusable styled container for dashboard sections to maintain consistency.
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

/// Internal widget to handle empty states within the dashboard sections.
class _EmptyDashboardState extends StatelessWidget {
  /// The message to display when a section has no data.
  final String message;

  const _EmptyDashboardState({required this.message});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
