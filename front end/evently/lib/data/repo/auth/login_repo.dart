import 'package:evently/data/sources/auth/login_service.dart';

class LoginRepo {
  final LoginService loginService;

  LoginRepo(this.loginService);

  Future<String?> login(String email, String password) async {
    return await loginService.login(email, password);
  }
}
