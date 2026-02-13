import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/colors.dart';

class AboutDialogContent extends StatelessWidget {
  final User? user;
  const AboutDialogContent({super.key, this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      // Mantenemos el alto al 90% de la pantalla
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        children: [
          // 1. HEADER FIJO (No se mueve al hacer scroll)
          Container(
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
                        // Si no tienes el asset aún, puedes usar:
                        // child: Icon(Icons.shopping_bag, color: AppColors.primaryGreen, size: 40),
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
          ),

          // 2. CUERPO CON SCROLL
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                // SECCIÓN DE USUARIO
                Container(
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
                ),

                // SECCIÓN DE INFORMACIÓN Y CARACTERÍSTICAS
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

                      // Característica 1
                      _buildFeatureItem(
                        Icons.inventory_2_outlined,
                        "Gestión de Inventario",
                        "Organiza tus productos por categorías y cantidades",
                        const Color(0xFFE1F5EA),
                        AppColors.primaryGreen,
                      ),
                      // Característica 2
                      _buildFeatureItem(
                        Icons.notifications_none_outlined,
                        "Alertas de Caducidad",
                        "Recibe notificaciones de productos próximos a vencer",
                        AppColors.warningAmber,
                        AppColors.warningText,
                      ),
                      // Característica 3 - NUEVA
                      _buildFeatureItem(
                        Icons.qr_code_scanner,
                        "Escaneo de Códigos",
                        "Añade productos fácilmente con OpenFoodFacts API",
                        const Color(0xFFE3F2FD),
                        Colors.blue.shade700,
                      ),
                      // Característica 4 - NUEVA
                      _buildFeatureItem(
                        Icons.low_priority,
                        "Control de Bajo Stock",
                        "Identifica productos que necesitan reabastecerse",
                        const Color(0xFFF3E5F5),
                        Colors.purple.shade700,
                      ),

                      const SizedBox(height: 40),

                      // PIE DE PÁGINA
                      Center(
                        child: Column(
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  "Desarrollado con ",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGray,
                                  ),
                                ),
                                Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                  size: 14,
                                ),
                                const Text(
                                  " para ti",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "© 2026 Smart Pantry App",
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                              ),
                            ),
                            const Text(
                              "Todos los derechos reservados.",
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
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
}
