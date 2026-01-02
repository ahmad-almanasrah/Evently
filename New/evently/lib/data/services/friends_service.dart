import 'package:dio/dio.dart';
import 'package:evently/data/model/friend_model.dart';
import 'package:evently/data/model/friend_request_model.dart';
import 'package:evently/data/model/event_model.dart'; // Make sure this path is correct
import 'package:shared_preferences/shared_preferences.dart';

class FriendService {
  final Dio dio;

  FriendService({Dio? dioInstance}) : dio = dioInstance ?? Dio() {
    dio.options.baseUrl = "http://192.168.1.14:8080/home";
    dio.options.headers["Content-Type"] = "application/json";
  }

  // Helper to get the token for every request
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("jwt_token");
    if (token == null) throw Exception("Session expired. Please log in.");
    return token;
  }

  // ... inside FriendService class ...

  // 7. INVITE FRIENDS (Bulk)
  Future<void> inviteFriends(int eventId, List<int> userIds) async {
    final token = await _getToken();
    try {
      await dio.post(
        "/Event/$eventId/invite",
        data: {"userIds": userIds}, // Backend expects: {"userIds": [1, 2]}
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception("Failed to invite friends: ${e.response?.statusMessage}");
    }
  }

  // 8. JOIN EVENT (QR Code)
  Future<void> joinEvent(int eventId) async {
    final token = await _getToken();
    try {
      await dio.post(
        "/JoinEvent/$eventId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception(e.response?.data['message'] ?? "Failed to join event.");
    }
  }

  // 1. SEARCH FOR USERS
  Future<List<FriendModel>> searchUsers(String query) async {
    final token = await _getToken();
    try {
      final response = await dio.get(
        "/users/search",
        queryParameters: {"query": query},
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return (response.data as List)
          .map((json) => FriendModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception(e.response?.data?['message'] ?? "Error searching users.");
    }
  }

  // 2. SEND FRIEND REQUEST
  Future<void> sendFriendRequest(int receiverId) async {
    final token = await _getToken();
    try {
      await dio.post(
        "/friends/request/$receiverId",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception(
        e.response?.data?['message'] ?? "Failed to send request.",
      );
    }
  }

  // 3. GET PENDING REQUESTS
  Future<List<FriendRequestModel>> getPendingRequests() async {
    final token = await _getToken();
    try {
      final response = await dio.get(
        "/friends/pending",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return (response.data as List)
          .map((json) => FriendRequestModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception("Could not fetch friend requests.");
    }
  }

  // 4. RESPOND TO REQUEST (Accept/Reject)
  Future<void> respondToRequest(int requestId, String action) async {
    final token = await _getToken();
    try {
      await dio.put(
        "/friends/respond/$requestId",
        queryParameters: {"action": action}, // 'accept' or 'reject'
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
    } on DioException catch (e) {
      throw Exception("Action failed.");
    }
  }

  // 5. GET ACCEPTED FRIENDS LIST
  Future<List<FriendModel>> getFriendsList() async {
    final token = await _getToken();
    try {
      final response = await dio.get(
        "/friends/list",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return (response.data as List)
          .map((json) => FriendModel.fromJson(json))
          .toList();
    } on DioException catch (e) {
      throw Exception("Could not load friends list.");
    }
  }

  // --- NEW FUNCTION ADDED HERE ---

  // 6. GET JOINED EVENTS
  Future<List<EventModel>> getJoinedEvents() async {
    final token = await _getToken();
    try {
      // Endpoint matches backend: /home/GetJoinedEvents
      final response = await dio.get(
        "/GetJoinedEvents",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );

      return (response.data as List).map((json) {
        // --- DATA MAPPING FIX ---
        // The backend sends 'visible' & 'coverImage', but Flutter model expects 'isPublic' & 'coverImageUrl'.
        // We map them manually here so we don't have to touch the Model class.

        if (json['isPublic'] == null && json['visible'] != null) {
          json['isPublic'] = json['visible'];
        }
        if (json['coverImageUrl'] == null && json['coverImage'] != null) {
          json['coverImageUrl'] = json['coverImage'];
        }

        return EventModel.fromJson(json);
      }).toList();
    } on DioException catch (e) {
      throw Exception(
        "Failed to load joined events: ${e.response?.statusCode}",
      );
    }
  }
}
