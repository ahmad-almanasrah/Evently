import 'package:evently/data/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class SignupProvider extends ChangeNotifier {
  final AuthService authService;

  bool _isLoading = false;
  String? _errorMessage;
  bool _signupSuccess = false;

  bool get signupSuccess => _signupSuccess;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SignupProvider(this.authService);

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> signup({
    required String firstName,
    required String lastName,
    required String email,
    required String username,
    required String password,
    required String confirmPassword,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    if (firstName.isEmpty ||
        lastName.isEmpty ||
        email.isEmpty ||
        username.isEmpty ||
        password.isEmpty) {
      _errorMessage = "All fields are required.";
      _isLoading = false;
      notifyListeners();
      return;
    } else if (!RegExp(
      r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$",
    ).hasMatch(email)) {
      _errorMessage = "Please enter a valid email address.";
      _isLoading = false;
      notifyListeners();
      return;
    } else if (password.length < 6) {
      _errorMessage = "Password must be at least 6 characters long.";
      _isLoading = false;
      notifyListeners();
      return;
    } else if (username.length < 3) {
      _errorMessage = "Username must be at least 3 characters long.";
      _isLoading = false;
      notifyListeners();
      return;
    } else if (firstName.length < 2 || lastName.length < 2) {
      _errorMessage =
          "First and last names must be at least 2 characters long.";
      _isLoading = false;
      notifyListeners();
      return;
    } else if (password != confirmPassword) {
      _errorMessage = "Passwords do not match.";
      _isLoading = false;
      notifyListeners();
    }

    try {
      final response = await authService.signup(
        email,
        username,
        "$firstName $lastName",
        password,
      );

      // Check backend response for status
      if (response['status'] == 'fail') {
        _errorMessage = response['message'] ?? 'Signup failed';
        _signupSuccess = false;
      } else {
        _signupSuccess = true;
      }
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
