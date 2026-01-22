import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../screens/onboarding_screen.dart';

class OnboardingPage extends StatelessWidget {

  const OnboardingPage({
    required this.data, super.key,
  });
  final OnboardingPageData data;

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Illustration placeholder
          Container(
            width: 280,
            height: 280,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha:0.1),
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(
              data.icon,
              size: 120,
              color: AppTheme.primaryColor,
            ),
          ),
          const SizedBox(height: 48),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.textSecondary,
            ),
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
}