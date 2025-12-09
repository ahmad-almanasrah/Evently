import 'package:dio/dio.dart';
import 'package:evently/data/model/profile_model.dart';
import 'package:evently/data/sources/home/profile_service.dart';

class ProfileRepo {
  final ProfileService profileService;
  ProfileRepo(this.profileService);

  Future<ProfileModel> getUserProfile() async {
    try {
      final Response response = await profileService.getUserProfile();

      if (response.statusCode == 200 && response.data != null) {
        return ProfileModel.fromJson(response.data);
      } else {
        throw Exception(
            "Failed to load profile. Status: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Repo Error: $e");
    }
  }
}
