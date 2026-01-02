import 'package:dio/dio.dart';
import 'package:evently/data/model/event_model.dart';
import 'package:evently/data/model/event_details_model.dart'; // ✅ Make sure to import this!
import 'package:shared_preferences/shared_preferences.dart';

class HomeService {
  final Dio dio;

  HomeService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    // Base URL includes '/home'
    dio.options.baseUrl = "http://192.168.1.14:8080/home";
    dio.options.headers["Content-Type"] = "application/json";
  }

  // --- Create Event ---
  Future<void> createEvent(Map<String, dynamic> eventData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      final response = await dio.post(
        "/CreateEvent",
        data: eventData,
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      if (response.statusCode != 200) {
        throw Exception("Failed to create event.");
      }
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ??
            e.response?.data?.toString() ??
            "Unable to create event.",
      );
    }
  }

  // --- Get My Events ---
  Future<List<EventModel>> getMyEvents() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      final response = await dio.get(
        '/GetEvents',
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
            'Failed to load events',
      );
    }
  }

  // --- ✅ NEW: Get Event Details ---
  Future<EventDetailsModel> getEventDetails(int eventId) async {
    try {
      // 1. Get Token (Required for isOwner check)
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');

      if (token == null || token.isEmpty) {
        throw Exception("User is not authenticated.");
      }

      // 2. Make Request
      // Path becomes: http://192.168.1.14:8080/home/Event/1/details
      final response = await dio.get(
        "/Event/$eventId/details",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      // 3. Parse Response
      if (response.statusCode == 200) {
        return EventDetailsModel.fromJson(response.data);
      } else {
        throw Exception("Failed to load event details");
      }
    } on DioException catch (e) {
      // Standard error handling
      throw Exception(
        e.response?.data?['message'] ??
            e.response?.data?.toString() ??
            "Error fetching details",
      );
    }
  }
}
