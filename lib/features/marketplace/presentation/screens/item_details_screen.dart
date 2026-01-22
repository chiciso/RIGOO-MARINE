import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_theme.dart';
import '../widgets/info_chip.dart';

class ItemDetailsScreen extends StatefulWidget {

  const ItemDetailsScreen({
    required this.itemId, super.key,
  });
  final String itemId;

  @override
  State<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends State<ItemDetailsScreen> {
  final PageController _pageController = PageController();
  bool _isInWishlist = false;

  // Mock data
  final Map<String, dynamic> _itemData = {
    'name': 'Yacht 2023',
    'price': 4000000.0,
    'category': 'Yachts',
    'condition': 'Used-Perfect',
    'engineModel': 'Yamaha F300',
    'bodyModel': 'Sea Ray 270',
    'engineType': 'Inboard',
    'enginePower': '300 HP',
    'engineHours': '150 hours',
    'bodyLength': '27 feet',
    'description':
        """
A luxury yacht is a vessel that offers the highest level of comfort and privacy. With a professional crew on board, you'll enjoy an unparalleled level of service.""",
    'images': [
      'https://via.placeholder.com/800x600',
      'https://via.placeholder.com/800x600',
      'https://via.placeholder.com/800x600',
    ],
  };

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // App bar with image carousel
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.arrow_back, color: Colors.black),
              ),
              onPressed: () => context.pop(),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.black,
                  ),
                ),
                onPressed: () {},
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  PageView.builder(
                    controller: _pageController,
                    itemCount: _itemData['images'].length,
                    itemBuilder: (context, index) => Container(
                        color: const Color(0xFFF1F3F5),
                        child: const Icon(
                          Icons.directions_boat,
                          size: 100,
                          color: AppTheme.primaryColor,
                        ),
                      ),
                  ),
                  Positioned(
                    bottom: 16,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: SmoothPageIndicator(
                        controller: _pageController,
                        count: _itemData['images'].length,
                        effect: const ExpandingDotsEffect(
                          activeDotColor: Colors.white,
                          dotColor: Colors.white54,
                          dotHeight: 8,
                          dotWidth: 8,
                          spacing: 4,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Text(
                    _itemData['name'],
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatPrice(_itemData['price']),
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
                            label: 'Category',
                            value: _itemData['category'],
                          ),
                          InfoChip(
                            label: 'Condition',
                            value: _itemData['condition'],
                          ),
                          InfoChip(
                            label: 'Engine Model',
                            value: _itemData['engineModel'],
                          ),
                          InfoChip(
                            label: 'Body Model',
                            value: _itemData['bodyModel'],
                          ),
                          InfoChip(
                            label: 'Engine Type',
                            value: _itemData['engineType'],
                          ),
                          InfoChip(
                            label: 'Engine Power',
                            value: _itemData['enginePower'],
                          ),
                          InfoChip(
                            label: 'Engine Hours',
                            value: _itemData['engineHours'],
                          ),
                          InfoChip(
                            label: 'Body Length',
                            value: _itemData['bodyLength'],
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
                    _itemData['description'],
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha:0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() => _isInWishlist = !_isInWishlist);
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _isInWishlist ? Icons.favorite : Icons.favorite_border,
                        color: _isInWishlist ? Colors.red : null,
                      ),
                      const SizedBox(width: 8),
                      const Text('Wish List'),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: ElevatedButton(
                  onPressed: () {
                    // Contact seller
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Contact Seller'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
}