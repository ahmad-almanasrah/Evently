import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evently/data/repo/auth/login_repo.dart';
import 'package:evently/presentation/auth/login/login_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit(this.loginRepo) : super(LoginInitial());

  Future<void> login(String email, String password) async {
    emit(LoginLoading());

    try {
      // 1. We expect a String here (The Token), NOT a Response object
      final String? token = await loginRepo.login(email, password);

      // 2. Check if the token is valid (not empty or null)
      if (token != null && token.isNotEmpty) {
        // 3. Save it
        await saveToken(token);

        // 4. Success!
        emit(LoginSuccess());
      } else {
        emit(LoginError("Login failed: Empty token"));
      }
    } catch (e) {
      // If the Repo throws an error (like 401 or 403), we catch it here
      emit(LoginError(e.toString()));
    }
  }

  Future<void> saveToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }
}
