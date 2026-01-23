import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Cart Item
class CartItem {

  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.imageUrl,
  });
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  CartItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? imageUrl,
  }) => CartItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      imageUrl: imageUrl ?? this.imageUrl,
    );

  double get total => price * quantity;
}

// Cart State
class CartNotifier extends StateNotifier<List<CartItem>> {
  CartNotifier() : super([]);

  void addToCart({
    required String id,
    required String name,
    required double price,
    String? imageUrl,
  }) {
    // Check if item already exists
    final existingIndex = state.indexWhere((item) => item.id == id);

    if (existingIndex >= 0) {
      // Increment quantity
      final updatedItem = state[existingIndex].copyWith(
        quantity: state[existingIndex].quantity + 1,
      );
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      // Add new item
      state = [
        ...state,
        CartItem(
          id: id,
          name: name,
          price: price,
          quantity: 1,
          imageUrl: imageUrl,
        ),
      ];
    }
  }

  void removeFromCart(String id) {
    state = state.where((item) => item.id != id).toList();
  }

  void updateQuantity(String id, int quantity) {
    if (quantity <= 0) {
      removeFromCart(id);
      return;
    }

    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0) {
      final updatedItem = state[index].copyWith(quantity: quantity);
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    }
  }

  void incrementQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0) {
      updateQuantity(id, state[index].quantity + 1);
    }
  }

  void decrementQuantity(String id) {
    final index = state.indexWhere((item) => item.id == id);
    if (index >= 0) {
      updateQuantity(id, state[index].quantity - 1);
    }
  }

  void clearCart() {
    state = [];
  }

  double get totalAmount => state.fold(0, (sum, item) => sum + item.total);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

// Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>(
  (ref) => CartNotifier(),
);

// Helper providers
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.total);
});

final cartItemCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider);
  return cart.fold(0, (sum, item) => sum + item.quantity);
});