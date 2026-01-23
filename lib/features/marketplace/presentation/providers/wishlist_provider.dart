import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

// Wishlist State
class WishlistNotifier extends StateNotifier<Set<String>> {
  WishlistNotifier() : super({});

  void addToWishlist(String itemId) {
    state = {...state, itemId};
  }

  void removeFromWishlist(String itemId) {
    state = state.where((id) => id != itemId).toSet();
  }

  bool isInWishlist(String itemId) => state.contains(itemId);

  void toggleWishlist(String itemId) {
    if (isInWishlist(itemId)) {
      removeFromWishlist(itemId);
    } else {
      addToWishlist(itemId);
    }
  }

  void clearWishlist() {
    state = {};
  }
}

// Provider
final wishlistProvider = StateNotifierProvider<WishlistNotifier, Set<String>>(
  (ref) => WishlistNotifier(),
);

// Helper provider to check if item is in wishlist
final isInWishlistProvider = Provider.family<bool, String>((ref, itemId) {
  final wishlist = ref.watch(wishlistProvider);
  return wishlist.contains(itemId);
});