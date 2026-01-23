import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LoadingIndicator extends StatelessWidget {

  const LoadingIndicator({
    super.key,
    this.message,
  });
  final String? message;

  @override
  Widget build(BuildContext context) => Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
}

class LoadingOverlay extends StatelessWidget {

  const LoadingOverlay({
    required this.child,
    required this.isLoading,
    super.key,
    this.message,
  });
  final Widget child;
  final bool isLoading;
  final String? message;

  @override
  Widget build(BuildContext context) => Stack(
      children: [
        child,
        if (isLoading)
          Container(
            color: Colors.black54,
            child: LoadingIndicator(message: message),
          ),
      ],
    );
}