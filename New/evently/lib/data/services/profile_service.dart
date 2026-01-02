import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final Dio dio;

  ProfileService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/home";
    dio.options.headers["Content-Type"] = "application/json";
  }

  // ---------------- FETCH PROFILE ----------------
  Future<Map<String, dynamic>> fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    if (token == null) {
      throw Exception("Authentication error. Please log in again.");
    }

    try {
      final response = await dio.get(
        "/profile",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode == 200 && response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else {
        throw Exception("Failed to load profile data.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Unable to fetch profile.",
      );
    }
  }

  // ---------------- UPDATE PROFILE PICTURE ----------------
  Future<void> updatePicture(File imageFile) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    if (token == null) {
      throw Exception("Authentication error. Please log in again.");
    }

    try {
      final formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          imageFile.path,
          filename: imageFile.path.split('/').last,
        ),
      });

      final response = await dio.post(
        "/Update/ProfilePicture",
        data: formData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to update profile picture.");
      }
    } on DioException catch (e) {
      throw Exception(e.response?.data ?? "Profile picture upload failed.");
    }
  }

  // ---------------- UPDATE USERNAME ----------------
  Future<void> updateUsername(String username) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    if (token == null) {
      throw Exception("Authentication error. Please log in again.");
    }

    try {
      final response = await dio.put(
        "/Update/Username",
        data: {"username": username},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200 ||
          response.data["status"]?.toString().toLowerCase() != "success") {
        throw Exception("Username already exists or is invalid.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Failed to update username.",
      );
    }
  }

  // ---------------- UPDATE EMAIL ----------------
  Future<void> updateEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    if (token == null) {
      throw Exception("Authentication error. Please log in again.");
    }

    try {
      final response = await dio.put(
        "/Update/Email",
        data: {"email": email},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200 ||
          response.data["status"]?.toString().toLowerCase() != "success") {
        throw Exception("Email is already in use.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Failed to update email.",
      );
    }
  }

  // ---------------- UPDATE PASSWORD ----------------
  Future<void> updatePassword(String oldPass, String newPass) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");

    if (token == null) {
      throw Exception("Authentication error. Please log in again.");
    }

    try {
      final response = await dio.put(
        "/Update/Password",
        data: {"old": oldPass, "newPassword": newPass},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200 ||
          response.data["status"]?.toString().toLowerCase() != "success") {
        throw Exception("Old password is incorrect.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Failed to update password.",
      );
    }
  }
}
