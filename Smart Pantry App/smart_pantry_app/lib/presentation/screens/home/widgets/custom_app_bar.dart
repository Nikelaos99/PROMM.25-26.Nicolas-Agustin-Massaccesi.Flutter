import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/colors.dart';
// Asumiendo que tu SyncService tiene un stream de estado, si no, usaremos un ejemplo básico
import '../../../../data/services/sync_service.dart';
import 'about_dialog_content.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onToggleJsonPanel;

  const CustomAppBar({super.key, required this.onToggleJsonPanel});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
  }

  void _showAboutModal(BuildContext context, User? user) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) => AboutDialogContent(user: user),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: false,
      leadingWidth: 56,
      leading: _buildLogo(),
      title: const Text(
        "Smart Pantry App",
        style: TextStyle(
          color: Color(0xFF004D40),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        // --- AQUÍ ESTÁ EL ICONO DE LA NUBE ---
        _buildSyncIndicator(),
        IconButton(
          icon: const Icon(
            Icons.description_outlined,
            color: Color(0xFF004D40),
          ),
          onPressed: onToggleJsonPanel,
        ),
        _buildUserMenu(context, user),
        const SizedBox(width: 8),
      ],
    );
  }

  // Widget separado para el logo leading
  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, top: 8, bottom: 8),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primaryGreen,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.asset(
            'assets/images/icon_pantry.png',
            color: Colors.white,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }

  // INDICADOR DE SINCRONIZACIÓN
  Widget _buildSyncIndicator() {
    // Usamos el Stream de SyncService para saber si está trabajando
    return StreamBuilder<bool>(
      stream: SyncService()
          .isSyncingStream, // Necesitarás crear este getter en tu SyncService
      builder: (context, snapshot) {
        bool isSyncing = snapshot.data ?? false;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: isSyncing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        AppColors.primaryGreen,
                      ),
                    ),
                  ),
                )
              : const Icon(
                  Icons.cloud_done_outlined,
                  color: AppColors.primaryGreen,
                  size: 24,
                ),
        );
      },
    );
  }

  Widget _buildUserMenu(BuildContext context, User? user) {
    // ... (Tu código de _buildUserMenu se mantiene igual)
    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: PopupMenuButton<String>(
        offset: const Offset(0, 52),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.person_outline, color: Color(0xFF004D40)),
        onSelected: (value) {
          if (value == 'logout') {
            _handleLogout();
          } else if (value == 'about') {
            _showAboutModal(context, user);
          }
        },
        itemBuilder: (context) => [
          PopupMenuItem(
            enabled: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user?.displayName ?? "Usuario",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D1B20),
                    fontSize: 16,
                  ),
                ),
                Text(
                  user?.email ?? "Sin correo",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF49454F),
                  ),
                ),
                const Divider(thickness: 1, height: 20),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'about',
            child: Row(
              children: [
                Icon(
                  Icons.info_outline,
                  color: AppColors.primaryGreen,
                  size: 20,
                ),
                SizedBox(width: 12),
                Text("Acerca de"),
              ],
            ),
          ),
          const PopupMenuItem(
            value: 'logout',
            child: Row(
              children: [
                Icon(Icons.logout_outlined, color: Colors.red, size: 20),
                SizedBox(width: 12),
                Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
