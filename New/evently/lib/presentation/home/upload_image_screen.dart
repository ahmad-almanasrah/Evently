import 'dart:io';

import 'package:evently/data/services/cloudinary_service.dart';
// REMOVED: import 'package:evently/data/services/home-service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UploadImageScreen extends StatefulWidget {
  final int eventId;

  const UploadImageScreen({super.key, required this.eventId});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final ImagePicker _picker = ImagePicker();
  final CloudinaryService _cloudinaryService = CloudinaryService();
  // REMOVED: final HomeService _homeService = HomeService();

  List<XFile> _selectedImages = [];
  bool _isUploading = false;

  // --- 1. PICK IMAGES ---
  Future<void> _pickImages() async {
    try {
      final List<XFile> images = await _picker.pickMultiImage();
      if (images.isNotEmpty) {
        setState(() {
          _selectedImages.addAll(images);
        });
      }
    } catch (e) {
      debugPrint("Error picking images: $e");
    }
  }

  // --- 2. REMOVE IMAGE ---
  void _removeImage(int index) {
    setState(() {
      _selectedImages.removeAt(index);
    });
  }

  // --- 3. UPLOAD LOGIC ---
  Future<void> _uploadImages() async {
    if (_selectedImages.isEmpty) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // A. Upload files to Cloudinary (One by one)
      List<String> successUrls = [];

      for (var imageFile in _selectedImages) {
        String? secureUrl = await _cloudinaryService.uploadImage(imageFile);
        if (secureUrl != null) {
          successUrls.add(secureUrl);
        }
      }

      if (successUrls.isEmpty) {
        throw Exception("No images were successfully uploaded to Cloudinary.");
      }

      // B. Get Token
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('jwt_token');
      if (token == null) throw Exception("Please log in again.");

      // C. Call the Service to save to Backend (UPDATED to use CloudinaryService)
      await _cloudinaryService.saveImageUrlsToBackend(
        widget.eventId,
        successUrls,
        token,
      );

      // D. Success
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Upload Successful!")));
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Upload Failed: $e")));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Paste your existing UI build code here
    return Scaffold(
      appBar: AppBar(title: const Text("Upload Images")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _selectedImages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Image.file(File(_selectedImages[index].path)),
                  title: Text(_selectedImages[index].name),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeImage(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickImages,
                    child: const Text("Pick Images"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isUploading ? null : _uploadImages,
                    child: _isUploading
                        ? const CircularProgressIndicator()
                        : const Text("Upload"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
