import 'package:dio/dio.dart';

class LoginService {
  final Dio dio;

  LoginService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://10.0.2.2:8080/auth"; // Android emulator";
    dio.options.headers["Content-Type"] = "application/json";
  }

  Future<String?> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {
          "email": email,
          "password": password,
        },
      );

      final data = response.data;

      if (data["status"] == "success") {
        return data["token"];
      } else {
        // Login failed or error
        throw Exception(data["message"] ?? "Login failed");
      }
    } on DioError catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data["message"] ??
            "Login failed: ${e.response?.statusCode}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
