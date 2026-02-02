import 'package:flutter/material.dart';

/// Data class for onboarding pages
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.subtitle,
    required this.imagePath,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final String imagePath;
  final IconData icon;
}