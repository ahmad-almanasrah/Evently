import 'package:evently/data/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginProvider extends ChangeNotifier {
  final AuthService authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _loginSuccess = false;

  void reset() {
    _loginSuccess = false;
    _errorMessage = null;
    _isLoading = false;
    notifyListeners();
  }

  bool get loginSuccess => _loginSuccess;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  LoginProvider(this.authService);

  Future<void> login({required String email, required String password}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (email.isEmpty || password.isEmpty) {
      _errorMessage = "Email and password are required.";
      _isLoading = false;
      notifyListeners();
      return;
    }

    try {
      final response = await authService.login(email, password);
      if (response["status"] != "success") {
        _errorMessage = response["message"] ?? "Login failed.";
        _isLoading = false;
        notifyListeners();
        return;
      } else {
        final token = response['token']; // adjust key to match backend
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('jwt_token', token);
        }
        _loginSuccess = true;
      }
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
