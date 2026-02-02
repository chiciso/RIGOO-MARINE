import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/error_view.dart';
import '../../../../core/widgets/loading_indicator.dart';

/// Provider for current user profile
final currentUserProfileProvider =
 StreamProvider<DocumentSnapshot<Map<String, dynamic>>>((ref) {
  final userId = FirebaseAuth.instance.currentUser?.uid;
  if (userId == null) {
    throw Exception('User not logged in');
  }
  
  return FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .snapshots();
});

/// Provider for user's wishlist items
final wishlistItemsProvider = 
StreamProvider<List<Map<String, dynamic>>>((ref) async* {
  final userProfile = await ref.watch(currentUserProfileProvider.future);
  
  if (!userProfile.exists) {
    yield [];
    return;
  }
  
  final data = userProfile.data()!;
  final wishlistIds = (
    data['wishlist'] as List<dynamic>?)?.cast<String>() ?? [];
  
  if (wishlistIds.isEmpty) {
    yield [];
    return;
  }
  
  // Fetch wishlist items from listings
  final listings = await FirebaseFirestore.instance
      .collection('listings')
      .where(FieldPath.documentId, whereIn: wishlistIds.take(10).toList())
      .get();
  
  yield listings.docs
      .map((doc) => {'id': doc.id, ...doc.data()})
      .toList();
});

/// Profile screen with real Firebase data
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _editProfile(
    BuildContext context, Map<String, dynamic> userData) async {
    final fullNameController = TextEditingController(
      text: userData['fullName'] as String? ?? '',
    );
    final phoneController = TextEditingController(
      text: userData['phoneNumber'] as String? ?? '',
    );
    final addressController = TextEditingController(
      text: userData['address'] as String? ?? '',
    );

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Edit Profile',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 24),
            
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                prefixIcon: Icon(Icons.person_outline),
              ),
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
                prefixIcon: Icon(Icons.phone_outlined),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.location_on_outlined),
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    final userId = FirebaseAuth.instance.currentUser?.uid;
                    if (userId == null) {
                      return;
                    }
                    
                    await FirebaseFirestore.instance
                        .collection('users')
                        .doc(userId)
                        .update({
                      'fullName': fullNameController.text.trim(),
                      'phoneNumber': phoneController.text.trim(),
                      'address': addressController.text.trim(),
                      'updatedAt': FieldValue.serverTimestamp(),
                    });
                    
                    if (!context.mounted) {
                      return;
                    }
                    
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Profile updated successfully!'),
                        backgroundColor: AppTheme.successColor,
                      ),
                    );
                  } 
                  on Exception catch (e) {
                    if (!context.mounted) {
                      return;
                    }
                    
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: ${e.toString()}'),
                        backgroundColor: AppTheme.errorColor,
                      ),
                    );
                  }
                },
                child: const Text('Save Changes'),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userProfileAsync = ref.watch(currentUserProfileProvider);
    final wishlistAsync = ref.watch(wishlistItemsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final shouldLogout = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: TextButton.styleFrom(
                        foregroundColor: AppTheme.errorColor,
                      ),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (shouldLogout! == true) {
                await FirebaseAuth.instance.signOut();
                if (!context.mounted) {
                  return;
                }
                // Router will automatically redirect to sign in
              }
            },
          ),
        ],
      ),
      body: userProfileAsync.when(
        data: (userDoc) {
          if (!userDoc.exists) {
            return const Center(
              child: Text('User profile not found'),
            );
          }

          final userData = userDoc.data()!;
          final fullName = userData['fullName'] as String? ?? 'Unknown User';
          final email = userData['email'] as String? ?? '';
          final phoneNumber =
           userData['phoneNumber'] as String? ?? 'Not provided';
          final address = userData['address'] as String? ?? 'Not provided';
          final profileImageUrl = userData['profileImageUrl'] as String? ?? '';

          return RefreshIndicator(
            onRefresh: () async {
              ref..invalidate(currentUserProfileProvider)
              ..invalidate(wishlistItemsProvider);
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 24),
                  
                  // Profile picture
                  CircleAvatar(
                    radius: 60,
                    backgroundColor:
                     AppTheme.primaryColor.withValues(alpha: 0.1),
                    backgroundImage: profileImageUrl.isNotEmpty
                        ? CachedNetworkImageProvider(profileImageUrl)
                        : null,
                    child: profileImageUrl.isEmpty
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: AppTheme.primaryColor,
                          )
                        : null,
                  ),
                  const SizedBox(height: 16),
                  
                  Text(
                    fullName,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    email,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 24),
                  
                  // Edit button
                  OutlinedButton(
                    onPressed: () => _editProfile(context, userData),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 48),
                    ),
                    child: const Text('Edit'),
                  ),
                  const SizedBox(height: 32),
                  
                  // Info sections
                  _buildInfoSection(context, 'Email', 
                    userData['emailVerified'] == true ? 'Verified' : email),
                  const Divider(height: 32),
                  _buildInfoSection(context, 'Phone number', phoneNumber),
                  const Divider(height: 32),
                  _buildInfoSection(context, 'Address', address),
                  const SizedBox(height: 32),
                  
                  // Wishlist section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Wish list',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  wishlistAsync.when(
                    data: (wishlistItems) {
                      if (wishlistItems.isEmpty) {
                        return Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color:
                             AppTheme.primaryColor.withValues(alpha: 0.05),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(
                                  Icons.favorite_border,
                                  size: 48,
                                  color: AppTheme.primaryColor.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No items in wishlist',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(
                                        color: AppTheme.textSecondary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      return SizedBox(
                        height: 150,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: wishlistItems.length,
                          separatorBuilder: (context, index) => 
                              const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final item = wishlistItems[index];
                            final imageUrls = (item['imageUrls'] as List?)
                                ?.cast<String>() ?? [];
                            
                            return Container(
                              width: 200,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F3F5),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor.withValues(
                                          alpha: 0.1,
                                        ),
                                        borderRadius: 
                                        const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: 
                                        const BorderRadius.vertical(
                                          top: Radius.circular(12),
                                        ),
                                        child: imageUrls.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: imageUrls.first,
                                                width: double.infinity,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) => 
                                                    const Center(
                                                      // ignore: lines_longer_than_80_chars
                                                      child: CircularProgressIndicator(),
                                                    ),
                                                errorWidget: (
                                                  context, url, error) =>
                                                    const Center(
                                                      child: Icon(
                                                        Icons.directions_boat,
                                                        size: 48,
                                                        color:
                                                         AppTheme.primaryColor,
                                                      ),
                                                    ),
                                              )
                                            : const Center(
                                                child: Icon(
                                                  Icons.directions_boat,
                                                  size: 48,
                                                  color: AppTheme.primaryColor,
                                                ),
                                              ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      item['name'] as String? ?? 'Unknown',
                                      style:
                                       Theme.of(context).textTheme.titleMedium,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                    loading: () => const SizedBox(
                      height: 150,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                    error: (error, stack) => SizedBox(
                      height: 150,
                      child: Center(
                        child: Text(
                          'Error loading wishlist',
                          style:
                           Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppTheme.errorColor,
                              ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const LoadingIndicator(message: 'Loading profile...'),
        error: (error, stack) => ErrorView(
          message: error.toString(),
          onRetry: () {
            ref.invalidate(currentUserProfileProvider);
          },
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context, String label, String value) => 
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
        ],
      );
}