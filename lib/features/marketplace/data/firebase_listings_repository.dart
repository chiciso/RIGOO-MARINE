import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Listings Repository Provider
final firebaseListingsRepositoryProvider = Provider<FirebaseListingsRepository>(
  (ref) => FirebaseListingsRepository(),
);

// All Listings Stream Provider (with pagination support)
final allListingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(firebaseListingsRepositoryProvider);
  return repo.getListingsStream();
});

// Filtered Listings Provider with better filtering
final filteredListingsProvider =
    StreamProvider.family<List<Map<String, dynamic>>, ListingFilters>(
  (ref, filters) {
    final repo = ref.watch(firebaseListingsRepositoryProvider);
    return repo.getFilteredListingsStream(filters);
  },
);

// Featured Listings Provider
final featuredListingsProvider = StreamProvider<List<Map<String, dynamic>>>(
  (ref) {
    final repo = ref.watch(firebaseListingsRepositoryProvider);
    return repo.getFeaturedListingsStream();
  },
);

// User's Listings Provider
final userListingsProvider = StreamProvider<List<Map<String, dynamic>>>(
  (ref) {
    final repo = ref.watch(firebaseListingsRepositoryProvider);
    return repo.getUserListingsStream();
  },
);

// Single Listing Provider
final singleListingProvider =
    StreamProvider.family<DocumentSnapshot<Map<String, dynamic>>, String>(
  (ref, listingId) => FirebaseFirestore.instance
        .collection('listings')
        .doc(listingId)
        .snapshots(),
);

/// Listing filters class
@immutable
class ListingFilters {
  const ListingFilters({
    this.category,
    this.listingType,
    this.minPrice,
    this.maxPrice,
    this.location,
    this.condition,
    this.searchQuery,
  });

  final String? category;
  final String? listingType; // For Sale, Rent, Charter
  final double? minPrice;
  final double? maxPrice;
  final String? location;
  final String? condition;
  final String? searchQuery;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListingFilters &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          listingType == other.listingType &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          location == other.location &&
          condition == other.condition &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      category.hashCode ^
      listingType.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      location.hashCode ^
      condition.hashCode ^
      searchQuery.hashCode;
}

/// Firebase Listings Repository
class FirebaseListingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collection reference
  CollectionReference<Map<String, dynamic>> get _listingsCollection =>
      _firestore.collection('listings');

  /// Get all listings stream
  Stream<List<Map<String, dynamic>>> getListingsStream({int limit = 50}) =>
   _listingsCollection
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );

  /// Get filtered listings stream
  Stream<List<Map<String, dynamic>>> getFilteredListingsStream(
    ListingFilters filters,
  ) {
    Query<Map<String, dynamic>> query = _listingsCollection;

    // Apply category filter
    if (filters.category != null && filters.category!.isNotEmpty) {
      query = query.where('category', isEqualTo: filters.category);
    }

    // Apply listing type filter (For Sale, Rent, Charter)
    if (filters.listingType != null &&
        filters.listingType!.isNotEmpty &&
        filters.listingType != 'All') {
      query = query.where('listingType', isEqualTo: filters.listingType);
    }

    // Apply condition filter
    if (filters.condition != null && filters.condition!.isNotEmpty) {
      query = query.where('condition', isEqualTo: filters.condition);
    }

    // Apply location filter
    if (filters.location != null && filters.location!.isNotEmpty) {
      query = query.where('address', isGreaterThanOrEqualTo: filters.location)
          .where('address', isLessThan: '${filters.location}z');
    }

    // Order by created date
    query = query.orderBy('createdAt', descending: true);

    return query.limit(50).snapshots().map((snapshot) {
      var listings = snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .toList();

      // Apply price filter (done client-side for flexibility)
      if (filters.minPrice != null) {
        listings = listings.where((listing) {
          final price = (listing['price'] as num?)?.toDouble() ?? 0;
          return price >= filters.minPrice!;
        }).toList();
      }

      if (filters.maxPrice != null) {
        listings = listings.where((listing) {
          final price = (listing['price'] as num?)?.toDouble() ?? 0;
          return price <= filters.maxPrice!;
        }).toList();
      }

      // Apply search query (done client-side)
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        final query = filters.searchQuery!.toLowerCase();
        listings = listings.where((listing) {
          final name = (listing['name'] as String? ?? '').toLowerCase();
          final description =
              (listing['description'] as String? ?? '').toLowerCase();
          return name.contains(query) || description.contains(query);
        }).toList();
      }

      return listings;
    });
  }

  /// Get featured listings
  Stream<List<Map<String, dynamic>>> getFeaturedListingsStream() =>
   _listingsCollection
        .where('isFeatured', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(10)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );

  /// Get user's listings
  Stream<List<Map<String, dynamic>>> getUserListingsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _listingsCollection
        .where('sellerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => {'id': doc.id, ...doc.data()})
              .toList(),
        );
  }

  /// Get single listing
  Future<Map<String, dynamic>?> getListing(String listingId) async {
    final doc = await _listingsCollection.doc(listingId).get();
    if (!doc.exists) {
      return null;
    }
    return {'id': doc.id, ...doc.data()!};
  }

  /// Create new listing
  Future<String> createListing(Map<String, dynamic> listingData) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final docRef = _listingsCollection.doc();
    
    await docRef.set({
      ...listingData,
      'sellerId': userId,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'isFeatured': false,
      'viewCount': 0,
    });

    return docRef.id;
  }

  /// Update listing
  Future<void> updateListing(
    String listingId,
    Map<String, dynamic> updates,
  ) async {
    await _listingsCollection.doc(listingId).update({
      ...updates,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Delete listing
  Future<void> deleteListing(String listingId) async {
    await _listingsCollection.doc(listingId).delete();
  }

  /// Increment view count
  Future<void> incrementViewCount(String listingId) async {
    await _listingsCollection.doc(listingId).update({
      'viewCount': FieldValue.increment(1),
    });
  }

  /// Search listings
  Future<List<Map<String, dynamic>>> searchListings(String query) async {
    // Note: For production, use Algolia or similar service for better search
    // This is a basic client-side search
    final snapshot = await _listingsCollection
        .orderBy('createdAt', descending: true)
        .limit(100)
        .get();

    final listings = snapshot.docs
        .map((doc) => {'id': doc.id, ...doc.data()})
        .toList();

    final lowerQuery = query.toLowerCase();
    return listings.where((listing) {
      final name = (listing['name'] as String? ?? '').toLowerCase();
      final description =
          (listing['description'] as String? ?? '').toLowerCase();
      final category = (listing['category'] as String? ?? '').toLowerCase();
      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          category.contains(lowerQuery);
    }).toList();
  }
}