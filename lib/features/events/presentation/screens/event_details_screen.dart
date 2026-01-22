import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../marketplace/presentation/widgets/info_chip.dart';

class EventDetailsScreen extends StatelessWidget {

  const EventDetailsScreen({
    required this.eventId, super.key,
  });
  final String eventId;

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    // Mock data
    final eventData = <String, dynamic>{
      'name': 'Superyacht Tour',
      'price': 4000.0,
      'type': 'Birthday',
      'category': 'Yacht cruise',
      'duration': '2 - 3 hours',
      'guide': 'Live tour guide',
      'location': 'Lousail',
      'foodAndDrinks': 'Yes',
      'access': 'Public',
      'description':
          '''
Explore all the top landmarks of Dubai on this Yacht Tour that departs from the Dubai Marina. Enrich your experience with a tour guide.''',
    };

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            Container(
              height: 250,
              width: double.infinity,
              color: const Color(0xFFF1F3F5),
              child: const Icon(
                Icons.sailing,
                size: 100,
                color: AppTheme.primaryColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Text(
                    eventData['name'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(eventData['price']),
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Info chips
                  LayoutBuilder(
                    builder: (context, constraints) => Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          InfoChip(
                            label: 'Type',
                            value: eventData['type'],
                          ),
                          InfoChip(
                            label: 'Category',
                            value: eventData['category'],
                          ),
                          InfoChip(
                            label: 'Duration',
                            value: eventData['duration'],
                          ),
                          InfoChip(
                            label: 'Guide',
                            value: eventData['guide'],
                          ),
                          InfoChip(
                            label: 'Location',
                            value: eventData['location'],
                          ),
                          InfoChip(
                            label: 'Food & drinks',
                            value: eventData['foodAndDrinks'],
                          ),
                          InfoChip(
                            label: 'Access',
                            value: eventData['access'],
                          ),
                        ],
                      ),
                  ),
                  const SizedBox(height: 24),
                  // Description
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    eventData['description'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Book button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle booking
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Booking functionality coming soon!'),
                          ),
                        );
                      },
                      child: const Text('Book now'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}