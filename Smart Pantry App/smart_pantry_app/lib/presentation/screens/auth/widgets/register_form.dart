import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/services/auth_service.dart';
import '../../../widgets/custom_input.dart';

/// A stateful form widget that handles the user registration process.
///
/// This component collects user details (name, email, password), performs
/// basic client-side validation, and interfaces with [AuthService] to
/// create new credentials in Firebase. It notifies the parent widget
/// upon successful account creation.
class RegisterForm extends StatefulWidget {
  /// Callback function triggered when the registration process completes successfully.
  final VoidCallback? onRegistrationSuccess;

  /// Creates a [RegisterForm] instance.
  const RegisterForm({super.key, this.onRegistrationSuccess});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  /// Authentication service instance for registration logic.
  final AuthService _authService = AuthService();

  // Text controllers to capture and manage user input
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  /// Flag to indicate if a validation or server error should be displayed.
  bool showError = false;

  /// Flag to track the asynchronous status of the registration request.
  bool isLoading = false;

  /// The specific message to display in case of an error.
  String errorMessage = "";

  @override
  void dispose() {
    // Release resources by disposing controllers when the widget is destroyed
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Validates input data and attempts to create a new user account.
  ///
  /// Checks for empty fields, email format, password length, and
  /// password matching before calling the backend service.
  void _handleRegister() async {
    final email = _emailController.text.trim();
    final pass = _passwordController.text;

    // Client-side validation logic
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

    // Invoke the Firebase registration service
    final user = await _authService.registerWithEmail(
      email,
      pass,
      _nameController.text.trim(),
    );

    if (mounted) {
      setState(() => isLoading = false);
      if (user != null) {
        // Notify user and trigger success callback
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
        // Name input field
        CustomInput(
          label: "Nombre",
          hint: "Juan Pérez",
          icon: Icons.person_outline,
          controller: _nameController,
        ),
        // Email input field
        CustomInput(
          label: "Email",
          hint: "tu@email.com",
          icon: Icons.email_outlined,
          controller: _emailController,
        ),
        // Primary password input field
        CustomInput(
          label: "Contraseña",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
        ),
        // Password confirmation input field
        CustomInput(
          label: "Confirmar",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _confirmPasswordController,
        ),
        // Display validation or server error messages
        if (showError)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              errorMessage,
              style: const TextStyle(color: AppColors.errorText),
            ),
          ),
        const SizedBox(height: 10),
        // Submission button with integrated loading state
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
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
