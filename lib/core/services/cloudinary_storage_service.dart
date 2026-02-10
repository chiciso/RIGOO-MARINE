import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Provider for Cloudinary storage service
final cloudinaryStorageServiceProvider = Provider<CloudinaryStorageService>(
  (ref) => CloudinaryStorageService(),
);

/// Cloudinary storage service - handles all image uploads
/// Uses Cloudinary instead of Firebase Storage (no credit card needed!)
class CloudinaryStorageService {
  // ✅ YOUR CLOUDINARY CONFIGURATION
  final cloudinary = CloudinaryPublic(
    'dxeoi3uk5',  // Your cloud name
    'ml_default', // Upload preset (must be created in Cloudinary dashboard)
  );

  final ImagePicker _picker = ImagePicker();

  /// Pick image from gallery
  Future<XFile?> pickImage() async {
    try {
      final image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return image;
    } catch (e) {
      throw Exception('Failed to pick image: $e');
    }
  }

  /// Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImages() async {
    try {
      final images = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      return images;
    } catch (e) {
      throw Exception('Failed to pick images: $e');
    }
  }

  /// Upload single listing image to Cloudinary
  Future<String> uploadListingImage(XFile image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'rigoo_marine/listings',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload listing image: $e');
    }
  }

  /// Upload multiple listing images to Cloudinary
  Future<List<String>> uploadListingImages(List<XFile> images) async {
    final urls = <String>[];

    for (final image in images) {
      try {
        final url = await uploadListingImage(image);
        urls.add(url);
      } on Exception catch (e) {
        // Log error but continue uploading other images
        debugPrint('Error uploading image ${image.path}: $e');
      }
    }

    if (urls.isEmpty && images.isNotEmpty) {
      throw Exception('Failed to upload all images');
    }

    return urls;
  }

  /// Upload event image to Cloudinary
  Future<String> uploadEventImage(XFile image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'rigoo_marine/events',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload event image: $e');
    }
  }

  /// Upload profile image to Cloudinary
  Future<String> uploadProfileImage(XFile image) async {
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'rigoo_marine/profiles',
          resourceType: CloudinaryResourceType.Image,
        ),
      );
      return response.secureUrl;
    } catch (e) {
      throw Exception('Failed to upload profile image: $e');
    }
  }
  }
