import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/domain/entities/part.dart';

// Parts Repository Provider
final firebasePartsRepositoryProvider = Provider<FirebasePartsRepository>(
  (ref) => FirebasePartsRepository(),
);

// All Parts Stream Provider
final allPartsProvider = StreamProvider<List<Part>>((ref) {
  final repo = ref.watch(firebasePartsRepositoryProvider);
  return repo.getPartsStream();
});

// Filtered Parts Provider
final filteredPartsProvider =
    StreamProvider.family<List<Part>, PartsFilters>((ref, filters) {
  final repo = ref.watch(firebasePartsRepositoryProvider);
  return repo.getFilteredPartsStream(filters);
});

// Sponsored Parts Provider
final sponsoredPartsProvider = StreamProvider<List<Part>>((ref) {
  final repo = ref.watch(firebasePartsRepositoryProvider);
  return repo.getSponsoredPartsStream();
});

/// Parts filters class
@immutable
class PartsFilters {
  const PartsFilters({
    this.category,
    this.brand,
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.inStockOnly = true,
    this.searchQuery,
  });

  final String? category;
  final String? brand;
  final double? minPrice;
  final double? maxPrice;
  final double? minRating;
  final bool inStockOnly;
  final String? searchQuery;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartsFilters &&
          runtimeType == other.runtimeType &&
          category == other.category &&
          brand == other.brand &&
          minPrice == other.minPrice &&
          maxPrice == other.maxPrice &&
          minRating == other.minRating &&
          inStockOnly == other.inStockOnly &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      category.hashCode ^
      brand.hashCode ^
      minPrice.hashCode ^
      maxPrice.hashCode ^
      minRating.hashCode ^
      inStockOnly.hashCode ^
      searchQuery.hashCode;
}

/// Firebase Parts Repository
class FirebasePartsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _partsCollection =>
      _firestore.collection('parts');

  /// Get all parts stream
  Stream<List<Part>> getPartsStream({int limit = 50}) => _partsCollection
        .where('inStock', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .snapshots()
        .map(_mapSnapshotToParts);

  /// Get filtered parts stream
  Stream<List<Part>> getFilteredPartsStream(PartsFilters filters) {
    Query<Map<String, dynamic>> query = _partsCollection;

    // Apply in-stock filter
    if (filters.inStockOnly) {
      query = query.where('inStock', isEqualTo: true);
    }

    // Apply category filter
    if (filters.category != null && filters.category!.isNotEmpty) {
      query = query.where('category', isEqualTo: filters.category);
    }

    // Apply brand filter
    if (filters.brand != null && filters.brand!.isNotEmpty) {
      query = query.where('brand', isEqualTo: filters.brand);
    }

    // Order by rating if filter applied, otherwise by created date
    if (filters.minRating != null) {
      query = query.orderBy('rating', descending: true);
    } else {
      query = query.orderBy('createdAt', descending: true);
    }

    return query.limit(50).snapshots().map((snapshot) {
      var parts = _mapSnapshotToParts(snapshot);

      // Apply price filters (client-side)
      if (filters.minPrice != null) {
        parts = parts.where((part) => part.price >= filters.minPrice!).toList();
      }

      if (filters.maxPrice != null) {
        parts = parts.where((part) => part.price <= filters.maxPrice!).toList();
      }

      // Apply rating filter (client-side)
      if (filters.minRating != null) {
        parts = parts
            .where((part) => (part.rating ?? 0) >= filters.minRating!)
            .toList();
      }

      // Apply search query (client-side)
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        final query = filters.searchQuery!.toLowerCase();
        parts = parts.where((part) {
          final name = part.name.toLowerCase();
          final description = (part.description ?? '').toLowerCase();
          final brand = part.brand.toLowerCase();
          return name.contains(query) ||
              description.contains(query) ||
              brand.contains(query);
        }).toList();
      }

      return parts;
    });
  }

  /// Get sponsored parts
  Stream<List<Part>> getSponsoredPartsStream() => _partsCollection
        .where('isSponsored', isEqualTo: true)
        .where('inStock', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map(_mapSnapshotToParts);

  /// Get single part
  Future<Part?> getPart(String partId) async {
    final doc = await _partsCollection.doc(partId).get();
    if (!doc.exists) {
      return null;
    }

    final data = doc.data()!;
    data['id'] = doc.id;

    // Handle Timestamp conversions
    if (data['createdAt'] is Timestamp) {
      data['createdAt'] =
          (data['createdAt'] as Timestamp).toDate().toIso8601String();
    }
    if (data['updatedAt'] is Timestamp) {
      data['updatedAt'] =
          (data['updatedAt'] as Timestamp).toDate().toIso8601String();
    }

    return Part.fromJson(data);
  }

  /// Search parts
  Future<List<Part>> searchParts(String query) async {
    final snapshot = await _partsCollection
        .where('inStock', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(100)
        .get();

    final parts = _mapSnapshotToParts(snapshot);
    final lowerQuery = query.toLowerCase();

    return parts.where((part) {
      final name = part.name.toLowerCase();
      final description = (part.description ?? '').toLowerCase();
      final brand = part.brand.toLowerCase();
      final category = part.category.toLowerCase();
      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          brand.contains(lowerQuery) ||
          category.contains(lowerQuery);
    }).toList();
  }

  /// Helper to map snapshot to Part list
  List<Part> _mapSnapshotToParts(
    QuerySnapshot<Map<String, dynamic>> snapshot) => snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;

      // Handle Timestamp conversions
      if (data['createdAt'] is Timestamp) {
        data['createdAt'] =
            (data['createdAt'] as Timestamp).toDate().toIso8601String();
      }
      if (data['updatedAt'] is Timestamp) {
        data['updatedAt'] =
            (data['updatedAt'] as Timestamp).toDate().toIso8601String();
      }

      return Part.fromJson(data);
    }).toList();
}