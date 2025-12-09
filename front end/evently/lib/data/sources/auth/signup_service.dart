import 'package:dio/dio.dart';

class SignupService {
  final Dio dio;

  SignupService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/auth";
    dio.options.headers["Content-Type"] = "application/json";
  }

  Future<void> signup(
      String username, String email, String password, String fullName) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          "username": username,
          "email": email,
          "password": password,
          "fullName": fullName,
        },
      );

      if (response.statusCode == 200) {
        final status = response.data['status'];
        final message = response.data['message'];

        if (status == 'success') {
          // User created successfully
          return;
        } else {
          // Something failed
          throw Exception(message ?? "Signup failed");
        }
      } else {
        throw Exception(
            "Signup request failed with status ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(
          e.response?.data['message'] ?? "Network error: ${e.message}");
    }
  }
}
