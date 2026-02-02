import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';
import '../widgets/info_chip.dart';

/// Provider to fetch single listing from Firebase
final listingDetailsProvider = StreamProvider.family<
    DocumentSnapshot<Map<String, dynamic>>,
    String>((ref, listingId) => FirebaseFirestore.instance
      .collection('listings')
      .doc(listingId)
      .snapshots());

/// Item details screen with Firebase data
class ItemDetailsScreen extends ConsumerStatefulWidget {
  const ItemDetailsScreen({
    required this.itemId,
    super.key,
  });

  final String itemId;

  @override
  ConsumerState<ItemDetailsScreen> createState() => _ItemDetailsScreenState();
}

class _ItemDetailsScreenState extends ConsumerState<ItemDetailsScreen> {
  final PageController _pageController = PageController();
  bool _isInWishlist = false;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  String _formatPrice(double price) {
    final formatter = NumberFormat.currency(symbol: r'$', decimalDigits: 0);
    return formatter.format(price);
  }

  @override
  Widget build(BuildContext context) {
    // Watch listing from Firebase
    final listingAsync = ref.watch(listingDetailsProvider(widget.itemId));

    return Scaffold(
      backgroundColor: Colors.white,
      body: listingAsync.when(
        data: (snapshot) {
          if (!snapshot.exists) {
            return const Center(
              child: Text('Listing not found'),
            );
          }

          final data = snapshot.data()!;
          final name = data['name'] as String? ?? 'Unknown';
          final price = (data['price'] as num?)?.toDouble() ?? 0.0;
          final description = data['description'] as String? ?? '';
          final imageUrls = (data['imageUrls'] as List<dynamic>?)
                  ?.cast<String>() ??
              [];
          final category = data['category'] as String? ?? '';
          final condition = data['condition'] as String? ?? '';
          final engineModel = data['engineModel'] as String? ?? '';
          final bodyModel = data['bodyModel'] as String? ?? '';
          final engineType = data['engineType'] as String? ?? '';
          final enginePower = data['enginePower'] as String? ?? '';
          final engineHours = data['engineHours'] as String? ?? '';
          final bodyLength = data['bodyLength'] as String? ?? '';

          return CustomScrollView(
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
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cart coming soon!')),
                      );
                    },
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (imageUrls.isNotEmpty)
                        PageView.builder(
                          controller: _pageController,
                          itemCount: imageUrls.length,
                          itemBuilder: (context, index) => CachedNetworkImage(
                            imageUrl: imageUrls[index],
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.1,
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFFF1F3F5),
                              child: const Icon(
                                Icons.directions_boat,
                                size: 100,
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          ),
                        )
                      else
                        Container(
                          color: const Color(0xFFF1F3F5),
                          child: const Icon(
                            Icons.directions_boat,
                            size: 100,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      if (imageUrls.length > 1)
                        Positioned(
                          bottom: 16,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: SmoothPageIndicator(
                              controller: _pageController,
                              count: imageUrls.length,
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
                        name,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatPrice(price),
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
                            if (category.isNotEmpty)
                              InfoChip(
                                label: 'Category',
                                value: category,
                              ),
                            if (condition.isNotEmpty)
                              InfoChip(
                                label: 'Condition',
                                value: condition,
                              ),
                            if (engineModel.isNotEmpty)
                              InfoChip(
                                label: 'Engine Model',
                                value: engineModel,
                              ),
                            if (bodyModel.isNotEmpty)
                              InfoChip(
                                label: 'Body Model',
                                value: bodyModel,
                              ),
                            if (engineType.isNotEmpty)
                              InfoChip(
                                label: 'Engine Type',
                                value: engineType,
                              ),
                            if (enginePower.isNotEmpty)
                              InfoChip(
                                label: 'Engine Power',
                                value: enginePower,
                              ),
                            if (engineHours.isNotEmpty)
                              InfoChip(
                                label: 'Engine Hours',
                                value: engineHours,
                              ),
                            if (bodyLength.isNotEmpty)
                              InfoChip(
                                label: 'Body Length',
                                value: bodyLength,
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Description
                      if (description.isNotEmpty) ...[
                        Text(
                          'Description',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: AppTheme.textSecondary,
                                    height: 1.5,
                                  ),
                        ),
                      ],
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const LoadingIndicator(
          message: 'Loading listing...',
        ),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(listingDetailsProvider(widget.itemId));
          },
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isInWishlist
                              ? 'Added to wishlist'
                              : 'Removed from wishlist',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Contact seller coming soon!'),
                      ),
                    );
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
}