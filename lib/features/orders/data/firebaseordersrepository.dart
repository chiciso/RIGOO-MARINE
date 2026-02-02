import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Orders Repository Provider
final firebaseOrdersRepositoryProvider = Provider<FirebaseOrdersRepository>(
  (ref) => FirebaseOrdersRepository(),
);

// User Orders Stream Provider
final userOrdersProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final repo = ref.watch(firebaseOrdersRepositoryProvider);
  return repo.getUserOrdersStream();
});

// Filtered Orders Provider
final filteredOrdersProvider =
    StreamProvider.family<List<Map<String, dynamic>>, OrdersFilters>(
  (ref, filters) {
    final repo = ref.watch(firebaseOrdersRepositoryProvider);
    return repo.getFilteredOrdersStream(filters);
  },
);

/// Orders filters class
@immutable
class OrdersFilters {
  const OrdersFilters({
    this.status,
    this.orderType,
  });

  final String? status; // Pending, Confirmed, Completed, Cancelled
  final String? orderType; // Part, Service, Event

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdersFilters &&
          runtimeType == other.runtimeType &&
          status == other.status &&
          orderType == other.orderType;

  @override
  int get hashCode => status.hashCode ^ orderType.hashCode;
}

/// Order status enum
enum OrderStatus {
  pending('Pending'),
  confirmed('Confirmed'),
  completed('Completed'),
  cancelled('Cancelled');

  const OrderStatus(this.label);
  final String label;
}

/// Order type enum
enum OrderType {
  part('Part'),
  service('Service'),
  event('Event');

  const OrderType(this.label);
  final String label;
}

/// Firebase Orders Repository
class FirebaseOrdersRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection('orders');

  /// Get user's orders stream
  Stream<List<Map<String, dynamic>>> getUserOrdersStream() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(_mapSnapshotToOrders);
  }

  /// Get filtered orders stream
  Stream<List<Map<String, dynamic>>> getFilteredOrdersStream(
    OrdersFilters filters,
  ) {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      return Stream.value([]);
    }

    Query<Map<String, dynamic>> query = _ordersCollection;

    // Always filter by user
    query = query.where('userId', isEqualTo: userId);

    // Apply status filter
    if (filters.status != null && filters.status!.isNotEmpty) {
      query = query.where('status', isEqualTo: filters.status);
    }

    // Apply order type filter
    if (filters.orderType != null && filters.orderType!.isNotEmpty) {
      query = query.where('orderType', isEqualTo: filters.orderType);
    }

    query = query.orderBy('createdAt', descending: true);

    return query.snapshots().map(_mapSnapshotToOrders);
  }

  /// Create a new order (booking)
  Future<String> createOrder({
    required String orderType, // 'Part', 'Service', 'Event'
    required String itemId,
    required String itemName,
    required double price,
    String? notes,
    Map<String, dynamic>? additionalData,
  }) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    // Get user data
    final userDoc = await _firestore.collection('users').doc(userId).get();
    final userData = userDoc.data();

    final orderRef = _ordersCollection.doc();

    await orderRef.set({
      'userId': userId,
      'userName': userData?['fullName'] ?? 'Unknown',
      'userEmail': userData?['email'] ?? '',
      'userPhone': userData?['phoneNumber'] ?? '',
      'orderType': orderType,
      'itemId': itemId,
      'itemName': itemName,
      'price': price,
      'status': OrderStatus.pending.label,
      'notes': notes,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      if (additionalData != null) ...additionalData,
    });

    return orderRef.id;
  }

  /// Book a part
  Future<String> bookPart({
    required String partId,
    required String partName,
    required double price,
    required int quantity,
    String? notes,
  }) async => createOrder(
      orderType: OrderType.part.label,
      itemId: partId,
      itemName: partName,
      price: price * quantity,
      notes: notes,
      additionalData: {
        'quantity': quantity,
        'unitPrice': price,
      },
    );

  /// Book a service
  Future<String> bookService({
    required String serviceId,
    required String serviceName,
    required String mechanicName,
    required double price,
    String? preferredDate,
    String? notes,
  }) async => createOrder(
      orderType: OrderType.service.label,
      itemId: serviceId,
      itemName: serviceName,
      price: price,
      notes: notes,
      additionalData: {
        'mechanicName': mechanicName,
        'preferredDate': preferredDate,
      },
    );

  /// Book an event
  Future<String> bookEvent({
    required String eventId,
    required String eventName,
    required double price,
    required int numberOfPeople,
    String? notes,
  }) async => createOrder(
      orderType: OrderType.event.label,
      itemId: eventId,
      itemName: eventName,
      price: price * numberOfPeople,
      notes: notes,
      additionalData: {
        'numberOfPeople': numberOfPeople,
        'pricePerPerson': price,
      },
    );

  /// Update order status
  Future<void> updateOrderStatus(String orderId, String status) async {
    await _ordersCollection.doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Cancel order
  Future<void> cancelOrder(String orderId, String reason) async {
    await _ordersCollection.doc(orderId).update({
      'status': OrderStatus.cancelled.label,
      'cancellationReason': reason,
      'cancelledAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get single order
  Future<Map<String, dynamic>?> getOrder(String orderId) async {
    final doc = await _ordersCollection.doc(orderId).get();
    if (!doc.exists) {
      return null;
    }
    return {'id': doc.id, ...doc.data()!};
  }

  /// Helper to map snapshot to orders list
  List<Map<String, dynamic>> _mapSnapshotToOrders(
    QuerySnapshot<Map<String, dynamic>> snapshot,
  ) => snapshot.docs.map((doc) {
      final data = doc.data();
      return {'id': doc.id, ...data};
    }).toList();
}