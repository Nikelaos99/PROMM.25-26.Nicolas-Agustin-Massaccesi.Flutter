import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

/// Screen that handles user authentication, providing both Login and Registration interfaces.
///
/// This screen uses a [StatefulWidget] to manage the toggle between the login
/// and registration forms. It features a modern UI with a custom tab switcher
/// and smooth transitions.
class AuthScreen extends StatefulWidget {
  /// Creates an [AuthScreen] instance.
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  /// Local state to track which form is currently active.
  /// `true` for Login, `false` for Registration.
  bool isLogin = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              const SizedBox(height: 40),

              // Application Branding / Logo Container
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Image.asset('assets/images/icon_pantry.png', height: 50),
              ),

              const SizedBox(height: 16),
              // Main Title and Subtitle
              Text(
                "Smart Pantry App",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const Text(
                "Gestiona tu inventario de alimentos",
                style: TextStyle(color: AppColors.textGray),
              ),
              const SizedBox(height: 30),

              // Main Authentication Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 10,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // Custom Tab Switcher (Login vs Register)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          _buildTabButton(
                            "Iniciar Sesión",
                            isLogin,
                            () => setState(() => isLogin = true),
                          ),
                          _buildTabButton(
                            "Registrarse",
                            !isLogin,
                            () => setState(() => isLogin = false),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 25),

                    // Animated form switcher based on current state
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLogin
                          ? const LoginForm()
                          : RegisterForm(
                              onRegistrationSuccess: () {
                                // Automatically switch back to login upon successful registration
                                setState(() {
                                  isLogin = true;
                                });
                              },
                            ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper method to build a custom tab button.
  ///
  /// Takes a [title], an [active] status for styling, and an [onTap] callback.
  Widget _buildTabButton(String title, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: active
                ? [const BoxShadow(color: Colors.black12, blurRadius: 4)]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: active ? AppColors.primaryGreen : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
