import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/screens/sign_in_screen.dart';
import '../../features/auth/presentation/screens/sign_up_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/verification_screen.dart';
import '../../features/auth/presentation/screens/welcome_screen.dart';
import '../../features/events/presentation/screens/event_details_screen.dart';
import '../../features/main/presentation/screens/main_screen.dart';
import '../../features/marketplace/presentation/screens/item_details_screen.dart';
import '../../features/onboarding/presentation/screens/onboarding_screen.dart';
import '../../features/parts/presentation/screens/parts_screen.dart';
import '../../features/sell/presentation/screens/create_event_screen.dart';
import '../../features/sell/presentation/screens/create_listing_screen.dart';
import '../../features/services/presentation/screens/services_screen.dart';
import '../constants/app_constants.dart';

final goRouterProvider = Provider<GoRouter>((ref) => GoRouter(
    initialLocation: AppConstants.splashRoute,
    routes: [
      GoRoute(
        path: AppConstants.splashRoute,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.onboardingRoute,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.signInRoute,
        name: 'sign-in',
        builder: (context, state) => const SignInScreen(),
      ),
      GoRoute(
        path: AppConstants.signUpRoute,
        name: 'sign-up',
        builder: (context, state) => const SignUpScreen(),
      ),
      GoRoute(
        path: AppConstants.verificationRoute,
        name: 'verification',
        builder: (context, state) {
          final email = state.extra as String?;
          return VerificationScreen(email: email ?? '');
        },
      ),
      GoRoute(
        path: AppConstants.welcomeRoute,
        name: 'welcome',
        builder: (context, state) => const WelcomeScreen(),
      ),
      GoRoute(
        path: AppConstants.mainRoute,
        name: 'main',
        builder: (context, state) {
          final initialIndex = state.extra as int? ?? 0;
          return MainScreen(initialIndex: initialIndex);
        },
      ),
      GoRoute(
        path: AppConstants.itemDetailsRoute,
        name: 'item-details',
        builder: (context, state) {
          final itemId = state.extra! as String;
          return ItemDetailsScreen(itemId: itemId);
        },
      ),
      GoRoute(
        path: AppConstants.eventDetailsRoute,
        name: 'event-details',
        builder: (context, state) {
          final eventId = state.extra! as String;
          return EventDetailsScreen(eventId: eventId);
        },
      ),
      GoRoute(
        path: AppConstants.createListingRoute,
        name: 'create-listing',
        builder: (context, state) => const CreateListingScreen(),
      ),
      GoRoute(
        path: AppConstants.createEventRoute,
        name: 'create-event',
        builder: (context, state) => const CreateEventScreen(),
      ),
      GoRoute(
        path: AppConstants.partsRoute,
        name: 'parts',
        builder: (context, state) => const PartsScreen(),
      ),
      GoRoute(
        path: AppConstants.servicesRoute,
        name: 'services',
        builder: (context, state) => const ServicesScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.uri.path}'),
      ),
    ),
  ));