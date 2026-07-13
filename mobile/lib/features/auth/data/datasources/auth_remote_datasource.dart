import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/user.dart' as app;

class AuthException implements Exception {
  final String message;
  const AuthException(this.message);
  @override
  String toString() => message;
}

class AuthRemoteDataSource {
  final http.Client _httpClient;

  AuthRemoteDataSource({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  String get _baseUrl => '${AppConstants.backendUrl}/api/auth';

  Future<app.User> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/login'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(AppConstants.httpTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthException(data['error'] ?? 'Error al iniciar sesión');
      }

      await _saveSession(data['token'], data['user']);

      return app.User.fromJson(data['user']);
    } on AuthException {
      rethrow;
    } on http.ClientException {
      throw const AuthException('Error de conexión. Verifica tu internet');
    } catch (e) {
      throw const AuthException('Error inesperado al iniciar sesión');
    }
  }

  Future<Map<String, dynamic>?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/register'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'email': email,
              'password': password,
              'fullName': fullName,
            }),
          )
          .timeout(AppConstants.httpTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthException(data['error'] ?? 'Error al registrar');
      }

      if (data['requiresVerification'] == true) {
        return data;
      }

      if (data['token'] != null && data['user'] != null) {
        await _saveSession(data['token'], data['user']);
      }

      return data;
    } on AuthException {
      rethrow;
    } on http.ClientException {
      throw const AuthException('Error de conexion. Verifica tu internet');
    } catch (e) {
      throw const AuthException('Error inesperado al crear la cuenta');
    }
  }

  Future<void> verifyEmail({
    required String userId,
    required String code,
  }) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/verify-email'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': userId, 'code': code}),
          )
          .timeout(AppConstants.httpTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthException(data['error'] ?? 'Error al verificar');
      }
    } on AuthException {
      rethrow;
    } on http.ClientException {
      throw const AuthException('Error de conexion. Verifica tu internet');
    } catch (e) {
      throw const AuthException('Error inesperado al verificar');
    }
  }

  Future<void> resendCode({required String userId}) async {
    try {
      final response = await _httpClient
          .post(
            Uri.parse('$_baseUrl/resend-code'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'userId': userId}),
          )
          .timeout(AppConstants.httpTimeout);

      final data = jsonDecode(response.body);

      if (response.statusCode != 200) {
        throw AuthException(data['error'] ?? 'Error al reenviar codigo');
      }
    } on AuthException {
      rethrow;
    } on http.ClientException {
      throw const AuthException('Error de conexion. Verifica tu internet');
    } catch (e) {
      throw const AuthException('Error inesperado al reenviar codigo');
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.authTokenKey);
    await prefs.remove(AppConstants.userDataKey);
  }

  Future<app.User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AppConstants.authTokenKey);
    final userData = prefs.getString(AppConstants.userDataKey);

    if (token == null || userData == null) return null;

    try {
      return app.User.fromJson(jsonDecode(userData));
    } catch (_) {
      return null;
    }
  }

  Stream<app.User?> get authStateChanges async* {
    final user = await getCurrentUser();
    yield user;
  }

  Future<void> _saveSession(String token, Map<String, dynamic> user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConstants.authTokenKey, token);
    await prefs.setString(AppConstants.userDataKey, jsonEncode(user));
  }
}
