import 'package:flutter/material.dart';
import '../../../core/constants/colors.dart';
import '../../../data/services/auth_service.dart';
import '../custom_input.dart';

class RegisterForm extends StatefulWidget {
  // Añadimos el callback para avisar al padre del éxito
  final VoidCallback? onRegistrationSuccess;

  const RegisterForm({super.key, this.onRegistrationSuccess});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final AuthService _authService = AuthService();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool showError = false;
  bool isLoading = false;
  String errorMessage = "Por favor completa todos los campos obligatorios";

  void _handleRegister() async {
    if (_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _confirmPasswordController.text.isEmpty) {
      setState(() {
        showError = true;
        errorMessage = "Por favor completa todos los campos obligatorios";
      });
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      setState(() {
        showError = true;
        errorMessage = "Las contraseñas no coinciden";
      });
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    final user = await _authService.registerWithEmail(
      _emailController.text.trim(),
      _passwordController.text.trim(),
      _nameController.text.trim(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      if (user != null) {
        // MOSTRAR MENSAJE DE ÉXITO
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Cuenta creada! Ya puedes iniciar sesión"),
            backgroundColor: AppColors.primaryGreen,
            duration: Duration(seconds: 3),
          ),
        );

        // EJECUTAR EL SALTO DE PESTAÑA
        if (widget.onRegistrationSuccess != null) {
          widget.onRegistrationSuccess!();
        }
      } else {
        setState(() {
          showError = true;
          errorMessage = "Error al crear la cuenta. Inténtalo de nuevo.";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          label: "Nombre completo",
          hint: "Juan Pérez",
          icon: Icons.person_outline,
          controller: _nameController,
        ),
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
        CustomInput(
          label: "Confirmar contraseña",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _confirmPasswordController,
        ),

        if (showError) _buildErrorBanner(),

        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : _handleRegister,
            icon: isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : const Icon(
                    Icons.person_add_alt_1_outlined,
                    color: Colors.white,
                  ),
            label: Text(
              isLoading ? "Creando cuenta..." : "Crear Cuenta",
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
      child: Text(
        errorMessage,
        style: const TextStyle(
          color: AppColors.errorText,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
