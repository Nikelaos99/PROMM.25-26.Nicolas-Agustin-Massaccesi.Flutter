import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/colors.dart';

/// A detailed bottom sheet content displaying application information,
/// current user details, and key app features.
///
/// Designed to be used within a [showModalBottomSheet] and takes up
/// most of the screen height.
class AboutDialogContent extends StatelessWidget {
  /// The currently authenticated user from Firebase.
  final User? user;

  const AboutDialogContent({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Responsive height at 90% of the screen
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // 1. STICKY HEADER
          _buildHeader(context),

          // 2. SCROLLABLE BODY
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // USER PROFILE SECTION
                _buildUserSection(),

                // APP INFO SECTION
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Acerca de la App",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "Smart Pantry App es una aplicación móvil diseñada para ayudarte a gestionar el inventario de alimentos en tu hogar y evitar desperdicios. Mantén el control total de tu despensa con alertas inteligentes y herramientas útiles.",
                        style: TextStyle(
                          color: AppColors.textGray,
                          height: 1.5,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Características",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const SizedBox(height: 16),

                      _buildFeatureItem(
                        Icons.inventory_2_outlined,
                        "Gestión de Inventario",
                        "Organiza tus productos por categorías y cantidades",
                        const Color(0xFFE1F5EA),
                        AppColors.primaryGreen,
                      ),
                      _buildFeatureItem(
                        Icons.notifications_none_outlined,
                        "Alertas de Caducidad",
                        "Recibe notificaciones de productos próximos a vencer",
                        AppColors.warningAmber,
                        AppColors.warningText,
                      ),
                      _buildFeatureItem(
                        Icons.qr_code_scanner,
                        "Escaneo de Códigos",
                        "Añade productos fácilmente con OpenFoodFacts API",
                        const Color(0xFFE3F2FD),
                        Colors.blue.shade700,
                      ),
                      _buildFeatureItem(
                        Icons.low_priority,
                        "Control de Bajo Stock",
                        "Identifica productos que necesitan reabastecerse",
                        const Color(0xFFF3E5F5),
                        Colors.purple.shade700,
                      ),

                      const SizedBox(height: 40),
                      _buildFooter(),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the top green header with the logo and app name.
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 30),
      decoration: const BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Row(
            children: [
              Container(
                height: 70,
                width: 70,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Image.asset(
                  'assets/images/icon_pantry.png',
                  fit: BoxFit.contain,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Smart Pantry App",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Versión 1.0.0",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds the section showing the currently logged-in user info.
  Widget _buildUserSection() {
    return Container(
      width: double.infinity,
      color: AppColors.bgLight,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Usuario Actual",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF004D40),
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoTile(
            Icons.person_2_outlined,
            "Nombre",
            user?.displayName ?? "No disponible",
          ),
          _buildInfoTile(
            Icons.email_outlined,
            "Correo",
            user?.email ?? "No disponible",
          ),
        ],
      ),
    );
  }

  /// Internal helper to build user information rows.
  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColors.primaryGreen, size: 22),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 13, color: AppColors.textGray),
              ),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF004D40),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Internal helper to build feature description rows.
  Widget _buildFeatureItem(
    IconData icon,
    String title,
    String desc,
    Color bg,
    Color iconCol,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconCol, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  desc,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textGray,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the copyright and development attribution footer.
  Widget _buildFooter() {
    return Center(
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Desarrollado con ",
                style: TextStyle(fontSize: 12, color: AppColors.textGray),
              ),
              const Icon(Icons.favorite, color: Colors.red, size: 14),
              const Text(
                " para ti",
                style: TextStyle(fontSize: 12, color: AppColors.textGray),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "© 2026 Smart Pantry App",
            style: TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const Text(
            "Todos los derechos reservados.",
            style: TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
