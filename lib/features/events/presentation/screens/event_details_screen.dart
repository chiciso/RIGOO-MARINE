import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../marketplace/presentation/widgets/info_chip.dart';
import '../../data/firebase_events_repository.dart';

/// Event details screen with Firebase data
class EventDetailsScreen extends ConsumerWidget {
  const EventDetailsScreen({
    required this.eventId,
    super.key,
  });

  final String eventId;

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch event from Firebase
    final eventAsync = ref.watch(eventDetailsProvider(eventId));

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
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Add to calendar coming soon!'),
                ),
              );
            },
          ),
        ],
      ),
      body: eventAsync.when(
        data: (event) {
          if (event == null) {
            return const Center(
              child: Text('Event not found'),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image
                if (event.imageUrls.isNotEmpty)
                  CachedNetworkImage(
                    imageUrl: event.imageUrls.first,
                    height: 250,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      height: 250,
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    errorWidget: (context, url, error) => Container(
                      height: 250,
                      width: double.infinity,
                      color: const Color(0xFFF1F3F5),
                      child: const Icon(
                        Icons.sailing,
                        size: 100,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                else
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
                        event.name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatPrice(event.bookingPrice),
                        style: Theme.of(context)
                            .textTheme
                            .displaySmall
                            ?.copyWith(
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
                              value: event.eventType,
                            ),
                            if (event.category != null)
                              InfoChip(
                                label: 'Category',
                                value: event.category!,
                              ),
                            if (event.duration != null)
                              InfoChip(
                                label: 'Duration',
                                value: event.duration!,
                              ),
                            if (event.guide != null)
                              InfoChip(
                                label: 'Guide',
                                value: event.guide!,
                              ),
                            if (event.departureLocation != null)
                              InfoChip(
                                label: 'Location',
                                value: event.departureLocation!,
                              ),
                            InfoChip(
                              label: 'Food & drinks',
                              value: event.includesFoodAndDrinks ? 'Yes' : 'No',
                            ),
                            InfoChip(
                              label: 'Access',
                              value: event.accessType,
                            ),
                            if (event.eventDate != null)
                              InfoChip(
                                label: 'Date',
                                value: DateFormat('MMM dd, yyyy')
                                    .format(event.eventDate!),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      if (event.description != null &&
                          event.description!.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description!,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                      const SizedBox(height: 32),

                      // Book button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Booking functionality coming soon!',
                                ),
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
          );
        },
        loading: () => const LoadingIndicator(
          message: 'Loading event...',
        ),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(eventDetailsProvider(eventId));
          },
        ),
      ),
    );
  }
}