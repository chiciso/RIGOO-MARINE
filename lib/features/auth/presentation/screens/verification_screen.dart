import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

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
    // Check every 3 seconds
    _checkTimer = Timer.periodic(const Duration(seconds: 3), (timer) async {
      await _checkEmailVerified();
    });
  }

  /// THE FORCE SYNC LOGIC
  Future<void> _checkEmailVerified() async {
    // Prevent multiple simultaneous checks
    if (_isCheckingVerification || _isVerified || !mounted) {
      return;
    }

    setState(() => _isCheckingVerification = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return;
      }

      // 1. Force the local app to sync with the Firebase Server
      // This updates the 'emailVerified' boolean in the background

      // 2. Force an ID token refresh to be 100% sure
      await user.getIdToken(true); 

      // 3. CRITICAL: Get a fresh reference to the user object 
      // The old 'user' variable still has 'emailVerified = false' in its memory
      final freshUser = FirebaseAuth.instance.currentUser;

      debugPrint('DEBUG: Verification Status: ${freshUser?.emailVerified}');

      if (freshUser != null && freshUser.emailVerified) {
        _checkTimer?.cancel();
        setState(() => _isVerified = true);

        if (mounted) {
          // Give the user a half-second to see the "Success" UI
          await Future.delayed(const Duration(milliseconds: 500));
          
          if (mounted) {
            context.go(AppConstants.welcomeRoute);
          }
        }
      }
    }on Exception catch (e) {
      debugPrint('Error during verification check: $e');
    } finally {
      if (mounted) {
        setState(() => _isCheckingVerification = false);
      }
    }
  }

  Future<void> _sendVerificationEmail() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    }on Exception catch (e) {
      if (!mounted) {
        return;
      }
      _showSnackBar(
        'Error sending email: ${e.toString()}', AppTheme.errorColor);
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
      _showSnackBar('Verification email resent!', AppTheme.successColor);
    } on Exception catch (e) {
      if (!mounted) {
        return;
      }
      _showSnackBar('Error: $e', AppTheme.errorColor);
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
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
              _buildHeader(),
              const SizedBox(height: 32),
              _buildStatusSection(),
              const Spacer(),
              _buildActions(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );

  Widget _buildHeader() => Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            gradient: AppTheme.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Icon(
            Icons.email_outlined,
             size: 48,
              color: Colors.white),
        ),
        const SizedBox(height: 32),
        Text('Verify Your Email',
         style: Theme.of(context).textTheme.displaySmall,
          textAlign: TextAlign.center),
        const SizedBox(height: 8),
        const Text('Checking for verification for:',
         style: TextStyle(color: AppTheme.textSecondary)),
        Text(widget.email,
         style: const TextStyle(fontWeight: FontWeight.bold,
          color: AppTheme.primaryColor)),
      ],
    );

  Widget _buildStatusSection() {
    if (_isVerified) {
      return _statusBox(
        Icons.check_circle,
       AppTheme.successColor,
        'Email Verified! Redirecting...');
    }
    if (_isCheckingVerification) {
      return _statusBox(null,
       AppTheme.primaryColor,
        'Checking Firebase server...', isLoading: true);
    }
    return const SizedBox.shrink();
  }

  Widget _statusBox(
    IconData? icon,
     Color color,
      String text,
       {bool isLoading = false}) => Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (isLoading) const SizedBox(
            width: 20,
             height: 20,
              child: CircularProgressIndicator(strokeWidth: 2))
          else Icon(icon, color: color),
          const SizedBox(width: 12),
          Text(text,
           style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold)),
        ],
      ),
    );

  Widget _buildActions() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: _isVerified ? null : _checkEmailVerified,
            child: const Text("I've Already Verified"),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _resendCountdown > 0 || _isVerified ? null :
           _resendVerificationEmail,
          child: Text(_resendCountdown > 0 ? 'Resend in ${_resendCountdown}s' :
           'Resend Email'),
        ),
      ],
    );
}