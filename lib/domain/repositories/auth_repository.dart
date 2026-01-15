import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<User?> login(String email , String password);

  Future<User?> signup(String email , String password);

  Future<void> logout();

  User? getCurrentUser();
}