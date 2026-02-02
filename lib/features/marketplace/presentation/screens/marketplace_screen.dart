import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../../data/firebase_listings_repository.dart';
import '../widgets/category_chip.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/listing_card.dart';

/// Marketplace screen showing boat listings from Firebase
class MarketplaceScreen extends ConsumerStatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  ConsumerState<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends ConsumerState<MarketplaceScreen> {
  String _selectedCategory = 'Boats';
  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    // Watch listings from Firebase based on selected filters
    final listingsAsync = ref.watch(
      filteredListingsProvider(
        ListingFilters(
          category: _selectedCategory,
          // Add more filters based on _selectedFilter
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // TODO: Navigate to cart
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
                hintText: 'Search for boats, yachts and more',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: const Color(0xFFF8F9FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onTap: () {
                // Navigate to search screen
                // context.push(AppConstants.searchRoute);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search coming soon!')),
                );
              },
              readOnly: true,
            ),
          ),

          // Category tabs
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.boatCategories.length,
              itemBuilder: (context, index) {
                final category = AppConstants.boatCategories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: CategoryChipWidget(
                    label: category,
                    isSelected: _selectedCategory == category,
                    onTap: () {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Filter chips
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: AppConstants.listingFilters.length,
              itemBuilder: (context, index) {
                final filter = AppConstants.listingFilters[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChipWidget(
                    label: filter,
                    isSelected: _selectedFilter == filter,
                    onTap: () {
                      setState(() => _selectedFilter = filter);
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // Featured listings section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Featured listings',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          const SizedBox(height: 16),

          // Listings from Firebase
          Expanded(
            child: listingsAsync.when(
              data: (listings) {
                if (listings.isEmpty) {
                  return const EmptyState(
                    icon: Icons.directions_boat_outlined,
                    title: 'No listings found',
                    message: 'Check back later for new listings',
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    // Refresh listings
                    ref.invalidate(filteredListingsProvider);
                  },
                  child: GridView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    gridDelegate:
                     const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.75,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: listings.length,
                    itemBuilder: (context, index) {
                      final listing = listings[index];
                      
                      return ListingCard(
                        name: listing['name'] as String? ?? 'Unknown',
                        price: (listing['price'] as num?)?.toDouble() ?? 0.0,
                        imageUrl: (listing['imageUrls'] as List<dynamic>?)
                                ?.firstOrNull as String? ??
                            '',
                        onTap: () {
                          context.push(
                            AppConstants.itemDetailsRoute,
                            extra: listing['id'] as String,
                          );
                        },
                      );
                    },
                  ),
                );
              },
              loading: () => const LoadingIndicator(
                message: 'Loading listings...',
              ),
              error: (error, stack) => ErrorView(
                message: error.toString(),
                onRetry: () {
                  ref.invalidate(filteredListingsProvider);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}