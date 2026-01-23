import 'package:flutter_riverpod/legacy.dart';

import '../../domain/entities/user.dart';

// Auth State
class AuthState {

  const AuthState({
    this.user,
    this.isLoading = false,
    this.error,
    this.isAuthenticated = false,
    this.hasSeenOnboarding = false,
  });
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isAuthenticated;
  final bool hasSeenOnboarding;

  AuthState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    bool? isAuthenticated,
    bool? hasSeenOnboarding,
  }) => AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      hasSeenOnboarding: hasSeenOnboarding ?? this.hasSeenOnboarding,
    );
}

// Auth Notifier
class AuthNotifier extends StateNotifier<AuthState> {
  AuthNotifier() : super(const AuthState());

  Future<void> signIn(String email, String password) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user
      final user = User(
        id: '1',
        email: email,
        fullName: 'John Doe',
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phoneNumber,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock user (not verified yet)
      final user = User(
        id: '1',
        email: email,
        fullName: fullName,
        phoneNumber: phoneNumber,
        emailVerified: false,
      );

      state = state.copyWith(
        user: user,
        isAuthenticated: false,
        isLoading: false,
      );
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> verifyEmail(String code) async {
    state = state.copyWith(isLoading: true);

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      if (state.user != null) {
        final updatedUser = User(
          id: state.user!.id,
          email: state.user!.email,
          fullName: state.user!.fullName,
          phoneNumber: state.user!.phoneNumber,
        );

        state = state.copyWith(
          user: updatedUser,
          isAuthenticated: true,
          isLoading: false,
        );
      }
    } on Exception catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void completeOnboarding() {
    state = state.copyWith(hasSeenOnboarding: true);
  }

  Future<void> signOut() async {
    state = const AuthState();
  }

  void clearError() {
    state = state.copyWith();
  }
}

// Provider
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) =>
 AuthNotifier()
 );