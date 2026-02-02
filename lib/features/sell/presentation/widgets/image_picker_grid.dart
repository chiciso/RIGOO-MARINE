import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_storage_service.dart';
import '../../../../core/theme/app_theme.dart';

class ImagePickerGrid extends ConsumerWidget {
  const ImagePickerGrid({
    required this.images,
    required this.onImagesChanged,
    super.key,
  });

  final List<XFile> images;
  final ValueChanged<List<XFile>> onImagesChanged;

  Future<void> _addImage(BuildContext context, WidgetRef ref) async {
    if (images.length >= AppConstants.maxImagesPerListing) {
      return;
    }

    final storageService = ref.read(firebaseStorageServiceProvider);
    final image = await storageService.pickImage();

    if (image != null) {
      final newImages = List<XFile>.from(images)..add(image);
      onImagesChanged(newImages);
    }
  }

  void _removeImage(int index) {
    final newImages = List<XFile>.from(images)..removeAt(index);
    onImagesChanged(newImages);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pictures',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          
          // Wrap in SizedBox with constrained height to prevent overflow
          SizedBox(
            height: 240, // Fixed height to prevent overflow
            child: Row(
              children: [
                // First large image
                Expanded(
                  child: GestureDetector(
                    onTap: () => _addImage(context, ref),
                    child: AspectRatio(
                      aspectRatio: 0.8,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8F9FA),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: const Color(0xFFE0E0E0),
                          ),
                        ),
                        child: images.isEmpty
                            ? const Center(
                                child: Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 48,
                                  color: AppTheme.textSecondary,
                                ),
                              )
                            : Stack(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.file(
                                      File(images[0].path),
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context, error, stackTrace) =>
                                          Container(
                                        color: AppTheme.primaryColor
                                            .withValues(alpha: 0.1),
                                        child: const Center(
                                          child: Icon(
                                            Icons.broken_image,
                                            size: 48,
                                            color: AppTheme.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 8,
                                    right: 8,
                                    child: GestureDetector(
                                      onTap: () => _removeImage(0),
                                      child: Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.black54,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(
                                          Icons.close,
                                          size: 16,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                
                // Two smaller images
                Expanded(
                  child: Column(
                    children: [
                      // Second image slot
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _addImage(context, ref),
                          child: AspectRatio(
                            aspectRatio: 1.6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: images.length < 2 
                                  ? const Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 32,
                                        color: AppTheme.textSecondary,
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: 
                                          BorderRadius.circular(12),
                                          child: Image.file(
                                            File(images[1].path),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: AppTheme.primaryColor
                                                  .withValues(alpha: 0.1),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 32,
                                                  color: AppTheme.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(1),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      
                      // Third image slot
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _addImage(context, ref),
                          child: AspectRatio(
                            aspectRatio: 1.6,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE0E0E0),
                                ),
                              ),
                              child: images.length < 3
                                  ? const Center(
                                      child: Icon(
                                        Icons.add_photo_alternate_outlined,
                                        size: 32,
                                        color: AppTheme.textSecondary,
                                      ),
                                    )
                                  : Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            12),
                                          child: Image.file(
                                            File(images[2].path),
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: AppTheme.primaryColor
                                                  .withValues(alpha: 0.1),
                                              child: const Center(
                                                child: Icon(
                                                  Icons.broken_image,
                                                  size: 32,
                                                  color: AppTheme.textSecondary,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 4,
                                          right: 4,
                                          child: GestureDetector(
                                            onTap: () => _removeImage(2),
                                            child: Container(
                                              padding: const EdgeInsets.all(2),
                                              decoration: const BoxDecoration(
                                                color: Colors.black54,
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Icon(
                                                Icons.close,
                                                size: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}