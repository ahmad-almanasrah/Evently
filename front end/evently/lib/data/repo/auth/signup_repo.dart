import 'package:evently/data/sources/auth/signup_service.dart';

class SignupRepo {
  final SignupService signupService;

  SignupRepo({required this.signupService});

  Future<void> signup({
    required String username,
    required String email,
    required String password,
    required String fullName,
  }) async {
    try {
      await signupService.signup(username, email, password, fullName);
    } catch (e) {
      // Bubble up the error to the Bloc
      rethrow;
    }
  }
}
