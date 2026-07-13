import 'package:flutter_dotenv/flutter_dotenv.dart';

abstract class AppConstants {
  AppConstants._();

  static const String appName = 'Agenda Nexus';
  static const String appVersion = '1.0.0';

  // Supabase - Leído del .env
  static String get supabaseUrl => dotenv.env['SUPABASE_URL'] ?? '';
  static String get supabaseAnonKey => dotenv.env['SUPABASE_ANON_KEY'] ?? '';

  // Backend API
  static String get backendUrl => dotenv.env['BACKEND_URL'] ?? 'http://localhost:3000';

  // Environment
  static bool get isDevelopment => true;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userDataKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Timeouts
  static const Duration httpTimeout = Duration(seconds: 30);
  static const Duration animationDuration = Duration(milliseconds: 300);
}
