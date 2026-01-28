import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

// Storage Service Provider
final firebaseStorageServiceProvider = Provider<FirebaseStorageService>((ref) =>
 FirebaseStorageService());

class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ImagePicker _picker = ImagePicker();

  // Pick single image from gallery
  Future<XFile?> pickImage() async =>  _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1200,
      maxHeight: 900,
      imageQuality: 85,
    );

  // Pick multiple images from gallery
  Future<List<XFile>> pickMultipleImages() async =>  _picker.pickMultiImage(
      maxWidth: 1200,
      maxHeight: 900,
      imageQuality: 85,
    );

  // Upload single image for listing
  Future<String> uploadListingImage(String listingId, XFile image) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final file = File(image.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('listings/$listingId/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  // Upload multiple images for listing
  Future<List<dynamic>> uploadListingImages(
    String listingId, List<XFile> images) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final  urls = [];

    for (final image in images) {
      final url = await uploadListingImage(listingId, image);
      urls.add(url);
    }

    return urls;
  }

  // Upload profile image
  Future<String> uploadProfileImage(XFile image) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final file = File(image.path);
    const fileName = 'profile.jpg';
    final ref = _storage.ref('users/$userId/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  // Upload event image
  Future<String> uploadEventImage(String eventId, XFile image) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final file = File(image.path);
    final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
    final ref = _storage.ref('events/$eventId/$fileName');

    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return snapshot.ref.getDownloadURL();
  }

  // Upload multiple event images
  Future<List<String>> uploadEventImages(
    String eventId, List<XFile> images) async {
    final urls = <String>[];

    for (final image in images) {
      final url = await uploadEventImage(eventId, image);
      urls.add(url);
    }

    return urls;
  }

  // Delete image
  Future<bool> deleteImage(String url) async {
  if (url.isEmpty) {
    return false;
  }

  try {
    final ref = FirebaseStorage.instance.refFromURL(url);
    await ref.delete();
    return true;
  } on FirebaseException catch (e) {
    if (e.code == 'object-not-found') {
      if (kDebugMode) {
        print('Image already deleted or does not exist.');
      }
      return true; // Often treated as success in cleanup logic
    }
    if (kDebugMode) {
      if (kDebugMode) {
        print('Firebase Storage Error: ${e.code} - ${e.message}');
      }
    }
    return false;
  } on Exception catch (e) {
    if (kDebugMode) {
      print('Unexpected error: $e');
    }
    return false;
  }
}


  // Delete multiple images
  Future<void> deleteImages(List<String> urls) async {
    for (final url in urls) {
      await deleteImage(url);
    }
  }

  // Pick and upload profile image (convenience method)
  Future<String?> pickAndUploadProfileImage() async {
    final image = await pickImage();
    if (image == null) {
      return null;
    }

    return uploadProfileImage(image);
  }

  // Pick and upload listing images (convenience method)
  Future<List<dynamic>> pickAndUploadListingImages(String listingId) async {
    final images = await pickMultipleImages();
    if (images.isEmpty) {
      return [];
    }

    return uploadListingImages(listingId, images);
  }
}