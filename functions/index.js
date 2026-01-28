const admin = require("firebase-admin");
admin.initializeApp();

// Import function modules
const authFunctions = require("./src/auth/authFunctions");
const storageFunctions = require("./src/storage/storageFunctions");
const emailService = require("./src/email/emailService");

// Export Auth Functions
exports.onUserCreated = authFunctions.onUserCreated;
exports.onUserDeleted = authFunctions.onUserDeleted;

// Export Storage Functions
exports.onImageUploaded = storageFunctions.onImageUploaded;
exports.onImageDeleted = storageFunctions.onImageDeleted;

// Export Email Functions
exports.sendVerificationEmail = emailService.sendVerificationEmail;
exports.sendWelcomeEmail = emailService.sendWelcomeEmail;
exports.sendOrderConfirmation = emailService.sendOrderConfirmation;

// Export Helper Functions
const functions = require("firebase-functions");
const { logger } = require("firebase-functions");

// Callable function to increment listing views
exports.incrementListingViews = functions.https.onCall(async (data, context) => {
  const { listingId } = data;

  if (!listingId) {
    throw new functions.https.HttpsError("invalid-argument", "Listing ID is required");
  }

  try {
    const listingRef = admin.firestore().collection("listings").doc(listingId);
    await listingRef.update({
      views: admin.firestore.FieldValue.increment(1),
    });

    logger.info(`Incremented views for listing: ${listingId}`);
    return { success: true };
  } catch (error) {
    logger.error("Error incrementing views:", error);
    throw new functions.https.HttpsError("internal", "Failed to increment views");
  }
});

// Callable function to increment event attendees
exports.bookEvent = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError("unauthenticated", "User must be authenticated");
  }

  const { eventId } = data;

  if (!eventId) {
    throw new functions.https.HttpsError("invalid-argument", "Event ID is required");
  }

  try {
    const eventRef = admin.firestore().collection("events").doc(eventId);
    const eventDoc = await eventRef.get();

    if (!eventDoc.exists) {
      throw new functions.https.HttpsError("not-found", "Event not found");
    }

    const eventData = eventDoc.data();

    // Check if event is full
    if (eventData.currentAttendees >= eventData.maxAttendees) {
      throw new functions.https.HttpsError("failed-precondition", "Event is full");
    }

    // Check if event date is in the future
    if (eventData.eventDate.toDate() <= new Date()) {
      throw new functions.https.HttpsError("failed-precondition", "Cannot book past events");
    }

    // Increment attendees
    await eventRef.update({
      currentAttendees: admin.firestore.FieldValue.increment(1),
    });

    logger.info(`User ${context.auth.uid} booked event: ${eventId}`);
    return { success: true, message: "Event booked successfully" };
  } catch (error) {
    logger.error("Error booking event:", error);
    throw new functions.https.HttpsError("internal", error.message);
  }
});

// Scheduled function to clean up old data (runs daily)
exports.cleanupOldData = functions.pubsub.schedule("every 24 hours").onRun(async (context) => {
  const thirtyDaysAgo = new Date();
  thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

  try {
    // Delete inactive listings older than 30 days
    const inactiveListings = await admin.firestore()
        .collection("listings")
        .where("isActive", "==", false)
        .where("updatedAt", "<", thirtyDaysAgo)
        .get();

    const batch = admin.firestore().batch();
    inactiveListings.forEach((doc) => {
      batch.delete(doc.ref);
    });

    await batch.commit();
    logger.info(`Cleaned up ${inactiveListings.size} inactive listings`);

    return null;
  } catch (error) {
    logger.error("Error in cleanup:", error);
    return null;
  }
});

// HTTP function for search (with full-text search capability)
exports.searchListings = functions.https.onCall(async (data, context) => {
  const { query, category, minPrice, maxPrice, limit = 10 } = data;

  if (!query || query.trim() === "") {
    throw new functions.https.HttpsError("invalid-argument", "Search query is required");
  }

  try {
    let listingsRef = admin.firestore()
        .collection("listings")
        .where("isActive", "==", true);

    // Add category filter if provided
    if (category) {
      listingsRef = listingsRef.where("category", "==", category);
    }

    // Get all documents (we'll filter by search query in memory)
    const snapshot = await listingsRef.limit(limit * 2).get();

    const searchLower = query.toLowerCase();
    const results = [];

    snapshot.forEach((doc) => {
      const data = doc.data();
      const nameLower = data.name.toLowerCase();
      const descLower = (data.description || "").toLowerCase();
      const locationLower = (data.location || "").toLowerCase();

      // Simple text matching
      if (nameLower.includes(searchLower) ||
          descLower.includes(searchLower) ||
          locationLower.includes(searchLower)) {
        // Apply price filters
        if (minPrice && data.price < minPrice) return;
        if (maxPrice && data.price > maxPrice) return;

        results.push({
          id: doc.id,
          ...data,
        });
      }
    });

    // Sort by relevance (name matches first)
    results.sort((a, b) => {
      const aNameMatch = a.name.toLowerCase().includes(searchLower);
      const bNameMatch = b.name.toLowerCase().includes(searchLower);
      if (aNameMatch && !bNameMatch) return -1;
      if (!aNameMatch && bNameMatch) return 1;
      return 0;
    });

    return {
      results: results.slice(0, limit),
      total: results.length,
    };
  } catch (error) {
    logger.error("Error searching listings:", error);
    throw new functions.https.HttpsError("internal", "Search failed");
  }
});