import 'package:dio/dio.dart';
import 'package:evently/data/model/event_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExploreService {
  final Dio dio;

  ExploreService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/home";
    dio.options.headers["Content-Type"] = "application/json";
  }

  // --- Get Public Feed (Paginated) ---
  Future<List<EventModel>> getPublicFeed({
    required int page,
    int size = 10,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      // ✅ Use queryParameters for ?page=X&size=Y
      final response = await dio.get(
        "/feed",
        queryParameters: {"page": page, "size": size},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.data is! List) {
        throw Exception("Invalid response format");
      }

      return (response.data as List)
          .map((e) => EventModel.fromJson(e))
          .toList();
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.response?.data?.toString() ??
            'Failed to load explore feed',
      );
    }
  }
}
