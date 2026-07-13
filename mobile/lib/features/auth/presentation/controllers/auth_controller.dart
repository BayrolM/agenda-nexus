import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StreamNotifierProvider<AuthNotifier, User?>(
  AuthNotifier.new,
);

class AuthNotifier extends StreamNotifier<User?> {
  @override
  Stream<User?> build() {
    final repository = ref.read(authRepositoryProvider);
    return repository.authStateChanges;
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signIn(email: email, password: password);
  }

  Future<Map<String, dynamic>?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final repository = ref.read(authRepositoryProvider);
    return await repository.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
  }

  Future<void> signOut() async {
    final repository = ref.read(authRepositoryProvider);
    await repository.signOut();
  }
}
