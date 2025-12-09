import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:evently/data/repo/auth/signup_repo.dart';
import 'package:evently/presentation/auth/signup/signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupRepo signupRepo;

  SignupCubit(this.signupRepo) : super(SignupInitial());

  Future<void> signup(String username, String email, String password,
      String firstName, String lastName) async {
    // --- STEP 1: VALIDATE FIRST (Do NOT emit Loading yet) ---
    if (username.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        firstName.isEmpty ||
        lastName.isEmpty) {
      emit(SignupError("All fields are required"));
      return; // Stop execution here so the UI shows the Red Box
    }

    if (password.length < 8) {
      emit(SignupError("Password must be at least 8 characters long"));
      return;
    }

    if (!RegExp("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$")
        .hasMatch(email)) {
      emit(SignupError("Invalid email format"));
      return;
    }

    // --- STEP 2: NOW EMIT LOADING ---
    emit(SignupLoading());

    try {
      await signupRepo.signup(
        username: username,
        email: email,
        password: password,
        fullName: '$firstName $lastName',
      );
      emit(SignupSuccess());
    } catch (e) {
      emit(SignupError(e.toString()));
    }
  }
}
