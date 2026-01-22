import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../widgets/category_chip.dart';
import '../widgets/filter_chip_widget.dart';
import '../widgets/listing_card.dart';

class MarketplaceScreen extends StatefulWidget {
  const MarketplaceScreen({super.key});

  @override
  State<MarketplaceScreen> createState() => _MarketplaceScreenState();
}

class _MarketplaceScreenState extends State<MarketplaceScreen> {
  String _selectedCategory = 'Boats';
  String _selectedFilter = 'All';

  // Mock data
  final List<Map<String, dynamic>> _featuredListings = [
    {
      'id': '1',
      'name': '2006 Sunseeker 82',
      'price': 1800000.0,
      'imageUrl': 'https://via.placeholder.com/400x300',
    },
    {
      'id': '2',
      'name': '2019 Azimut 60',
      'price': 2500000.0,
      'imageUrl': 'https://via.placeholder.com/400x300',
    },
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Marketplace'),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: () {
              // Navigate to cart
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
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
            // Featured listings grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _featuredListings.length,
              itemBuilder: (context, index) {
                final listing = _featuredListings[index];
                return ListingCard(
                  name: listing['name'],
                  price: listing['price'],
                  imageUrl: listing['imageUrl'],
                  onTap: () {
                    context.go(
                      AppConstants.itemDetailsRoute,
                      extra: listing['id'],
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            // See all button
            Center(
              child: OutlinedButton(
                onPressed: () {
                  // Show all listings
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 48,
                    vertical: 16,
                  ),
                ),
                child: const Text('See all listings'),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
}