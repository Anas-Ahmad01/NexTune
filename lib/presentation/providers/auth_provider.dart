import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../data/repositories/auth_repository_impl.dart';

class AuthProvider extends ChangeNotifier{
  final AuthRepositoryImpl _authRepository = AuthRepositoryImpl();

  User? _user;
  User? get user => _user;

  bool _isloading = false;
  bool get isLoading => _isloading;


  void checkAuthStatus(){
    _user = _authRepository.getCurrentUser();
    notifyListeners();
  }

  //login function
  Future<void> login(String email , String password) async{
    try{
      _isloading = true;
      notifyListeners();

      _user = await _authRepository.login(email, password);

      _isloading = false;
      notifyListeners();
    } catch (e){
      _isloading = false;
      notifyListeners();
      rethrow;
    }
  }

  //signup function

  Future<void> signup(String email , String password) async{
    try{
      _isloading = true;
      notifyListeners();

      _user = await _authRepository.signup(email, password);

      _isloading = false;
      notifyListeners();
    } catch (e){
      _isloading = false;
      notifyListeners();
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      _isloading = true;
      notifyListeners();

      await _authRepository.resetPassword(email);

      _isloading = false;
      notifyListeners();
    } catch (e) {
      _isloading = false;
      notifyListeners();
      rethrow;
    }
  }

  //logout function

  Future<void> logout() async{
    await _authRepository.logout();
    _user = null;
    notifyListeners();
}
}