import 'package:flutter/material.dart';

import '../../screens/auth/auth_gate.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/bike_detail_screen.dart';
import '../../screens/customization_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const authGate = '/';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const bikeDetail = '/bike-detail';
  static const customization = '/customize';
}

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupScreen());
      case AppRoutes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case AppRoutes.bikeDetail:
        final args = settings.arguments as BikeDetailArguments;
        return MaterialPageRoute(builder: (_) => BikeDetailScreen(arguments: args));
      case AppRoutes.customization:
        final args = settings.arguments as CustomizationScreenArguments;
        return MaterialPageRoute(builder: (_) => CustomizationScreen(arguments: args));
      default:
        return MaterialPageRoute(builder: (_) => const AuthGate());
    }
  }
}
