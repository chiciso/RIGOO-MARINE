import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';

// Simple provider to track if email was sent (prevents spam on re-init)
final justSentVerificationProvider = StateProvider<bool>((ref) => false);

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
  static const int _maxVerificationChecks = 40; // ~2 minutes at 3s intervals
  static const Duration _pollInterval = Duration(seconds: 3);
  static const Duration _successDelay = Duration(milliseconds: 800);

  Timer? _resendTimer;
  Timer? _checkTimer;
  int _resendCountdown = AppConstants.resendCodeTimeout;
  int _verificationChecks = 0;
  bool _isVerified = false;
  bool _isCheckingVerification = false;
  bool _verificationTimedOut = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
    _startCheckingVerification();

    // Send email only if not already sent in this flow
    final justSent = ref.read(justSentVerificationProvider);
    if (!justSent) {
      _sendVerificationEmail();
      ref.read(justSentVerificationProvider.notifier).state = true;
    }
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
    _checkTimer = Timer.periodic(_pollInterval, (timer) async {
      if (_verificationChecks >= _maxVerificationChecks) {
        timer.cancel();
        if (mounted) {
          setState(() {
            _verificationTimedOut = true;
            _errorMessage =
      'Verification check timed out. Try resending or check your inbox again.';
          });
        }
        return;
      }
      _verificationChecks++;
      await _checkEmailVerified();
    });
  }

  Future<void> _checkEmailVerified() async {
    if (_isCheckingVerification || _isVerified || !mounted ||
     _verificationTimedOut) {
      return;
    }

    setState(() => _isCheckingVerification = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await user.reload();
      await user.getIdToken(true);

      final freshUser = FirebaseAuth.instance.currentUser;
      if (freshUser == null) {
        throw Exception('User reference lost after reload');
      }

      if (kDebugMode) {
        debugPrint('DEBUG: Verification Status: ${freshUser.emailVerified}');
      }

      if (freshUser.emailVerified) {
        _checkTimer?.cancel();
        setState(() => _isVerified = true);

        await Future.delayed(_successDelay);
        if (mounted) {
          context.go(AppConstants.welcomeRoute);
        }
      }
    }on Exception catch (e) {
      if (kDebugMode) {
        debugPrint('Error during verification check: $e');
      }
      if (mounted) {
        setState(() {
          _errorMessage = 'Verification check failed: ${e.toString().
          split('.').first}. Please try again.';
        });
      }
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
      if (mounted) {
        _showSnackBar('Error sending email: ${e.toString().
        split('.').first}', AppTheme.errorColor);
      }
    }
  }

  Future<void> _resendVerificationEmail() async {
    if (_resendCountdown > 0 || _isCheckingVerification) {
      return;
    }
    try {
      await _sendVerificationEmail();
      if (mounted) {
        setState(() => _resendCountdown = AppConstants.resendCodeTimeout);
        _startResendTimer();
        _showSnackBar('Verification email resent!', AppTheme.successColor);
      }
    }on Exception catch (e) {
      if (mounted) {
        _showSnackBar('Error resending: ${e.toString().split('.').first}',
         AppTheme.errorColor);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    if (!mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: color),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
       // Use theme for dark mode
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
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppTheme.errorColor),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 16),
              const Text(
                // ignore: lines_longer_than_80_chars
                'Tips: Check spam folder, add our email to contacts, or try a different browser for the link.',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                textAlign: TextAlign.center,
              ),
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
    if (_verificationTimedOut) {
      return _statusBox(
        Icons.timer_off,
        AppTheme.errorColor,
        'Verification check timed out');
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
          else if (icon != null) Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text,
             style: TextStyle(
              color: color,
              fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );

  Widget _buildActions() => Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: (_isCheckingVerification || _isVerified ||
             _verificationTimedOut) ? null : _checkEmailVerified,
            child: const Text("I've Already Verified"),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: (_resendCountdown > 0 || _isVerified ||
           _isCheckingVerification ||
            _verificationTimedOut) ? null : _resendVerificationEmail,
          child: Text(_resendCountdown > 0 ? 'Resend in ${
            _resendCountdown}s' : 'Resend Email'),
        ),
      ],
    );
}