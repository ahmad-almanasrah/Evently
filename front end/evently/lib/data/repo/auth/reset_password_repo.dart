import 'package:evently/data/sources/auth/reset_password_service.dart';

class ResetPasswordRepo {
  final RestPasswordService resetPasswordService;

  ResetPasswordRepo(this.resetPasswordService);

  Future<void> sendResetLink(String email) async {
    await resetPasswordService.restPassword(email);
  }
}
