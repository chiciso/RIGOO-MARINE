const functions = require("firebase-functions");
const admin = require("firebase-admin");
const { logger } = require("firebase-functions");

/**
 * Triggered when a new user is created in Firebase Auth
 * Creates a corresponding user document in Firestore
 */
exports.onUserCreated = functions.auth.user().onCreate(async (user) => {
  logger.info(`New user created: ${user.uid}`);

  try {
    // Create user document in Firestore
    await admin.firestore().collection("users").doc(user.uid).set({
      fullName: user.displayName || "",
      email: user.email,
      phoneNumber: user.phoneNumber || "",
      profileImageUrl: user.photoURL || "",
      bio: "",
      role: "user",
      emailVerified: user.emailVerified,
      wishlist: [],
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      lastLogin: admin.firestore.FieldValue.serverTimestamp(),
      isActive: true,
    });

    logger.info(`User document created in Firestore for: ${user.uid}`);

    // Send welcome email (if email exists)
    if (user.email) {
      // Trigger welcome email function
      // This will be handled by the email service
      logger.info(`Welcome email queued for: ${user.email}`);
    }

    return null;
  } catch (error) {
    logger.error("Error creating user document:", error);
    return null;
  }
});

/**
 * Triggered when a user is deleted from Firebase Auth
 * Cleans up all user-related data
 */
exports.onUserDeleted = functions.auth.user().onDelete(async (user) => {
  logger.info(`User deleted: ${user.uid}`);

  try {
    const batch = admin.firestore().batch();

    // Delete user document
    const userRef = admin.firestore().collection("users").doc(user.uid);
    batch.delete(userRef);

    // Delete or mark as inactive user's listings
    const listingsSnapshot = await admin.firestore()
        .collection("listings")
        .where("ownerId", "==", user.uid)
        .get();

    listingsSnapshot.forEach((doc) => {
      // Option 1: Delete listings
      // batch.delete(doc.ref);

      // Option 2: Mark as inactive (recommended to preserve data)
      batch.update(doc.ref, {
        isActive: false,
        ownerId: "deleted-user",
        ownerName: "Deleted User",
      });
    });

    // Delete or mark as inactive user's events
    const eventsSnapshot = await admin.firestore()
        .collection("events")
        .where("organizerId", "==", user.uid)
        .get();

    eventsSnapshot.forEach((doc) => {
      batch.update(doc.ref, {
        isActive: false,
        organizerId: "deleted-user",
        organizerName: "Deleted User",
      });
    });

    // Mark user's orders as from deleted user
    const ordersSnapshot = await admin.firestore()
        .collection("orders")
        .where("userId", "==", user.uid)
        .get();

    ordersSnapshot.forEach((doc) => {
      batch.update(doc.ref, {
        userId: "deleted-user",
        userName: "Deleted User",
      });
    });

    // Commit all changes
    await batch.commit();

    logger.info(`User data cleaned up for: ${user.uid}`);
    return null;
  } catch (error) {
    logger.error("Error cleaning up user data:", error);
    return null;
  }
});

/**
 * Callable function to update user profile
 */
exports.updateUserProfile = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { fullName, phoneNumber, bio, profileImageUrl } = data;
  const userId = context.auth.uid;

  try {
    const updateData = {};

    if (fullName !== undefined) updateData.fullName = fullName;
    if (phoneNumber !== undefined) updateData.phoneNumber = phoneNumber;
    if (bio !== undefined) updateData.bio = bio;
    if (profileImageUrl !== undefined) updateData.profileImageUrl = profileImageUrl;

    updateData.updatedAt = admin.firestore.FieldValue.serverTimestamp();

    await admin.firestore().collection("users").doc(userId).update(updateData);

    logger.info(`Profile updated for user: ${userId}`);
    return { success: true, message: "Profile updated successfully" };
  } catch (error) {
    logger.error("Error updating profile:", error);
    throw new functions.https.HttpsError("internal", "Failed to update profile");
  }
});

/**
 * Callable function to toggle wishlist
 */
exports.toggleWishlist = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { listingId } = data;
  const userId = context.auth.uid;

  if (!listingId) {
    throw new functions.https.HttpsError("invalid-argument", "Listing ID is required");
  }

  try {
    const userRef = admin.firestore().collection("users").doc(userId);
    const userDoc = await userRef.get();

    if (!userDoc.exists) {
      throw new functions.https.HttpsError("not-found", "User not found");
    }

    const wishlist = userDoc.data().wishlist || [];
    const index = wishlist.indexOf(listingId);

    if (index > -1) {
      // Remove from wishlist
      wishlist.splice(index, 1);
      await userRef.update({ wishlist });
      logger.info(`Removed from wishlist: ${listingId} for user: ${userId}`);
      return { success: true, inWishlist: false, message: "Removed from wishlist" };
    } else {
      // Add to wishlist
      wishlist.push(listingId);
      await userRef.update({ wishlist });
      logger.info(`Added to wishlist: ${listingId} for user: ${userId}`);
      return { success: true, inWishlist: true, message: "Added to wishlist" };
    }
  } catch (error) {
    logger.error("Error toggling wishlist:", error);
    throw new functions.https.HttpsError("internal", "Failed to update wishlist");
  }
});