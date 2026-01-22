import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/image_picker_grid.dart';

class CreateListingScreen extends StatefulWidget {
  const CreateListingScreen({super.key});

  @override
  State<CreateListingScreen> createState() => _CreateListingScreenState();
}

class _CreateListingScreenState extends State<CreateListingScreen> {
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
  final List<String> _selectedImages = [];

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
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) {
      return;
    }
    setState(() => _isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(AppConstants.listingCreated)),
    );

    context.pop();
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
                decoration: const InputDecoration(
                  hintText: 'Enter item name',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
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
                    _selectedImages..clear()
                    ..addAll(images);
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
                decoration: const InputDecoration(
                  hintText: r'$ USD',
                  prefixText: r'$ ',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppConstants.requiredField;
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