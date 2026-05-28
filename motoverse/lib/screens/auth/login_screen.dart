import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../../core/utils/validators.dart';
import '../../providers/auth_provider.dart';
import '../../core/routes/app_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _submit() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    if (!Validators.isEmail(email) || !Validators.isPasswordValid(password)) {
      _showError('Enter a valid email and password with at least 8 characters.');
      return;
    }
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authRepositoryProvider).signInWithEmail(email, password);
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.authGate);
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await ref.read(authRepositoryProvider).signinWithGoogle();
      if (!mounted) return;
      Navigator.of(context).pushReplacementNamed(AppRoutes.authGate);
    } catch (error) {
      _showError(error.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              const Text(AppStrings.signInTitle,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.textHigh)),
              const SizedBox(height: 10),
              const Text(AppStrings.homeSubhead,
                  style: TextStyle(color: AppColors.textMedium, fontSize: 15, height: 1.6)),
              const SizedBox(height: 32),
              _buildTextField('Email', _emailController),
              const SizedBox(height: 18),
              _buildTextField('Password', _passwordController, obscureText: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _submit,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Log In'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.signup);
                },
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.accent),
                ),
                child: const Text('Create account'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(AppRoutes.forgotPassword);
                },
                child: const Text('Forgot password?', style: TextStyle(color: AppColors.accentSoft)),
              ),
              const SizedBox(height: 22),
              const Divider(color: Colors.white10),
              const SizedBox(height: 18),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _signInWithGoogle,
                icon: const Icon(Icons.login),
                label: const Text('Continue with Google'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.surfaceAlt),
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
