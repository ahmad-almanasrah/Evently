import 'package:dio/dio.dart';

class RestPasswordService {
  final Dio dio;

  RestPasswordService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://10.0.2.2:8080/auth"; // Android emulator";
    dio.options.headers["Content-Type"] = "application/json";
  }

  Future<void> restPassword(String email) async {
    try {
      final response = await dio.post(
        '/reset-password',
        data: {
          "email": email,
        },
      );

      final data = response.data;

      if (data["status"] != "success") {
        // Reset password failed or error
        throw Exception(data["message"] ?? "Reset password failed");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception(e.response?.data["message"] ??
            "Reset password failed: ${e.response?.statusCode}");
      } else {
        throw Exception("Network error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
