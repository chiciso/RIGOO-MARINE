import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Listings Repository Provider
final firebaseListingsRepositoryProvider = Provider<FirebaseListingsRepository>(
  (ref) => FirebaseListingsRepository()
  );

// All Listings Stream Provider
final allListingsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) =>
 ref.watch(firebaseListingsRepositoryProvider).getListingsStream());

// Filtered Listings Provider
final filteredListingsProvider =
 StreamProvider.family<List<Map<String, dynamic>>, ListingFilters>(
  (ref, filters) => ref.watch(
    firebaseListingsRepositoryProvider).getFilteredListingsStream(filters),
);

class ListingFilters {

  const ListingFilters({
    this.category,
    this.minPrice,
    this.maxPrice,
    this.location,
  });
  final String? category;
  final double? minPrice;
  final double? maxPrice;
  final String? location;
}

class FirebaseListingsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get all listings stream
  Stream<List<Map<String, dynamic>>> getListingsStream() => _firestore
        .collection('listings')
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());

  // Get filtered listings stream
  Stream<List<Map<String, dynamic>>> getFilteredListingsStream(
    ListingFilters filters) {
    Query query = _firestore
        .collection('listings')
        .where('isActive', isEqualTo: true);

    if (filters.category != null) {
      query = query.where('category', isEqualTo: filters.category);
    }

    if (filters.location != null) {
      query = query.where('location', isEqualTo: filters.location);
    }
    // So we filter price in memory
    return query
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      var listings = snapshot.docs
          .map((doc) => <String, dynamic>{'id': doc.id, ...?(
            doc.data() as Map<String, dynamic>?)})
          .toList();

      // Apply price filters in memory
      if (filters.minPrice != null) {
        listings = listings.where((listing) {
          final price = listing['price'] as num?;
          return price != null && price >= filters.minPrice!;
        }).toList();
      }

      if (filters.maxPrice != null) {
        listings = listings.where((listing) {
          final price = listing['price'] as num?;
          return price != null && price <= filters.maxPrice!;
        }).toList();
      }

      return listings;
    });
  }

  // Get single listing
  Future<Map<String, dynamic>?> getListing(String id) async {
    final doc = await _firestore.collection('listings').doc(id).get();
    if (!doc.exists) {
      return null;
    }
    return {'id': doc.id, ...doc.data()!};
  }

  // Create listing
  Future<String> createListing({
    required String name,
    required double price,
    required String category,
    required String location,
    required String description,
    required List<String> imageUrls,
    Map<String, dynamic>? specifications,
    List<String>? features,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    final docRef = await _firestore.collection('listings').add({
      'name': name,
      'price': price,
      'category': category,
      'location': location,
      'description': description,
      'imageUrls': imageUrls,
      'specifications': specifications ?? {},
      'features': features ?? [],
      'ownerId': userId,
      'ownerName': userData?['fullName'] ?? 'Unknown',
      'rating': 0.0,
      'reviewCount': 0,
      'isActive': true,
      'isAvailable': true,
      'isFeatured': false,
      'views': 0,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });

    return docRef.id;
  }

  // Update listing
  Future<void> updateListing(String id, Map<String, dynamic> data) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Check ownership
    final doc = await _firestore.collection('listings').doc(id).get();
    if (!doc.exists) {
      throw Exception('Listing not found');
    }
    
    final listingData = doc.data()!;
    if (listingData['ownerId'] != userId) {
      throw Exception('Not authorized to update this listing');
    }

    data['updatedAt'] = FieldValue.serverTimestamp();
    await _firestore.collection('listings').doc(id).update(data);
  }

  // Delete listing
  Future<void> deleteListing(String id) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Check ownership
    final doc = await _firestore.collection('listings').doc(id).get();
    if (!doc.exists) {
      throw Exception('Listing not found');
    }
    
    final listingData = doc.data()!;
    if (listingData['ownerId'] != userId) {
      throw Exception('Not authorized to delete this listing');
    }

    await _firestore.collection('listings').doc(id).delete();
  }

  // Search listings
  Stream<List<Map<String, dynamic>>> searchListings(String query) => _firestore
        .collection('listings')
        .where('isActive', isEqualTo: true)
        .snapshots()
        .map((snapshot) {
      final queryLower = query.toLowerCase();
      return snapshot.docs
          .map((doc) => {'id': doc.id, ...doc.data()})
          .where((listing) {
        final name = (listing['name'] as String?)?.toLowerCase() ?? '';
        final description = (
          listing['description'] as String?)?.toLowerCase() ?? '';
        final location = (listing['location'] as String?)?.toLowerCase() ?? '';
        
        return name.contains(queryLower) ||
            description.contains(queryLower) ||
            location.contains(queryLower);
      }).toList();
    });

  // Get user's listings
  Stream<List<Map<String, dynamic>>> getMyListingsStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('listings')
        .where('ownerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => {'id': doc.id, ...doc.data()})
            .toList());
  }

  // Increment views
  Future<void> incrementViews(String id) async {
    await _firestore.collection('listings').doc(id).update({
      'views': FieldValue.increment(1),
    });
  }
}