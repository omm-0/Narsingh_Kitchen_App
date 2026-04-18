import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import 'onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentIndex = 0;

  static final List<_OnboardingItem> _pages = [
    _OnboardingItem(
      color: AppColors.primaryRed,
      emoji: '🍔',
      title: 'Fast Food Delivery',
      description:
          'Order your favourite burgers, pizza, sandwiches & more – delivered hot in under 30 minutes!',
      buttonText: 'Next →',
    ),
    _OnboardingItem(
      color: AppColors.primaryOrange,
      emoji: '🍱',
      title: 'Tiffin Services',
      description:
          'Subscribe to daily home-cooked tiffin meals. Choose one-time or monthly subscription plans!',
      buttonText: 'Next →',
    ),
    _OnboardingItem(
      color: AppColors.primaryBrown,
      emoji: '🌶️',
      title: 'Premium Spices',
      description:
          'Shop from a wide range of pure aromatic spices sourced directly from farms across India.',
      buttonText: 'Get Started',
    ),
  ];

  void _goNext(int index) {
    final last = index >= _pages.length - 1;
    if (last) {
      Navigator.pushReplacementNamed(context, AppRoutes.signIn);
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _skip() {
    Navigator.pushReplacementNamed(context, AppRoutes.signIn);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                physics: const BouncingScrollPhysics(),
                itemCount: _pages.length,
                onPageChanged: (i) => setState(() => _currentIndex = i),
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return OnboardingPage(
                    color: page.color,
                    emoji: page.emoji,
                    title: page.title,
                    description: page.description,
                    buttonText: page.buttonText,
                    currentIndex: _currentIndex,
                    totalPages: _pages.length,
                    onNext: () => _goNext(index),
                    onSkip: _skip,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.color,
    required this.emoji,
    required this.title,
    required this.description,
    required this.buttonText,
  });

  final Color color;
  final String emoji;
  final String title;
  final String description;
  final String buttonText;
}
