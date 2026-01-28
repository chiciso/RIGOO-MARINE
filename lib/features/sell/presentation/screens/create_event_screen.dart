import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/dropdown_field.dart';
import '../widgets/image_picker_grid.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedEventType;
  final String _selectedCategory = 'Yacht Tour, Boat Cruise';
  String? _selectedDepartureLocation;
  bool _includesFoodAndDrinks = false;
  String _accessType = 'Public';
  final List<String> _selectedImages = [];

  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submitEvent() async {
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
      const SnackBar(content: Text(AppConstants.eventCreated)),
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
              // Category (read-only in this case)
              Text(
                'Category',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 16,),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F3F5),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _selectedCategory ,
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
                  return null;
                },
              ),
              const SizedBox(height: 24),
              // Includes Food & Drinks
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 12,
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
              // Access Type (Public/Private)
              Text(
                'Access Type',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              RadioGroup(
                groupValue: _accessType,
                onChanged: (value){
                  setState(() => _accessType = value! as String);
                },
                child: const Row(children: [
                  Expanded(child: RadioListTile<String>(
                    title:Text('Public'),
                    value:'Public',
                    activeColor: AppTheme.primaryColor,
                    contentPadding: EdgeInsets.zero,
                    ),
                    ),
                    Expanded(child: RadioListTile(
                      title: Text('Private'),
                      value:'Private',
                      activeColor: AppTheme.primaryColor,
                      contentPadding: EdgeInsets.zero, ),),
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