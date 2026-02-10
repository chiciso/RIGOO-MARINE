import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// --- Providers ---

/// Auth Repository Provider
final firebaseAuthRepositoryProvider = Provider<FirebaseAuthRepository>((ref) =>
    FirebaseAuthRepository());

/// Auth State Provider - GAP FIXED: 
/// Using userChanges() instead of authStateChanges() ensures that 
/// email verification updates and token refreshes trigger a UI rebuild.
final authStateProvider = StreamProvider<User?>((ref) =>
    FirebaseAuth.instance.userChanges());

/// Current User Data Provider (Firestore sync)
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
          .map((doc) {
            if (!doc.exists) {
              return null;
            }
            final data = doc.data();
            return data != null? {'id':doc.id, ...data} : null;
          });
    },
    loading: () => Stream.value(null),
    error: (_, _) => Stream.value(null),
  );
});

// --- Repository Implementation ---

class FirebaseAuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  bool get isEmailVerified => _auth.currentUser?.emailVerified ?? false;

  /// Sign up with automatic Firestore document creation
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

      final user = credential.user;
      if (user != null) {
        try{
         // Update Firebase Auth Display Name
        await user.updateDisplayName(fullName);
        } on Exception catch (e){
          debugPrint('warning: display name update during signup:$e');
        }

        await user.reload(); 

        // GAP FIXED: Initialize user doc with current verification status
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'profileImageUrl': '',
          'bio': '',
          'role': 'user',
          'emailVerified': user.emailVerified,
          'wishlist': [],
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
          'isActive': true,
        }, SetOptions(merge: true));
      }

      return user;
    } on Exception catch (e) {
      debugPrint('SignUp Error: $e');
      rethrow;
    }
  }

  /// Sign in with safety check for Firestore updates
  Future<User?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user != null) {
        // GAP FIXED: Wrap Firestore update in try-catch.
        // If your Security Rules block unverified users from writing,
        // this would otherwise crash the entire login process.
        try {
          await _firestore.collection('users').doc(user.uid).update({
            'lastLogin': FieldValue.serverTimestamp(),
          });
        }on Exception catch (e) {
          debugPrint(
            // ignore: lines_longer_than_80_chars
            'Note: User logged in, but Firestore update blocked (likely unverified): $e');
        }
      }

      return user;
    } on Exception catch (e) {
      debugPrint('SignIn Error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Send verification email
  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  Future<void> reloadUser() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true); 
        // We still call reload but catch potential internal Pigeon errors
        await user.reload(); 
      }on Exception catch (e) {
        debugPrint('User Reload Internal (Handled): $e');
      }
    }
  }

  /// Update profile data across Auth and Firestore
  Future<void> updateProfile({
    String? fullName,
    String? phoneNumber,
    String? bio,
    String? profileImageUrl,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('User not logged in');
    }

    final updateData = <String, dynamic>{
      'updatedAt': FieldValue.serverTimestamp(),
    };
    
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

    // Update Firestore
    await _firestore.collection('users').doc(user.uid).update(updateData);

    // Sync Display Name to Auth if changed
    if (fullName != null) {
      try {
        await user.updateDisplayName(fullName);
      }on Exception catch (e){
        debugPrint('warning: display name update failed:$e ');
        rethrow;
      }
    }
  }

  /// Re-authenticate and change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _auth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('No user session found');
    }

    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: currentPassword,
    );

    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPassword);
  }

  /// Delete account with re-authentication
  Future<void> deleteAccount(String password) async {
  final user = _auth.currentUser;
  if (user == null || user.email == null) {
    throw Exception('No user session found');
  }

  final userId = user.uid; // Store before deletion

  try {
    // Re-authenticate
    final credential = EmailAuthProvider.credential(
      email: user.email!,
      password: password,
    );
    await user.reauthenticateWithCredential(credential);
    
    // Delete Firestore document first
    await _firestore.collection('users').doc(userId).delete();
    
    // Delete Firebase Auth account
    await user.delete();
    
  } catch (e) {
    debugPrint('Account deletion error: $e');
    rethrow;
  }
}

  /// Send password reset
  Future<void> resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}