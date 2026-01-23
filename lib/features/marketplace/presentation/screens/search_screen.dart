import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/empty_state.dart';
import '../widgets/listing_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();
  bool _isSearching = false;
  List<Map<String, dynamic>> _results = [];

  @override
  void initState() {
    super.initState();
    // Auto-focus search field
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _searchFocus.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _results = [];
        _isSearching = false;
      });
      return;
    }

    setState(() => _isSearching = true);

    // Simulate API search
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock results
    final mockResults = [
      {
        'id': '1',
        'name': '2006 Sunseeker 82',
        'price': 1800000.0,
        'imageUrl': '',
      },
      {
        'id': '2',
        'name': '2019 Azimut 60',
        'price': 2500000.0,
        'imageUrl': '',
      },
    ].where((item) => item['name']
          .toString()
          .toLowerCase()
          .contains(query.toLowerCase())).toList();

    if (!mounted) {
      return;
    }

    setState(() {
      _results = mockResults;
      _isSearching = false;
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          focusNode: _searchFocus,
          decoration: InputDecoration(
            hintText: 'Search boats, yachts...',
            border: InputBorder.none,
            hintStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textHint,
                ),
          ),
          onChanged: _performSearch,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_searchController.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _searchController.clear();
                _performSearch('');
              },
            ),
        ],
      ),
      body: _buildBody(),
    );

  Widget _buildBody() {
    if (_isSearching) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_searchController.text.isEmpty) {
      return const EmptyState(
        icon: Icons.search,
        title: 'Search for boats',
        message: 'Start typing to search for boats, yachts, and more',
      );
    }

    if (_results.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No results found',
        message: 'Try adjusting your search terms',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) {
        final item = _results[index];
        return ListingCard(
          name: item['name'],
          price: item['price'],
          imageUrl: item['imageUrl'],
          onTap: () {
            // Navigate to details
          },
        );
      },
    );
  }
}