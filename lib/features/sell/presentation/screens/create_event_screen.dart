import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/cloudinary_storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../sell/presentation/widgets/dropdown_field.dart';
import '../../../sell/presentation/widgets/image_picker_grid.dart';


class CreateEventScreen extends ConsumerStatefulWidget {
  const CreateEventScreen({super.key});

  @override
  ConsumerState<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends ConsumerState<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _durationController = TextEditingController();
  final _guideController = TextEditingController();
  final _locationController = TextEditingController();

  String? _selectedEventType;
  final String _selectedCategory = 'Yacht Tour, Boat Cruise';
  String? _selectedDepartureLocation;
  bool _includesFoodAndDrinks = false;
  String _accessType = 'Public';
  DateTime? _selectedDate;
  final List<XFile> _selectedImages = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _durationController.dispose();
    _guideController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  Future<void> _submitEvent() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_selectedEventType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event type')),
      );
      return;
    }

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select event date')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Get current user
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get user data from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      final userData = userDoc.data();
      final organizerName = userData?['fullName'] ?? 'Unknown';

      // ✅ Upload image to CLOUDINARY if selected
      String? imageUrl;
      if (_selectedImages.isNotEmpty) {
        final storageService = ref.read(cloudinaryStorageServiceProvider);
        imageUrl = await storageService.uploadEventImage(_selectedImages[0]);
      }

      // ✅ Save to Firestore with Cloudinary image URL
      await FirebaseFirestore.instance.collection('events').add({
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'eventType': _selectedEventType,
        'bookingPrice': double.parse(_priceController.text.trim()),
        'eventDate': Timestamp.fromDate(_selectedDate!),
        'duration': _durationController.text.trim().isEmpty
            ? '3 hours'
            : _durationController.text.trim(),
        'guide': _guideController.text.trim().isEmpty
            ? 'Professional Guide'
            : _guideController.text.trim(),
        'location': _locationController.text.trim().isEmpty
            ? 'Marina'
            : _locationController.text.trim(),
        'departureLocation': _selectedDepartureLocation ?? '',
        'includesFoodAndDrinks': _includesFoodAndDrinks,
        'accessType': _accessType,
        'images': imageUrl != null ? [imageUrl] : [],
        'organizerId': user.uid,
        'organizerName': organizerName,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Event created successfully!'),
          backgroundColor: AppTheme.successColor,
        ),
      );

      context.pop();
    }on Exception catch (e) {
      if (!mounted) {
        return;
      }

      debugPrint('Error creating event: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: const Text('Create Event'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _submitEvent,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Post'),
            ),
          ],
        ),
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  'Category',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F3F5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _selectedCategory,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFFADB5BD),
                        ),
                  ),
                ),
                const SizedBox(height: 24),

                // Event Type
                Text(
                  'Event Type',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DropdownField(
                  hintText: 'Pick event type',
                  value: _selectedEventType,
                  items: AppConstants.eventTypes,
                  onChanged: (value) {
                    setState(() => _selectedEventType = value);
                  },
                ),
                const SizedBox(height: 24),

                // Name
                Text(
                  'Name',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    hintText: 'Enter event name',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Event Date
                Text(
                  'Event Date',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.calendar_today, size: 20),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? 'Select event date'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Duration
                Text(
                  'Duration (Optional)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _durationController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., 3 hours',
                  ),
                ),
                const SizedBox(height: 24),

                // Guide
                Text(
                  'Guide (Optional)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _guideController,
                  decoration: const InputDecoration(
                    hintText: 'Guide name',
                  ),
                ),
                const SizedBox(height: 24),

                // Location
                Text(
                  'Location (Optional)',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    hintText: 'Event location',
                  ),
                ),
                const SizedBox(height: 24),

                // Images
                ImagePickerGrid(
                  images: _selectedImages,
                  onImagesChanged: (images) {
                    setState(() {
                      _selectedImages
                        ..clear()
                        ..addAll(images);
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Booking Price
                Text(
                  'Booking Price',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    hintText: r'$ USD',
                    prefixText: r'$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppConstants.requiredField;
                    }
                    final price = double.tryParse(value);
                    if (price == null) {
                      return 'Enter valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Includes Food & Drinks
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F9FA),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Includes Food & Drinks',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Switch(
                        value: _includesFoodAndDrinks,
                        onChanged: (value) {
                          setState(() => _includesFoodAndDrinks = value);
                        },
                        activeThumbColor: AppTheme.primaryColor,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Departure Location
                Text(
                  'Departure Location',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DropdownField(
                  hintText: 'Pick departure location',
                  value: _selectedDepartureLocation,
                  items: AppConstants.departureLocations,
                  onChanged: (value) {
                    setState(() => _selectedDepartureLocation = value);
                  },
                ),
                const SizedBox(height: 24),

                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    hintText: 'Write a description',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                // Access Type
                Text(
                  'Access Type',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                RadioGroup<String>(
                  groupValue: _accessType,
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _accessType = value);
                    }
                  },
                  child: const Row(
                    children: [
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Public'),
                          value: 'Public',
                          activeColor: AppTheme.primaryColor,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<String>(
                          title: Text('Private'),
                          value: 'Private',
                          activeColor: AppTheme.primaryColor,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitEvent,
                    child: _isLoading
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Text('Post Event'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
}