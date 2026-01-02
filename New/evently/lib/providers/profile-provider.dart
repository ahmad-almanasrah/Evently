import 'dart:io';
import 'package:evently/data/services/profile_service.dart';
import 'package:flutter/material.dart';

class ProfileProvider extends ChangeNotifier {
  final ProfileService profileService;

  // Profile state
  String username = '';
  String email = '';
  String name = '';
  String pictureURL = '';
  int friendsCount = 0;
  int galleriesCount = 0;
  int pictureCount = 0;
  File? profileImage; // local selected file

  ProfileProvider({required this.profileService});

  // --- Email validation ---
  bool _isValidEmail(String email) {
    final regex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return regex.hasMatch(email);
  }

  // --- Fetch profile from backend ---
  Future<void> fetchProfile() async {
    try {
      final data = await profileService.fetchProfile();

      pictureURL = data['pictureURL'] ?? '';
      name = data['name'] ?? '';
      username = data['userName'] ?? '';
      friendsCount = int.tryParse(data['friendsCount']?.toString() ?? '0') ?? 0;
      galleriesCount =
          int.tryParse(data['galleriesCount']?.toString() ?? '0') ?? 0;
      pictureCount = int.tryParse(data['pictureCount']?.toString() ?? '0') ?? 0;

      notifyListeners();
    } catch (e) {
      // Handle fetch error if needed
      throw Exception("Failed to load profile: ${e.toString()}");
    }
  }

  // --- Update profile picture ---
  Future<void> updateProfilePicture(File image) async {
    try {
      await profileService.updatePicture(image);
      profileImage = image;
      notifyListeners();
    } catch (e) {
      throw Exception("Failed to update profile picture: ${e.toString()}");
    }
  }

  // --- Update username ---
  Future<void> updateUsername(String newUsername) async {
    if (newUsername.trim().isEmpty) {
      throw Exception("Username cannot be empty");
    }

    try {
      await profileService.updateUsername(newUsername);
      username = newUsername;
      notifyListeners();
    } catch (e) {
      throw Exception(
        "Failed to update username. It may already exist or be invalid",
      );
    }
  }

  // --- Update email ---
  Future<void> updateEmail(String newEmail) async {
    if (!_isValidEmail(newEmail)) {
      throw Exception("Invalid email address");
    }

    try {
      await profileService.updateEmail(newEmail);
      email = newEmail;
      notifyListeners();
    } catch (e) {
      throw Exception(
        "Failed to update email. It may already exist or be invalid",
      );
    }
  }

  // --- Update password ---
  Future<void> updatePassword(String oldPass, String newPass) async {
    if (oldPass.isEmpty || newPass.isEmpty) {
      throw Exception("Password fields cannot be empty");
    }

    try {
      await profileService.updatePassword(oldPass, newPass);
    } catch (e) {
      throw Exception("Failed to update password. ${e.toString()}");
    }
  }
}
