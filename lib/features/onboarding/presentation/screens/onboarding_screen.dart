import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingPageData> _pages = const [
    OnboardingPageData(
      title: 'Find Qualified\nMechanics',
      subtitle: 'To your desire',
      imagePath: 'assets/images/onboarding_1.png', // Will use icon for now
      icon: Icons.sailing,
    ),
    OnboardingPageData(
      title: 'Review and Rate\nServices',
      subtitle: 'To your desire',
      imagePath: 'assets/images/onboarding_2.png',
      icon: Icons.star_rate,
    ),
    OnboardingPageData(
      title: 'Explore and Purchase\nBoat Parts',
      subtitle: 'To your desire',
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

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.go(AppConstants.signInRoute);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: _onPageChanged,
                itemCount: _pages.length,
                itemBuilder: (context, index) => OnboardingPage(
                  data: _pages[index]
                  ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                  FloatingActionButton(
                    onPressed: _nextPage,
                    backgroundColor: AppTheme.primaryColor,
                    child: const Icon(
                      Icons.arrow_forward,
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