import 'package:evently/data/model/friend_model.dart';
import 'package:evently/data/model/friend_request_model.dart';
import 'package:evently/data/model/event_model.dart';
import 'package:evently/data/services/friends_service.dart';
import 'package:flutter/material.dart';

class FriendProvider extends ChangeNotifier {
  final FriendService friendService;

  // --- State Variables ---
  List<FriendModel> searchResults = [];
  List<FriendModel> friendsList = [];
  List<FriendRequestModel> pendingRequests = [];
  List<EventModel> joinedEvents = [];

  bool isLoading = false;
  String? errorMessage;

  FriendProvider({required this.friendService});

  int get totalNotifications => pendingRequests.length;

  Future<void> refreshNotifications() async {
    await fetchPendingRequests();
    notifyListeners();
  }

  // --- 1. Search Users ---
  Future<void> searchUsers(String query) async {
    if (query.trim().isEmpty) {
      searchResults = [];
      notifyListeners();
      return;
    }

    _setLoading(true);
    try {
      searchResults = await friendService.searchUsers(query);
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // --- 2. Fetch Pending Requests ---
  Future<void> fetchPendingRequests() async {
    try {
      pendingRequests = await friendService.getPendingRequests();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching requests: $e");
    }
  }

  // --- 3. Fetch Friends List ---
  Future<void> fetchFriendsList() async {
    try {
      friendsList = await friendService.getFriendsList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching friends: $e");
    }
  }

  // --- 4. Send Friend Request ---
  Future<void> sendRequest(int userId) async {
    try {
      await friendService.sendFriendRequest(userId);
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      errorMessage = e.toString().replaceAll("Exception:", "");
      notifyListeners();
      rethrow;
    }
  }

  // --- 5. Respond to Request (Accept/Reject) ---
  Future<void> respondToRequest(int requestId, String action) async {
    try {
      await friendService.respondToRequest(requestId, action);
      await fetchPendingRequests();
      await fetchFriendsList();
    } catch (e) {
      throw Exception("Failed to $action request: ${e.toString()}");
    }
  }

  // --- 6. Fetch Joined Events (The Feed) ---
  Future<void> fetchJoinedEvents() async {
    try {
      joinedEvents = await friendService.getJoinedEvents();
      errorMessage = null;
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching joined events: $e");
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ==========================================================
  //  NEW METHODS ADDED BELOW
  // ==========================================================

  // --- 7. INVITE FRIENDS TO EVENT ---
  Future<void> inviteFriendsToEvent(int eventId, List<int> userIds) async {
    try {
      await friendService.inviteFriends(eventId, userIds);
      // Optional: Refresh feed to show changes immediately if needed
    } catch (e) {
      // Allow UI to handle the error (e.g. SnackBar)
      rethrow;
    }
  }

  // --- 8. JOIN EVENT (QR Code) ---
  Future<void> joinEventViaQr(int eventId) async {
    try {
      await friendService.joinEvent(eventId);

      // Refresh the "My Events" feed so the new event appears immediately
      await fetchJoinedEvents();
    } catch (e) {
      rethrow;
    }
  }

  // --- Helper: Loading State ---
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }

  void clearSearch() {
    searchResults = [];
    notifyListeners();
  }
}
