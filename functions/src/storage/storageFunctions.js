const functions = require("firebase-functions");
const admin = require("firebase-admin");
const sharp = require("sharp");
const { logger } = require("firebase-functions");
const path = require("path");
const os = require("os");
const fs = require("fs");

/**
 * Triggered when an image is uploaded to Cloud Storage
 * Creates optimized versions of the image
 */
exports.onImageUploaded = functions.storage.object().onFinalize(async (object) => {
  const filePath = object.name;
  const contentType = object.contentType;

  // Exit if this is not an image
  if (!contentType || !contentType.startsWith("image/")) {
    logger.info("Not an image file, skipping...");
    return null;
  }

  // Exit if this is already a thumbnail
  if (filePath.includes("_thumb") || filePath.includes("_optimized")) {
    logger.info("Already processed image, skipping...");
    return null;
  }

  const bucket = admin.storage().bucket(object.bucket);
  const fileName = path.basename(filePath);
  const fileDir = path.dirname(filePath);
  const tempFilePath = path.join(os.tmpdir(), fileName);

  try {
    // Download file from bucket
    await bucket.file(filePath).download({ destination: tempFilePath });
    logger.info(`Image downloaded locally to ${tempFilePath}`);

    // Generate thumbnail (300x300)
    const thumbFileName = fileName.replace(/\.[^.]+$/, "_thumb.jpg");
    const thumbFilePath = path.join(os.tmpdir(), thumbFileName);
    const thumbUploadPath = path.join(fileDir, thumbFileName);

    await sharp(tempFilePath)
        .resize(300, 300, {
          fit: "cover",
          position: "center",
        })
        .jpeg({ quality: 80 })
        .toFile(thumbFilePath);

    await bucket.upload(thumbFilePath, {
      destination: thumbUploadPath,
      metadata: {
        contentType: "image/jpeg",
        metadata: {
          originalFile: filePath,
          type: "thumbnail",
        },
      },
    });

    logger.info(`Thumbnail uploaded to ${thumbUploadPath}`);

    // Generate optimized version (max 1200x900)
    const optimizedFileName = fileName.replace(/\.[^.]+$/, "_optimized.jpg");
    const optimizedFilePath = path.join(os.tmpdir(), optimizedFileName);
    const optimizedUploadPath = path.join(fileDir, optimizedFileName);

    await sharp(tempFilePath)
        .resize(1200, 900, {
          fit: "inside",
          withoutEnlargement: true,
        })
        .jpeg({ quality: 85 })
        .toFile(optimizedFilePath);

    await bucket.upload(optimizedFilePath, {
      destination: optimizedUploadPath,
      metadata: {
        contentType: "image/jpeg",
        metadata: {
          originalFile: filePath,
          type: "optimized",
        },
      },
    });

    logger.info(`Optimized image uploaded to ${optimizedUploadPath}`);

    // Clean up temp files
    fs.unlinkSync(tempFilePath);
    fs.unlinkSync(thumbFilePath);
    fs.unlinkSync(optimizedFilePath);

    return null;
  } catch (error) {
    logger.error("Error processing image:", error);
    return null;
  }
});

/**
 * Triggered when an image is deleted from Cloud Storage
 * Cleans up associated thumbnails and optimized versions
 */
exports.onImageDeleted = functions.storage.object().onDelete(async (object) => {
  const filePath = object.name;

  // Skip if this is already a processed image
  if (filePath.includes("_thumb") || filePath.includes("_optimized")) {
    return null;
  }

  const bucket = admin.storage().bucket(object.bucket);
  const fileName = path.basename(filePath);
  const fileDir = path.dirname(filePath);

  try {
    // Delete thumbnail
    const thumbFileName = fileName.replace(/\.[^.]+$/, "_thumb.jpg");
    const thumbPath = path.join(fileDir, thumbFileName);

    try {
      await bucket.file(thumbPath).delete();
      logger.info(`Deleted thumbnail: ${thumbPath}`);
    } catch (error) {
      logger.warn(`Thumbnail not found or already deleted: ${thumbPath}`);
    }

    // Delete optimized version
    const optimizedFileName = fileName.replace(/\.[^.]+$/, "_optimized.jpg");
    const optimizedPath = path.join(fileDir, optimizedFileName);

    try {
      await bucket.file(optimizedPath).delete();
      logger.info(`Deleted optimized image: ${optimizedPath}`);
    } catch (error) {
      logger.warn(`Optimized image not found or already deleted: ${optimizedPath}`);
    }

    return null;
  } catch (error) {
    logger.error("Error deleting associated images:", error);
    return null;
  }
});

/**
 * Callable function to get signed URLs for images
 */
exports.getImageUrl = functions.https.onCall(async (data, context) => {
  const { imagePath } = data;

  if (!imagePath) {
    throw new functions.https.HttpsError("invalid-argument", "Image path is required");
  }

  try {
    const bucket = admin.storage().bucket();
    const file = bucket.file(imagePath);

    // Generate signed URL (valid for 7 days)
    const [url] = await file.getSignedUrl({
      action: "read",
      expires: Date.now() + 7 * 24 * 60 * 60 * 1000, // 7 days
    });

    return { url };
  } catch (error) {
    logger.error("Error generating image URL:", error);
    throw new functions.https.HttpsError("internal", "Failed to generate image URL");
  }
});