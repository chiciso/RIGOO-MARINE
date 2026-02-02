import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

/// Verification screen with real Firebase email verification
class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({
    required this.email,
    super.key,
  });

  final String email;

  @override
  ConsumerState<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends ConsumerState<VerificationScreen> {
  Timer? _resendTimer;
  Timer? _checkTimer;
  int _resendCountdown = AppConstants.resendCodeTimeout;
  bool _isVerified = false;
  bool _isCheckingVerification = false;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _sendVerificationEmail();
    _startCheckingVerification();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _checkTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  void _startCheckingVerification() {
    // Check every 3 seconds if email is verified
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      if (!mounted) {
        timer.cancel();
        return;
      }

      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    if (_isCheckingVerification || _isVerified) {
      return;
    }

    setState(() => _isCheckingVerification = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      // Reload user to get latest email verification status
      await user.reload();
      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser?.emailVerified ?? false) {
        setState(() => _isVerified = true);
        _checkTimer?.cancel();

        if (!mounted) {
          return;
        }

        // Navigate to welcome screen
        context.go(AppConstants.welcomeRoute);
      }
    } on Exception catch (e) {
      debugPrint('Error checking verification: $e');
    } finally {
      if (mounted) {
        setState(() => _isCheckingVerification = false);
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      if (!user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error sending verification email: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCountdown > 0) {
      return;
    }

    try {
      await _sendVerificationEmail();

      if (!mounted) {
        return;
      }

      setState(() => _resendCountdown = AppConstants.resendCodeTimeout);
      _startResendTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent! Please check your inbox.'),
          backgroundColor: AppTheme.successColor,
        ),
      );
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: AppTheme.errorColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),

                // Logo
                Center(
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.email_outlined,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Title
                Text(
                  'Verify Your Email',
                  style: Theme.of(context).textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Subtitle
                Text(
                  'We sent a verification email to:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  widget.email,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32),

                // Instructions
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: AppTheme.primaryColor.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppTheme.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Next Steps:',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '1. Check your email inbox\n'
                        '2. Click the verification link\n'
                        '3. Return to this app',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.textPrimary,
                              height: 1.5,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Verification status
                if (_isVerified)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.check_circle,
                          color: AppTheme.successColor,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Email verified! Redirecting...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge
                                ?.copyWith(
                                  color: AppTheme.successColor,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      ],
                    ),
                  )
                else if (_isCheckingVerification)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Checking verification status...',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppTheme.textSecondary,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // Check manually button
                SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _isVerified ? null : _checkEmailVerified,
                    child: const Text("I've Verified My Email"),
                  ),
                ),
                const SizedBox(height: 16),

                // Resend email
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Didn't receive the email? ",
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Flexible(
                      child: TextButton(
                        onPressed: _resendCountdown > 0 || _isVerified
                            ? null
                            : _resendVerificationEmail,
                        child: Text(
                          _resendCountdown > 0
                              ? 'Resend in ${_resendCountdown}s'
                              : 'Resend Email',
                          style: TextStyle(
                            color: _resendCountdown > 0 || _isVerified
                                ? AppTheme.textSecondary
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Skip for now (optional - for testing)
                if (!_isVerified)
                  TextButton(
                    onPressed: () {
                      context.go(AppConstants.welcomeRoute);
                    },
                    child: Text(
                      'Skip for now',
                      style: TextStyle(
                        color: AppTheme.textSecondary.withValues(alpha: 0.7),
                        fontSize: 12,
                      ),
                    ),
                  ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      );
}