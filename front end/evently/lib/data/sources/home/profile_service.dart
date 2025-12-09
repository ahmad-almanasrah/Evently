import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileService {
  final Dio dio;

  // Constructor
  ProfileService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/home";
    dio.options.headers["Content-Type"] = "application/json";
  }

  // MOVE THIS INSIDE THE CLASS
  Future<Response> getUserProfile() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // FIX 1: Use the same key you used in LoginCubit ('token')
    final String? token = prefs.getString('token');

    try {
      final response = await dio.get(
        '/profile',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );
      return response;
    } catch (e) {
      rethrow;
    }
  }
}
