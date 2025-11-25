import 'package:evently/data/repo/auth/login_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepo loginRepo;

  LoginBloc(this.loginRepo) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final token = await loginRepo.login(event.email, event.password);

        if (token != null) {
          emit(LoginSuccess());
        } else {
          emit(LoginError("Invalid email or password"));
        }
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
}
