import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../domain/onboarding_page_data.dart';
import '../widgets/onboarding_page.dart';

/// Onboarding screen with completion tracking
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Find Qualified\nMechanics',
      subtitle: 'Connect with expert boat mechanics in your area',
      imagePath: 'assets/images/onboarding_1.png',
      icon: Icons.engineering,
    ),
    OnboardingPageData(
      title: 'Review and Rate\nServices',
      subtitle: 'Share your experience and help others find the best',
      imagePath: 'assets/images/onboarding_2.png',
      icon: Icons.star_rate,
    ),
    OnboardingPageData(
      title: 'Explore and Purchase\nBoat Parts',
      subtitle: 'Find quality parts and equipment for your vessel',
      imagePath: 'assets/images/onboarding_3.png',
      icon: Icons.shopping_bag,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  Future<void> _completeOnboarding() async {
    try {
      // Mark onboarding as completed
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);

      if (!mounted) {
        return;
      }

      // Navigate to sign in
      context.go(AppConstants.signInRoute);
    } on Exception catch (e) {
      debugPrint('Error completing onboarding: $e');
      if (!mounted) {
        return;
      }
      context.go(AppConstants.signInRoute);
    }
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _skipOnboarding() {
    _completeOnboarding();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              // Skip button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _skipOnboarding,
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                    ),
                  ),
                ),
              ),

              // Pages
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: _onPageChanged,
                  itemCount: _pages.length,
                  itemBuilder: (context, index) => OnboardingPage(
                    data: _pages[index],
                  ),
                ),
              ),

              // Bottom controls
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page indicator
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _pages.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppTheme.primaryColor,
                        dotColor: Color(0xFFE0E0E0),
                        dotHeight: 8,
                        dotWidth: 8,
                      ),
                    ),

                    // Next/Get Started button
                    FloatingActionButton(
                      onPressed: _nextPage,
                      backgroundColor: AppTheme.primaryColor,
                      child: Icon(
                        _currentPage == _pages.length - 1
                            ? Icons.check
                            : Icons.arrow_forward,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}