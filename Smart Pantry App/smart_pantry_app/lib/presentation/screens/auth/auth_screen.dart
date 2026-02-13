import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import 'widgets/login_form.dart';
import 'widgets/register_form.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
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

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryGreen, // FONDO VERDE
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

              // Contenedor Blanco Principal
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
                    // Selector de Pestañas
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

                    // Switch entre Formularios
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: isLogin
                          ? const LoginForm()
                          : RegisterForm(
                              onRegistrationSuccess: () {
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
