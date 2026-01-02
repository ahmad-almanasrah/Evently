import 'package:evently/data/model/event_model.dart';
import 'package:evently/data/services/home-service.dart';
import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  final HomeService homeService;

  HomeProvider(this.homeService);

  // -------- STATE --------
  bool _isLoading = false;
  String? _errorMessage;
  List<EventModel> _events = [];

  // -------- GETTERS --------
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<EventModel> get events => _events;

  // -------- CREATE EVENT --------
  Future<bool> createEvent({
    required String title,
    String? description,
    required DateTime eventDate,
    required bool isPublic,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await homeService.createEvent({
        "title": title,
        "description": description,
        "eventDate": eventDate.toIso8601String(),
        "isPublic": isPublic,
      });

      return true;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------- FETCH EVENTS --------
  Future<void> fetchEvents() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _events = await homeService.getMyEvents();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // -------- OPTIONAL: CLEAR ERROR --------
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
