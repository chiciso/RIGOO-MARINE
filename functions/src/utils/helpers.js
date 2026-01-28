const { logger } = require("firebase-functions");

/**
 * Validate email format
 */
exports.isValidEmail = (email) => {
  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  return emailRegex.test(email);
};

/**
 * Validate phone number format
 */
exports.isValidPhoneNumber = (phone) => {
  const phoneRegex = /^\+?[\d\s-()]+$/;
  return phoneRegex.test(phone);
};

/**
 * Sanitize string input
 */
exports.sanitizeString = (str) => {
  if (typeof str !== "string") return "";
  return str.trim().replace(/[<>]/g, "");
};

/**
 * Generate random verification code
 */
exports.generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000).toString();
};

/**
 * Format price to USD currency
 */
exports.formatPrice = (price) => {
  return new Intl.NumberFormat("en-US", {
    style: "currency",
    currency: "USD",
  }).format(price);
};

/**
 * Calculate pagination data
 */
exports.calculatePagination = (total, page = 1, limit = 10) => {
  const totalPages = Math.ceil(total / limit);
  const hasNext = page < totalPages;
  const hasPrev = page > 1;

  return {
    total,
    page,
    limit,
    totalPages,
    hasNext,
    hasPrev,
  };
};

/**
 * Generate order number
 */
exports.generateOrderNumber = () => {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = Math.random().toString(36).substring(2, 6).toUpperCase();
  return `RM-${timestamp}-${random}`;
};

/**
 * Validate price range
 */
exports.isValidPriceRange = (minPrice, maxPrice) => {
  if (minPrice < 0 || maxPrice < 0) return false;
  if (minPrice > maxPrice) return false;
  return true;
};

/**
 * Format date to readable string
 */
exports.formatDate = (date) => {
  return new Intl.DateTimeFormat("en-US", {
    year: "numeric",
    month: "long",
    day: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  }).format(date);
};

/**
 * Check if date is in the future
 */
exports.isFutureDate = (date) => {
  return new Date(date) > new Date();
};

/**
 * Log error with context
 */
exports.logError = (functionName, error, context = {}) => {
  logger.error(`Error in ${functionName}:`, {
    error: error.message,
    stack: error.stack,
    context,
  });
};

/**
 * Log info with context
 */
exports.logInfo = (functionName, message, context = {}) => {
  logger.info(`${functionName}: ${message}`, context);
};

/**
 * Validate listing data
 */
exports.validateListingData = (data) => {
  const errors = [];

  if (!data.name || data.name.trim().length < 3) {
    errors.push("Name must be at least 3 characters");
  }

  if (!data.price || data.price < 0) {
    errors.push("Price must be a positive number");
  }

  if (!data.category) {
    errors.push("Category is required");
  }

  if (!data.location) {
    errors.push("Location is required");
  }

  if (!data.description || data.description.trim().length < 10) {
    errors.push("Description must be at least 10 characters");
  }

  if (!data.imageUrls || !Array.isArray(data.imageUrls) || data.imageUrls.length === 0) {
    errors.push("At least one image is required");
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
};

/**
 * Validate event data
 */
exports.validateEventData = (data) => {
  const errors = [];

  if (!data.name || data.name.trim().length < 3) {
    errors.push("Event name must be at least 3 characters");
  }

  if (!data.eventType) {
    errors.push("Event type is required");
  }

  if (!data.bookingPrice || data.bookingPrice < 0) {
    errors.push("Booking price must be a positive number");
  }

  if (!data.eventDate) {
    errors.push("Event date is required");
  } else if (!exports.isFutureDate(data.eventDate)) {
    errors.push("Event date must be in the future");
  }

  if (!data.location) {
    errors.push("Location is required");
  }

  if (!data.description || data.description.trim().length < 10) {
    errors.push("Description must be at least 10 characters");
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
};

/**
 * Validate order data
 */
exports.validateOrderData = (data) => {
  const errors = [];

  if (!data.items || !Array.isArray(data.items) || data.items.length === 0) {
    errors.push("Order must contain at least one item");
  }

  if (!data.shippingAddress) {
    errors.push("Shipping address is required");
  }

  if (!data.paymentMethod) {
    errors.push("Payment method is required");
  }

  return {
    isValid: errors.length === 0,
    errors,
  };
};