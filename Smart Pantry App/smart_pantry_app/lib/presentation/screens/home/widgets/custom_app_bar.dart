import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/services/sync_service.dart';
import 'about_dialog_content.dart';

/// A custom application bar that handles branding, cloud synchronization status,
/// and user account management.
///
/// It implements [PreferredSizeWidget] to provide a standard [AppBar] height.
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Callback triggered to show or hide the JSON debugging panel.
  final VoidCallback onToggleJsonPanel;

  const CustomAppBar({super.key, required this.onToggleJsonPanel});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  /// Signs out the current user from Firebase Authentication.
  void _handleLogout() async {
    await FirebaseAuth.instance.signOut();
  }

  /// Displays a bottom sheet with information about the app and the current user.
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
        _buildSyncIndicator(),
        IconButton(
          tooltip: "Ver JSON",
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

  /// Builds the app's logo icon wrapped in a styled container.
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

  /// Builds a reactive sync indicator that switches between a loading spinner
  /// and a "cloud done" icon based on the [SyncService] state.
  Widget _buildSyncIndicator() {
    return StreamBuilder<bool>(
      stream: SyncService().isSyncingStream,
      builder: (context, snapshot) {
        final bool isSyncing = snapshot.data ?? false;

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
              : const Tooltip(
                  message: "Sincronizado con la nube",
                  child: Icon(
                    Icons.cloud_done_outlined,
                    color: AppColors.primaryGreen,
                    size: 24,
                  ),
                ),
        );
      },
    );
  }

  /// Builds the user profile menu with account details and action buttons.
  Widget _buildUserMenu(BuildContext context, User? user) {
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
