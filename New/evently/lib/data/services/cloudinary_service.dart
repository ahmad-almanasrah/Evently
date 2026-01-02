import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

class CloudinaryService {
  final Dio dio = Dio();

  // ✅ Your computer's IP
  final String backendBaseUrl = "http://192.168.1.14:8080";

  // --- 1. Upload to Cloudinary ---
  Future<String?> uploadImage(XFile file) async {
    try {
      String cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
      String uploadPreset = dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

      if (cloudName.isEmpty || uploadPreset.isEmpty) {
        print("❌ Cloudinary keys are missing! Check your .env file.");
        return null;
      }

      String url = "https://api.cloudinary.com/v1_1/$cloudName/image/upload";
      final bytes = await file.readAsBytes();

      FormData formData = FormData.fromMap({
        "file": MultipartFile.fromBytes(bytes, filename: file.name),
        "upload_preset": uploadPreset,
      });

      Response response = await dio.post(url, data: formData);

      if (response.statusCode == 200) {
        final url = response.data['secure_url'];
        print("✅ Upload Success: $url");
        return url;
      }
      return null;
    } catch (e) {
      print("❌ Upload Error: $e");
      return null;
    }
  }

  // --- 2. Save to Backend (THIS WAS MISSING) ---
  Future<void> saveImageUrlsToBackend(
    int eventId,
    List<String> imageUrls,
    String token,
  ) async {
    try {
      String url = "$backendBaseUrl/home/UploadImages/$eventId";

      // Matches your Java List<UploadImageDTO> structure
      List<Map<String, String>> bodyData = imageUrls
          .map((url) => {"imageUrl": url})
          .toList();

      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
        data: bodyData,
      );

      if (response.statusCode != 200) {
        throw Exception("Backend error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Backend Save Error: $e");
      throw Exception("Failed to save to backend: $e");
    }
  }
}
