import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../core/routes/app_router.dart';

class SignupScreen extends ConsumerStatefulWidget {
  const SignupScreen({super.key});

  @override
  ConsumerState<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends ConsumerState<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    final name = _nameController.text.trim();

    if (!Validators.isEmail(email) || !Validators.isPasswordValid(password) || !Validators.isNotEmpty(name)) {
      _showError('Enter full name, a valid email, and a strong password.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authRepositoryProvider).signUpWithEmail(email, password, name);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.authGate);
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, style: const TextStyle(color: AppColors.textHigh))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(AppStrings.signUpTitle,
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: AppColors.textHigh)),
              const SizedBox(height: 12),
              const Text('Build your MotoVerse account to save rides and customizations.',
                  style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.6)),
              const SizedBox(height: 28),
              _buildTextField('Full Name', _nameController),
              const SizedBox(height: 18),
              _buildTextField('Email', _emailController),
              const SizedBox(height: 18),
              _buildTextField('Password', _passwordController, obscureText: true),
              const SizedBox(height: 26),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Account'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushReplacementNamed(AppRoutes.login);
                },
                child: const Text('Already have an account? Log in', style: TextStyle(color: AppColors.textMedium)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool obscureText = false}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: AppColors.textHigh),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textMedium),
      ),
    );
  }
}
