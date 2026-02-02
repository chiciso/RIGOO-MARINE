import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../../auth/domain/entities/part.dart';
import '../../../marketplace/presentation/widgets/category_chip.dart';
import '../data/firebase_parts_repository.dart';


/// Parts screen with Firebase integration
class PartsScreen extends ConsumerStatefulWidget {
  const PartsScreen({super.key});

  @override
  ConsumerState<PartsScreen> createState() => _PartsScreenState();
}

class _PartsScreenState extends ConsumerState<PartsScreen> {
  String _selectedCategory = 'Engine';
  String _searchQuery = '';

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 2);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    // Watch parts from Firebase based on category
    final partsAsync = ref.watch(
      filteredPartsProvider(
        PartsFilters(
          category: _selectedCategory,
          searchQuery: _searchQuery.isEmpty ? null : _searchQuery,
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Boat Parts'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cart coming soon!')),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search boat parts',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),

          // Category tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.partCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.partCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChipWidget(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () {
                      setState(() {
                        _selectedCategory = category;
                        _searchQuery = '';
                         // Clear search when changing category
                      });
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Parts list
          Expanded(
            child: partsAsync.when(
              data: (parts) {
                if (parts.isEmpty) {
                  return const EmptyState(
                    icon: Icons.inventory_2_outlined,
                    title: 'No parts found',
                    message: 'Try adjusting your search or category',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    ref.invalidate(filteredPartsProvider);
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: parts.length,
                    itemBuilder: (context, index) {
                      final part = parts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildPartCard(part),
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingIndicator(
                message: 'Loading parts...',
              ),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(filteredPartsProvider);
                },
              ),
            ),
          ),

          // Results count
          partsAsync.when(
            data: (parts) => Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Showing ${parts.length} result${
                        parts.length != 1 ? 's' : ''}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, _) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildPartCard(Part part) => InkWell(
        onTap: () {
          // Show part details dialog
          _showPartDetails(part);
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE9ECEF)),
          ),
          child: Row(
            children: [
              // Part image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: part.imageUrl != null && part.imageUrl!.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: part.imageUrl!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(
                            child: CircularProgressIndicator(),
                          ),
                          errorWidget: (context, url, error) => const Icon(
                            Icons.settings,
                            color: AppTheme.primaryColor,
                            size: 32,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.settings,
                        color: AppTheme.primaryColor,
                        size: 32,
                      ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sponsored badge
                    if (part.isSponsored)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Sponsored',
                          style: Theme.of(context)
                              .textTheme
                              .labelSmall
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                    const SizedBox(height: 8),

                    // Part name
                    Text(
                      part.name,
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),

                    // Brand
                    Text(
                      part.brand,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                    const SizedBox(height: 4),

                    // Price and rating
                    Row(
                      children: [
                        Text(
                          _formatPrice(part.price),
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (part.rating != null) ...[
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            part.rating!.toStringAsFixed(1),
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  void _showPartDetails(Part part) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E0E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Part name
              Text(
                part.name,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),

              // Brand and category
              Text(
                '${part.brand} • ${part.category}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
              ),
              const SizedBox(height: 16),

              // Price
              Text(
                _formatPrice(part.price),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 24),

              // Description
              if (part.description != null && part.description!.isNotEmpty) ...[
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  part.description!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                ),
                const SizedBox(height: 24),
              ],

              // Stock status
              Row(
                children: [
                  Icon(
                    part.inStock ? Icons.check_circle : Icons.cancel,
                    color: part.inStock
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    part.inStock ? 'In Stock' : 'Out of Stock',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: part.inStock
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Order button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: part.inStock
                      ? () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Order placed! Check Orders tab.'),
                              backgroundColor: AppTheme.successColor,
                            ),
                          );
                          // TODO: Implement order placement
                        }
                      : null,
                  child: const Text('Order Now'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}