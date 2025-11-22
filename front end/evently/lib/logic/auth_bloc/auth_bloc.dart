import 'package:bloc/bloc.dart';
import 'package:evently/data/repo/auth/auth_repo.dart';
import '../../data/model/signup_model.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo repo;

  AuthBloc(this.repo) : super(AuthInitial()) {
    on<SignUpEvent>((event, emit) async {
      // Password validations
      if (event.password != event.confirmPassword) {
        emit(AuthError("Passwords do not match"));
        return;
      }

      if (event.password.length < 8) {
        emit(AuthError("Password must be at least 8 characters long"));
        return;
      }

      final hasLetter = RegExp(r'[A-Za-z]').hasMatch(event.password);
      final hasNumber = RegExp(r'\d').hasMatch(event.password);
      if (!hasLetter || !hasNumber) {
        emit(AuthError("Password must contain both letters and numbers"));
        return;
      }

      emit(AuthLoading());

      try {
        final signUpData = SignUpModel(
          name: event.username,
          email: event.email,
          password: event.password,
        );

        final user = await repo.signUp(signUpData);
        emit(AuthSignUpSuccess("Sign up successful! Welcome ${user.email}"));
      } catch (e) {
        emit(AuthError("Sign up failed: ${e.toString()}"));
      }
    });
  }
}
