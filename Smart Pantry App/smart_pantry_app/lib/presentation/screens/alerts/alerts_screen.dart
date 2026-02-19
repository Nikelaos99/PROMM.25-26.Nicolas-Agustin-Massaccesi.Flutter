import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/alert_section.dart';

/// Screen dedicated to displaying detailed stock and expiration alerts.
///
/// It categorizes products into: Expired, Expiring Today, Expiring Soon,
/// and Low Stock, providing a visual summary at the bottom.
class AlertsScreen extends StatelessWidget {
  const AlertsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productBox = Hive.box<ProductModel>('pantry_box');

    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: ValueListenableBuilder(
        valueListenable: productBox.listenable(),
        builder: (context, Box<ProductModel> box, _) {
          final products = box.values.toList();
          final now = DateTime.now();
          final today = DateTime(now.year, now.month, now.day);

          // Filtering logic delegated to descriptive variables for clean code
          final expired = _getExpiredProducts(products, today);
          final expiresToday = _getProductsExpiringToday(products, today);
          final expiringSoon = _getProductsExpiringSoon(products, today);
          final lowStock = products.where((p) => p.quantity <= 2).toList();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. HEADER SECTION: Informative introduction card
                _buildHeaderCard(),

                const SizedBox(height: 24),

                // 2. ALERT SECTIONS: Displayed conditionally based on stock status
                if (expired.isNotEmpty)
                  AlertSection(
                    title: "⚠️ Productos Vencidos (${expired.length})",
                    icon: Icons.error_outline,
                    bgColor: AppColors.errorRed,
                    contentColor: AppColors.errorText,
                    products: expired,
                    subtitleBuilder: (p) =>
                        "Vencido hace ${today.difference(p.expiryDate!).inDays} días",
                  ),

                if (expiresToday.isNotEmpty)
                  AlertSection(
                    title: "🚨 Vencen HOY (${expiresToday.length})",
                    icon: Icons.notification_important_outlined,
                    bgColor: AppColors.warningAmber,
                    contentColor: AppColors.warningText,
                    products: expiresToday,
                    subtitleBuilder: (p) => "Vence HOY",
                  ),

                if (expiringSoon.isNotEmpty)
                  AlertSection(
                    title:
                        "⏰ Próximos a Vencer (3 días) (${expiringSoon.length})",
                    icon: Icons.timer_outlined,
                    bgColor: const Color(0xFFFFFDE7),
                    contentColor: const Color(0xFFFBC02D),
                    products: expiringSoon,
                    subtitleBuilder: (p) =>
                        "Vence en ${p.expiryDate!.difference(today).inDays} días",
                  ),

                if (lowStock.isNotEmpty)
                  AlertSection(
                    title: "📦 Bajo Stock (${lowStock.length})",
                    icon: Icons.trending_down_outlined,
                    bgColor: AppColors.infoBlue,
                    contentColor: AppColors.infoText,
                    products: lowStock,
                    subtitleBuilder: (p) =>
                        "Solo quedan ${p.quantity.toInt()} uds.",
                  ),

                // 3. SUMMARY CARD: Final overview metrics for the user
                _buildSummaryFooter(
                  expired.length,
                  expiresToday.length,
                  expiringSoon.length,
                  lowStock.length,
                ),

                const SizedBox(
                  height: 100,
                ), // Spacing for BottomNavigationBar/FAB
              ],
            ),
          );
        },
      ),
    );
  }

  // --- FILTERING LOGIC ---

  /// Returns a list of products whose expiry date is strictly before today.
  List<ProductModel> _getExpiredProducts(
    List<ProductModel> list,
    DateTime today,
  ) {
    return list
        .where((p) => p.expiryDate != null && p.expiryDate!.isBefore(today))
        .toList();
  }

  /// Returns products that expire on the current calendar day.
  List<ProductModel> _getProductsExpiringToday(
    List<ProductModel> list,
    DateTime today,
  ) {
    return list.where((p) {
      if (p.expiryDate == null) return false;
      return p.expiryDate!.year == today.year &&
          p.expiryDate!.month == today.month &&
          p.expiryDate!.day == today.day;
    }).toList();
  }

  /// Returns products expiring within the next 3 days (excluding today).
  List<ProductModel> _getProductsExpiringSoon(
    List<ProductModel> list,
    DateTime today,
  ) {
    return list.where((p) {
      if (p.expiryDate == null) return false;
      final diff = p.expiryDate!.difference(today).inDays;
      return diff > 0 && diff <= 3;
    }).toList();
  }

  // --- UI PRIVATE COMPONENTS ---

  /// Builds the top welcome card explaining the alert system.
  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Sistema de Alertas",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.textDark,
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Mantén el control de tu despensa con alertas automáticas de caducidad y stock.",
            style: TextStyle(color: AppColors.textGray, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// Builds the green footer card containing numeric summaries.
  Widget _buildSummaryFooter(int exp, int today, int soon, int stock) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Resumen de Alertas",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.6,
            children: [
              _summaryItem("$exp", "Vencidos"),
              _summaryItem("$today", "Vencen Hoy"),
              _summaryItem("$soon", "Próximos"),
              _summaryItem("$stock", "Bajo Stock"),
            ],
          ),
        ],
      ),
    );
  }

  /// Helper widget to render individual summary tiles.
  Widget _summaryItem(String count, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
