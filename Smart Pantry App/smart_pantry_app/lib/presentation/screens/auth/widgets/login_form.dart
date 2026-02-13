import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/services/auth_service.dart';
import '../../../widgets/custom_input.dart';

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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => showError = true);
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    final user = await _authService.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (mounted) {
      setState(() => isLoading = false);
      if (user == null) setState(() => showError = true);
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
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleLogin,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Iniciar Sesión",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.errorRed.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Text(
        "Correo o contraseña incorrectos",
        style: TextStyle(color: AppColors.errorText),
      ),
    );
  }
}
