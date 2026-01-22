import 'package:flutter/material.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

class ImagePickerGrid extends StatelessWidget {

  const ImagePickerGrid({
    required this.images,
    required this.onImagesChanged,
    super.key,
  });
  final List<String> images;
  final ValueChanged<List<String>> onImagesChanged;

  void _addImage() {
    if (images.length >= AppConstants.maxImagesPerListing) {
      return;
    }
    
    // In a real app, this would open image picker
    // For now, just add a placeholder
    final newImages = List<String>.from(images)
    ..add('placeholder_${images.length}');
    onImagesChanged(newImages);
  }

  void _removeImage(int index) {
    final newImages = List<String>.from(images)
    ..removeAt(index);
    onImagesChanged(newImages);
  }

  @override
  Widget build(BuildContext context) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pictures',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) => Row(
              children: [
                // First large image
                Expanded(
                  child: GestureDetector(
                    onTap: _addImage,
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
                                    child: Container(
                                      color: AppTheme.primaryColor.withValues(
                                        alpha: 0.1),
                                      child: const Center(
                                        child: Icon(
                                          Icons.image,
                                          size: 48,
                                          color: AppTheme.primaryColor,
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
                      GestureDetector(
                        onTap: images.length < 2 ? _addImage : null,
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          color:
                                           AppTheme.primaryColor.withValues(
                                            alpha: 0.1),
                                          child: const Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 32,
                                              color: AppTheme.primaryColor,
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
                      const SizedBox(height: 8),
                      GestureDetector(
                        onTap: images.length < 3 ? _addImage : null,
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
                                        borderRadius: BorderRadius.circular(12),
                                        child: Container(
                                          color:
                                           AppTheme.primaryColor.withValues(
                                            alpha: 0.1),
                                          child: const Center(
                                            child: Icon(
                                              Icons.image,
                                              size: 32,
                                              color: AppTheme.primaryColor,
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
                    ],
                  ),
                ),
              ],
            ),
        ),
      ],
    );
}