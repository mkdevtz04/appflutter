import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ImageUploadService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final ImagePicker _imagePicker = ImagePicker();

  // Pick image from gallery
  Future<XFile?> pickImageFromGallery() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }

  // Pick image from camera
  Future<XFile?> pickImageFromCamera() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
      );
      return image;
    } catch (e) {
      throw Exception('Error taking photo: $e');
    }
  }

  // Upload image to Supabase Storage
  Future<String> uploadImage({
    required File imageFile,
    required String bucket,
    required String folderPath,
  }) async {
    try {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
      final filePath = '$folderPath/$fileName';

      await _supabase.storage.from(bucket).upload(
            filePath,
            imageFile,
          );

      // Get public URL
      final publicUrl = _supabase.storage.from(bucket).getPublicUrl(filePath);
      return publicUrl;
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  // Delete image from Supabase Storage
  Future<void> deleteImage({
    required String bucket,
    required String imagePath,
  }) async {
    try {
      await _supabase.storage.from(bucket).remove([imagePath]);
    } catch (e) {
      throw Exception('Error deleting image: $e');
    }
  }

  // Get image URL from path
  String getImageUrl({
    required String bucket,
    required String imagePath,
  }) {
    return _supabase.storage.from(bucket).getPublicUrl(imagePath);
  }
}
