import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/firebase_storage_service.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/image_picker_grid.dart';

/// Create listing screen with Firebase integration
class CreateListingScreen extends ConsumerStatefulWidget {
  const CreateListingScreen({super.key});

  @override
  ConsumerState<CreateListingScreen> createState() =>
      _CreateListingScreenState();
}

class _CreateListingScreenState extends ConsumerState<CreateListingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _engineModelController = TextEditingController();
  final _bodyModelController = TextEditingController();
  final _enginePowerController = TextEditingController();
  final _engineHoursController = TextEditingController();
  final _bodyLengthController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();

  String? _selectedItemType;
  String? _selectedCondition;
  String? _selectedEngineType;
  List<XFile> _selectedImages = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _engineModelController.dispose();
    _bodyModelController.dispose();
    _enginePowerController.dispose();
    _engineHoursController.dispose();
    _bodyLengthController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _submitListing() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_selectedItemType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an item type'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    if (_selectedCondition == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a condition'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('User not logged in');
      }

      // Get user data
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final userData = userDoc.data();
      final sellerName = userData?['fullName'] as String? ?? 'Unknown';

      // Create listing document to get ID
      final listingRef =
          FirebaseFirestore.instance.collection('listings').doc();

      // Upload images if any
      final  imageUrls = <String>[];
      if (_selectedImages.isNotEmpty) {
        final storageService = ref.read(firebaseStorageServiceProvider);
        
        for (final image in _selectedImages) {
          final url = await storageService.uploadListingImage(
            listingRef.id,
            image,
          );
          imageUrls.add(url);
        }
      }

      // Create listing data
      final listingData = <String, dynamic>{
        'name': _nameController.text.trim(),
        'itemType': _selectedItemType,
        'price': double.parse(_priceController.text.trim()),
        'condition': _selectedCondition,
        'category': _selectedItemType, // Using itemType as category
        'sellerId': user.uid,
        'sellerName': sellerName,
        'imageUrls': imageUrls,
        'listingType': 'For Sale',
        'isFeatured': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // Add optional fields
      if (_engineModelController.text.trim().isNotEmpty) {
        listingData['engineModel'] = _engineModelController.text.trim();
      }
      if (_bodyModelController.text.trim().isNotEmpty) {
        listingData['bodyModel'] = _bodyModelController.text.trim();
      }
      if (_selectedEngineType != null) {
        listingData['engineType'] = _selectedEngineType;
      }
      if (_enginePowerController.text.trim().isNotEmpty) {
        listingData['enginePower'] = _enginePowerController.text.trim();
      }
      if (_engineHoursController.text.trim().isNotEmpty) {
        listingData['engineHours'] = _engineHoursController.text.trim();
      }
      if (_bodyLengthController.text.trim().isNotEmpty) {
        listingData['bodyLength'] = _bodyLengthController.text.trim();
      }
      if (_descriptionController.text.trim().isNotEmpty) {
        listingData['description'] = _descriptionController.text.trim();
      }
      if (_addressController.text.trim().isNotEmpty) {
        listingData['address'] = _addressController.text.trim();
      }

      // Save to Firestore
      await listingRef.set(listingData);

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(AppConstants.listingCreated),
          backgroundColor: AppTheme.successColor,
        ),
      );

      context.pop();
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.message ?? 'Failed to create listing'}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }

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
          title: const Text('Create Listing'),
          actions: [
            TextButton(
              onPressed: _isLoading ? null : _submitListing,
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
                // Item type
                Text(
                  'Item type',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DropdownField(
                  hintText: 'Boat, Yacht, Jet Ski',
                  value: _selectedItemType,
                  items: AppConstants.itemTypes,
                  onChanged: (value) {
                    setState(() => _selectedItemType = value);
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
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter item name',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.requiredField;
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Images
                ImagePickerGrid(
                  images: _selectedImages,
                  onImagesChanged: (images) {
                    setState(() {
                      _selectedImages = images;
                    });
                  },
                ),
                const SizedBox(height: 24),

                // Price
                Text(
                  'Price',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: r'$ USD',
                    prefixText: r'$ ',
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return AppConstants.requiredField;
                    }
                    if (double.tryParse(value.trim()) == null) {
                      return 'Please enter a valid price';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // Condition
                Text(
                  'Condition',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DropdownField(
                  hintText: 'Choose condition',
                  value: _selectedCondition,
                  items: AppConstants.conditionOptions,
                  onChanged: (value) {
                    setState(() => _selectedCondition = value);
                  },
                ),
                const SizedBox(height: 24),

                // Engine model
                Text(
                  'Engine model',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _engineModelController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter engine model',
                  ),
                ),
                const SizedBox(height: 24),

                // Body model
                Text(
                  'Body model',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyModelController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter body model',
                  ),
                ),
                const SizedBox(height: 24),

                // Engine type
                Text(
                  'Engine type',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                DropdownField(
                  hintText: 'Choose engine type',
                  value: _selectedEngineType,
                  items: AppConstants.engineTypes,
                  onChanged: (value) {
                    setState(() => _selectedEngineType = value);
                  },
                ),
                const SizedBox(height: 24),

                // Engine power
                Text(
                  'Engine power',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _enginePowerController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter engine power',
                  ),
                ),
                const SizedBox(height: 24),

                // Engine hours
                Text(
                  'Engine hours',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _engineHoursController,
                  keyboardType: TextInputType.number,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter engine hours',
                  ),
                ),
                const SizedBox(height: 24),

                // Body length
                Text(
                  'Body length',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _bodyLengthController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter body length',
                  ),
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
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Write a description',
                    alignLabelWithHint: true,
                  ),
                ),
                const SizedBox(height: 24),

                // Address
                Text(
                  'Address',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  enabled: !_isLoading,
                  decoration: const InputDecoration(
                    hintText: 'Enter address',
                  ),
                ),
                const SizedBox(height: 32),

                // Submit button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitListing,
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
                        : const Text('Post Listing'),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
}