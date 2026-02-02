import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/entities/service.dart';

// Services Repository Provider
final firebaseServicesRepositoryProvider = Provider<FirebaseServicesRepository>(
  (ref) => FirebaseServicesRepository(),
);

// All Services Stream Provider
final allServicesProvider = StreamProvider<List<Service>>((ref) {
  final repo = ref.watch(firebaseServicesRepositoryProvider);
  return repo.getServicesStream();
});

// Filtered Services Provider
final filteredServicesProvider =
    StreamProvider.family<List<Service>, ServicesFilters>((ref, filters) {
  final repo = ref.watch(firebaseServicesRepositoryProvider);
  return repo.getFilteredServicesStream(filters);
});

// Top Rated Services Provider
final topRatedServicesProvider = StreamProvider<List<Service>>((ref) {
  final repo = ref.watch(firebaseServicesRepositoryProvider);
  return repo.getTopRatedServicesStream();
});

/// Services filters class
@immutable
class ServicesFilters {
  const ServicesFilters({
    this.serviceType,
    this.minRating,
    this.availableOnly = true,
    this.location,
    this.searchQuery,
  });

  final String? serviceType; // Engine repair, Maintenance, etc.
  final double? minRating;
  final bool availableOnly;
  final String? location;
  final String? searchQuery;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ServicesFilters &&
          runtimeType == other.runtimeType &&
          serviceType == other.serviceType &&
          minRating == other.minRating &&
          availableOnly == other.availableOnly &&
          location == other.location &&
          searchQuery == other.searchQuery;

  @override
  int get hashCode =>
      serviceType.hashCode ^
      minRating.hashCode ^
      availableOnly.hashCode ^
      location.hashCode ^
      searchQuery.hashCode;
}

/// Firebase Services Repository
class FirebaseServicesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _servicesCollection =>
      _firestore.collection('services');

  /// Get all services stream
  Stream<List<Service>> getServicesStream({int limit = 50}) =>
   _servicesCollection
        .orderBy('rating', descending: true)
        .limit(limit)
        .snapshots()
        .map(_mapSnapshotToServices);

  /// Get filtered services stream
  Stream<List<Service>> getFilteredServicesStream(ServicesFilters filters) {
    Query<Map<String, dynamic>> query = _servicesCollection;

    // Apply availability filter
    if (filters.availableOnly) {
      query = query.where('isAvailable', isEqualTo: true);
    }

    // Apply location filter
    if (filters.location != null && filters.location!.isNotEmpty) {
      query = query
          .where('location', isGreaterThanOrEqualTo: filters.location)
          .where('location', isLessThan: '${filters.location}z');
    }

    // Order by rating
    query = query.orderBy('rating', descending: true);

    return query.limit(50).snapshots().map((snapshot) {
      var services = _mapSnapshotToServices(snapshot);

      // Apply service type filter (client-side for array contains)
      if (filters.serviceType != null && filters.serviceType!.isNotEmpty) {
        services = services.where((service) => service.services
              .any((s) => s.toLowerCase().contains(
                filters.serviceType!.toLowerCase()))).toList();
      }

      // Apply rating filter (client-side)
      if (filters.minRating != null) {
        services = services
            .where((service) => (service.rating) >= filters.minRating!)
            .toList();
      }

      // Apply search query (client-side)
      if (filters.searchQuery != null && filters.searchQuery!.isNotEmpty) {
        final query = filters.searchQuery!.toLowerCase();
        services = services.where((service) {
          final name = service.mechanicName.toLowerCase();
          final description = (service.description ?? '').toLowerCase();
          final servicesList =
              service.services.map((s) => s.toLowerCase()).join(' ');
          return name.contains(query) ||
              description.contains(query) ||
              servicesList.contains(query);
        }).toList();
      }

      return services;
    });
  }

  /// Get top rated services
  Stream<List<Service>> getTopRatedServicesStream() =>
   _servicesCollection
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(10)
        .snapshots()
        .map(_mapSnapshotToServices);

  /// Get single service
  Future<Service?> getService(String serviceId) async {
    final doc = await _servicesCollection.doc(serviceId).get();
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

    return Service.fromJson(data);
  }

  /// Search services
  Future<List<Service>> searchServices(String query) async {
    final snapshot = await _servicesCollection
        .where('isAvailable', isEqualTo: true)
        .orderBy('rating', descending: true)
        .limit(100)
        .get();

    final services = _mapSnapshotToServices(snapshot);
    final lowerQuery = query.toLowerCase();

    return services.where((service) {
      final name = service.mechanicName.toLowerCase();
      final description = (service.description ?? '').toLowerCase();
      final servicesList =
          service.services.map((s) => s.toLowerCase()).join(' ');
      return name.contains(lowerQuery) ||
          description.contains(lowerQuery) ||
          servicesList.contains(lowerQuery);
    }).toList();
  }

  /// Helper to map snapshot to Service list
  List<Service> _mapSnapshotToServices(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) => snapshot.docs.map((doc) {
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

      return Service.fromJson(data);
    }).toList();
}