import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/services/auth_service.dart';
import '../../../widgets/custom_input.dart';

class RegisterForm extends StatefulWidget {
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
  String errorMessage = "";

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    if (email.isEmpty || pass.isEmpty || _nameController.text.isEmpty) {
      setState(() {
        showError = true;
        errorMessage = "Completa todos los campos";
      });
      return;
    }
    if (!email.contains('@')) {
      setState(() {
        showError = true;
        errorMessage = "Email inválido";
      });
      return;
    }
    if (pass.length < 6) {
      setState(() {
        showError = true;
        errorMessage = "Mínimo 6 caracteres";
      });
      return;
    }
    if (pass != _confirmPasswordController.text) {
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
      email,
      pass,
      _nameController.text.trim(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      if (user != null) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("¡Cuenta creada!")));
        widget.onRegistrationSuccess?.call();
      } else {
        setState(() {
          showError = true;
          errorMessage = "Error al crear cuenta";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomInput(
          label: "Nombre",
          hint: "Juan Pérez",
          icon: Icons.person_outline,
          controller: _nameController,
        ),
        CustomInput(
          label: "Email",
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
          label: "Confirmar",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _confirmPasswordController,
        ),
        if (showError)
          Text(
            errorMessage,
            style: const TextStyle(color: AppColors.errorText),
          ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading ? null : _handleRegister,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    "Crear Cuenta",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
