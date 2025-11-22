abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignUpSuccess extends AuthState {
  final String message; // or your UserModel if you want

  AuthSignUpSuccess(this.message);
}

class AuthError extends AuthState {
  final String error;

  AuthError(this.error);
}
