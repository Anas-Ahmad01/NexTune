import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository{

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> login(String email , String password) async{
    try{
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password,
      );
      return credential.user;
    } on FirebaseAuthException catch (e){
      throw Exception(e.message);
    }
  }

  @override
  Future<User?> signup(String email , String password) async{
    try{
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return credential.user;
    } on FirebaseAuthException catch(e){
      throw Exception(e.message);
    }



  }

  @override
  Future<void> logout() async{
    await _firebaseAuth.signOut();
  }

  @override
  User? getCurrentUser(){
    return _firebaseAuth.currentUser;
  }

  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

}