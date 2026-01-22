import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/auth_service.dart';
import '../custom_input.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final AuthService _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool showError = false;
  bool isLoading = false;

  void _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      setState(() => showError = true);
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    final user = await _authService.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      if (user != null) {
        // Inicio de sesión exitoso
        print("Sesión iniciada: ${user.email}");
      } else {
        setState(() => showError = true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          label: "Correo electrónico",
          hint: "tu@email.com",
          icon: Icons.email_outlined,
          controller: _emailController,
        ),
        CustomInput(
          label: "Contraseña",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
        ),

        if (showError) _buildErrorBanner(),

        const SizedBox(height: 20),

        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _handleLogin,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(Icons.login, color: Colors.white),
            label: Text(
              isLoading ? "Entrando..." : "Iniciar Sesión",
              style: const TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        _buildNoteBox(),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.errorRed,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.errorText.withOpacity(0.3)),
      ),
      child: const Text(
        "Credenciales incorrectas o campos vacíos",
        style: TextStyle(
          color: AppColors.errorText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildNoteBox() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.infoBlue,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Sincronización activa con Firebase habilitada.",
        style: TextStyle(color: Colors.blue, fontSize: 12),
        textAlign: TextAlign.center,
      ),
    );
  }
}
