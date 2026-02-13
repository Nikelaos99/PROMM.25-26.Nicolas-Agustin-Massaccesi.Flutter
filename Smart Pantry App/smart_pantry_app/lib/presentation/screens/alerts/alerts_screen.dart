import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../data/models/product_model.dart';
import '../../../core/constants/colors.dart';
import 'widgets/alert_section.dart';

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

          // Filtros basados en la lógica de negocio
          final expired = products.where((p) {
            if (p.expiryDate == null) return false;
            return p.expiryDate!.isBefore(today);
          }).toList();

          final expiresToday = products.where((p) {
            if (p.expiryDate == null) return false;
            return p.expiryDate!.year == today.year &&
                p.expiryDate!.month == today.month &&
                p.expiryDate!.day == today.day;
          }).toList();

          final expiringSoon = products.where((p) {
            if (p.expiryDate == null) return false;
            final diff = p.expiryDate!.difference(today).inDays;
            return diff > 0 && diff <= 3;
          }).toList();

          final lowStock = products.where((p) => p.quantity <= 2).toList();

          if (products.isEmpty) {
            return const Center(child: Text("No hay productos en tu despensa"));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Sistema de Alertas",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  "Control de caducidad y stock en tiempo real",
                  style: TextStyle(color: AppColors.textGray, fontSize: 14),
                ),
                const SizedBox(height: 24),

                if (expired.isNotEmpty)
                  AlertSection(
                    title: "Productos Vencidos (${expired.length})",
                    icon: Icons.dangerous_outlined,
                    bgColor: AppColors.errorRed,
                    contentColor: AppColors.errorText,
                    products: expired,
                    subtitleBuilder: (p) =>
                        "Vencido hace ${today.difference(p.expiryDate!).inDays} días",
                  ),

                if (expiresToday.isNotEmpty)
                  AlertSection(
                    title: "Vencen HOY (${expiresToday.length})",
                    icon: Icons.notification_important_outlined,
                    bgColor: AppColors.warningAmber,
                    contentColor: AppColors.warningText,
                    products: expiresToday,
                    subtitleBuilder: (p) => "¡Consumir hoy!",
                  ),

                if (expiringSoon.isNotEmpty)
                  AlertSection(
                    title: "Próximos a Vencer (${expiringSoon.length})",
                    icon: Icons.timer_outlined,
                    bgColor: AppColors.warningAmber,
                    contentColor: AppColors.warningText,
                    products: expiringSoon,
                    subtitleBuilder: (p) =>
                        "Vence en ${p.expiryDate!.difference(today).inDays} días",
                  ),

                if (lowStock.isNotEmpty)
                  AlertSection(
                    title: "Bajo Stock (${lowStock.length})",
                    icon: Icons.trending_down_outlined,
                    bgColor: AppColors.infoBlue,
                    contentColor: AppColors.infoText,
                    products: lowStock,
                    subtitleBuilder: (p) => "Solo quedan ${p.quantity} uds.",
                  ),

                const SizedBox(height: 8),
                _buildSummaryCard(
                  expired.length,
                  expiresToday.length,
                  expiringSoon.length,
                  lowStock.length,
                ),
                const SizedBox(height: 100),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSummaryCard(int exp, int today, int soon, int stock) {
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
            "Resumen General",
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
            childAspectRatio: 2.5,
            children: [
              _summaryItem("$exp", "Vencidos"),
              _summaryItem("$today", "Hoy"),
              _summaryItem("$soon", "Próximos"),
              _summaryItem("$stock", "Stock"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String count, String label) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
