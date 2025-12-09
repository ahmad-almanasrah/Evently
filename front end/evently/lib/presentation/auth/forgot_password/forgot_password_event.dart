abstract class ForgotPasswordEvent {}

class SendOTPButtonPressed extends ForgotPasswordEvent {
  final String email;

  SendOTPButtonPressed({required this.email});
}
