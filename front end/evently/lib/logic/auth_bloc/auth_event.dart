abstract class AuthEvent {}

class SignUpEvent extends AuthEvent {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;

  SignUpEvent({
    required this.username,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });
}
