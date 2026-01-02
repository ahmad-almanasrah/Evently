import 'package:dio/dio.dart';

class AuthService {
  final Dio dio;

  AuthService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/auth"; // Android emulator";
    dio.options.headers["Content-Type"] = "application/json";
  }

  Future<Map<String, dynamic>> signup(
    String email,
    String username,
    String name,
    String password,
  ) async {
    try {
      final response = await dio.post(
        '/register',
        data: {
          "email": email,
          "username": username,
          "fullName": name,
          "password": password,
        },
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["message"] ??
              "Signup failed: ${e.response?.statusCode}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/login',
        data: {"email": email, "password": password},
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(
          e.response?.data["message"] ??
              "Login failed: ${e.response?.statusCode}",
        );
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
