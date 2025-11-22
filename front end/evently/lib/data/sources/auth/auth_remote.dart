import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:evently/data/model/signup_model.dart';
import 'package:evently/data/model/user_model.dart';

class AuthRemote {
  final String baseUrl = "http://10.0.2.2:8080"; // Android emulator

  Future<UserModel> signUp(SignUpModel signUpData) async {
    final url = Uri.parse("$baseUrl/auth/register");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(signUpData.toJson()), // use actual data
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return UserModel.fromJson(data); // map backend response
    } else {
      throw Exception(
          "SignUp failed with status: ${response.statusCode}, ${response.body}");
    }
  }
}
