// data/repo/auth_repo.dart

import 'package:evently/data/sources/auth/auth_remote.dart';
import 'package:evently/data/model/signup_model.dart';
import 'package:evently/data/model/user_model.dart';

class AuthRepo {
  final AuthRemote remote;

  // Add a constructor that accepts AuthRemote
  AuthRepo(this.remote);

  Future<UserModel> signUp(SignUpModel data) {
    return remote.signUp(data);
  }

  // You can add other methods like login, etc.
}
