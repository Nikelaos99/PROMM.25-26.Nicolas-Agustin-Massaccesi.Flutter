import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../../../data/services/auth_service.dart';
import '../../../widgets/custom_input.dart';

/// A stateful form widget that handles user login credentials.
///
/// This component provides the interface for email and password input,
/// manages local validation states, and communicates with the [AuthService]
/// to authenticate users via Firebase.
class LoginForm extends StatefulWidget {
  /// Creates a [LoginForm] instance.
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  /// Instance of the authentication service for login operations.
  final AuthService _authService = AuthService();

  /// Controller for the email input field.
  final _emailController = TextEditingController();

  /// Controller for the password input field.
  final _passwordController = TextEditingController();

  /// State variable to determine if the error banner should be visible.
  bool showError = false;

  /// State variable to track the asynchronous login process for the UI.
  bool isLoading = false;

  @override
  void dispose() {
    // Clean up controllers when the widget is removed from the tree
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  /// Triggers the authentication process.
  ///
  /// Validates that fields are not empty, updates the [isLoading] state,
  /// and attempts to log in. If authentication fails, [showError] is set to true.
  void _handleLogin() async {
    // Basic local validation
    if (_emailController.text.trim().isEmpty ||
        _passwordController.text.isEmpty) {
      setState(() => showError = true);
      return;
    }

    setState(() {
      isLoading = true;
      showError = false;
    });

    // Attempting login via Firebase Service
    final user = await _authService.loginWithEmail(
      _emailController.text.trim(),
      _passwordController.text,
    );

    // Guard to ensure the widget is still in the tree before updating state
    if (mounted) {
      setState(() => isLoading = false);
      if (user == null) setState(() => showError = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Reusable custom input for the email address
        CustomInput(
          label: "Correo electrónico",
          hint: "tu@email.com",
          icon: Icons.email_outlined,
          controller: _emailController,
        ),
        // Reusable custom input for the password
        CustomInput(
          label: "Contraseña",
          hint: "••••••••",
          icon: Icons.lock_outline,
          isPassword: true,
          controller: _passwordController,
        ),
        // Conditional rendering of the error message
        if (showError) _buildErrorBanner(),
        const SizedBox(height: 20),
        // Submission button with loading state support
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

  /// Helper widget that builds the error feedback banner.
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
