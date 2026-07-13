import '../entities/user.dart';

abstract class AuthRepository {
  Future<User> signIn({
    required String email,
    required String password,
  });

  Future<Map<String, dynamic>?> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> signOut();

  Future<User?> getCurrentUser();

  Stream<User?> get authStateChanges;
}
