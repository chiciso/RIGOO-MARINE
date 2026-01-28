import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Auth Repository Provider
final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) =>
 FirebaseAuthRepository());

// Auth State Provider
final authStateProvider = StreamProvider<User?>((ref) =>
 FirebaseAuth.instance.authStateChanges());

// Current User Provider
final currentUserProvider = StreamProvider<Map<String, dynamic>?>((ref) {
  final authState = ref.watch(authStateProvider);
  
  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value(null);
      }
      return FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .snapshots()
          .map((doc) => doc.exists ? {'id': doc.id, ...doc.data()!} : null);
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

class FirebaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Sign up
  Future<User?> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update display name
      await credential.user?.updateDisplayName(fullName);

      // User document is auto-created by Cloud Function
      // But we can update additional fields
      await _firestore.collection('users').doc(credential.user!.uid).set({
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'profileImageUrl': '',
        'bio': '',
        'role': 'user',
        'emailVerified': credential.user!.emailVerified,
        'wishlist': [],
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'isActive': true,
      }, SetOptions(merge: true));

      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign in
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Update last login
      await _firestore.collection('users').doc(credential.user!.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });

      return credential.user;
    } catch (e) {
      rethrow;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Reload user to check verification status
  Future<void> reloadUser() async {
    await _auth.currentUser?.reload();
  }

  // Check if email is verified
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  // Update profile
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
    String? profileImageUrl,
  }) async {
    final userId = currentUser?.uid;
    if (userId == null) {
      throw Exception('User not logged in');
    }

    final updateData = <String, dynamic>{};
    if (fullName != null) {
      updateData['fullName'] = fullName;
    }
    if (phoneNumber != null) {
      updateData['phoneNumber'] = phoneNumber;
    }
    if (bio != null) {
      updateData['bio'] = bio;
    }
    if (profileImageUrl != null) {
      updateData['profileImageUrl'] = profileImageUrl;
    }

    if (updateData.isNotEmpty) {
      updateData['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection('users').doc(userId).update(updateData);
    }

    // Update display name in auth
    if (fullName != null) {
      await currentUser?.updateDisplayName(fullName);
    }
  }

  // Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    // Re-authenticate user
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );
    await user.reauthenticateWithCredential(credential);

    // Update password
    await user.updatePassword(newPassword);
  }

  // Delete account
  Future<void> deleteAccount(String password) async {
    final user = currentUser;
    if (user == null || user.email == null) {
      throw Exception('User not logged in');
    }

    // Re-authenticate
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);

    // Delete user (Cloud Function will handle cleanup)
    await user.delete();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}