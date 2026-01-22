class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'RIGOO MARINE';
  static const String appTagline = 'Your n°1 Boating Companion';

  // Categories
  static const List<String> boatCategories = [
    'Boats',
    'Yachts',
    'Jetskis',
  ];

  static const List<String> listingFilters = [
    'All',
    'For Sale',
    'For Rent',
    'For Charter',
  ];

  static const List<String> partCategories = [
    'Engine',
    'Cooling',
    'Fuel',
    'Propulsion',
  ];

  static const List<String> conditionOptions = [
    'New',
    'Used - Perfect',
    'Used - Good',
  ];

  static const List<String> engineTypes = [
    'Outboard Engine',
    'Inboard Engine',
    'Sterndrive',
    'Jet Drive/Jet Propulsion',
  ];

  static const List<String> eventTypes = [
    'Party',
    'Birthday',
    'Gala',
  ];

  static const List<String> departureLocations = [
    'Lousail',
    'Pearl',
    'Box park',
  ];

  static const List<String> itemTypes = [
    'Boat',
    'Yacht',
    'Jet Ski',
  ];

  // Validation
  static const int minPasswordLength = 8;
  static const int verificationCodeLength = 6;
  static const int resendCodeTimeout = 30; // seconds

  // Pagination
  static const int itemsPerPage = 20;

  // Image
  static const int maxImagesPerListing = 3;
  static const double maxImageSizeMB = 5;

  // Routes (will be used by go_router)
  static const String splashRoute = '/';
  static const String onboardingRoute = '/onboarding';
  static const String signInRoute = '/sign-in';
  static const String signUpRoute = '/sign-up';
  static const String verificationRoute = '/verification';
  static const String welcomeRoute = '/welcome';
  static const String mainRoute = '/main';
  static const String marketplaceRoute = '/main/marketplace';
  static const String sellRoute = '/main/sell';
  static const String ordersRoute = '/main/orders';
  static const String profileRoute = '/main/profile';
  static const String eventsRoute = '/main/events';
  static const String itemDetailsRoute = '/item-details';
  static const String eventDetailsRoute = '/event-details';
  static const String createListingRoute = '/create-listing';
  static const String createEventRoute = '/create-event';
  static const String partsRoute = '/parts';
  static const String servicesRoute = '/services';

  // Error Messages
  static const String genericError = 'Something went wrong. Please try again.';
  static const String networkError =
   'No internet connection. Please check your network.';
  static const String invalidEmail = 'Please enter a valid email address.';
  static const String invalidPassword = 
  'Password must be at least $minPasswordLength characters.';
  static const String passwordMismatch = 'Passwords do not match.';
  static const String requiredField = 'This field is required.';
  
  // Success Messages
  static const String listingCreated = 'Listing created successfully!';
  static const String eventCreated = 'Event created successfully!';
  static const String profileUpdated = 'Profile updated successfully!';
  static const String addedToWishlist = 'Added to wishlist!';
  static const String removedFromWishlist = 'Removed from wishlist!';
}