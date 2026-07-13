import 'dart:async';

import '../datasources/auth_remote_datasource.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;
  final _authStateController = StreamController<User?>.broadcast();

  AuthRepositoryImpl({AuthRemoteDataSource? dataSource})
      : _dataSource = dataSource ?? AuthRemoteDataSource() {
    _init();
  }

  void _init() async {
    final user = await _dataSource.getCurrentUser();
    _authStateController.add(user);
  }

  @override
  Future<User> signIn({
    required String email,
    required String password,
  }) async {
    final user = await _dataSource.signIn(email: email, password: password);
    _authStateController.add(user);
    return user;
  }

  @override
  Future<Map<String, dynamic>?> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final result = await _dataSource.signUp(
      email: email,
      password: password,
      fullName: fullName,
    );
    return result;
  }

  @override
  Future<void> signOut() async {
    await _dataSource.signOut();
    _authStateController.add(null);
  }

  @override
  Future<User?> getCurrentUser() {
    return _dataSource.getCurrentUser();
  }

  @override
  Stream<User?> get authStateChanges => _authStateController.stream;
}
