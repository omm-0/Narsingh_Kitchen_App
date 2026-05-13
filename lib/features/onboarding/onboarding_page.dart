import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../core/constants/app_colors.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.color,
    required this.emoji,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onSkip,
  });

  final Color color;
  final String emoji;
  final String title;
  final String description;
  final String buttonText;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.55;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: height,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(40),
                    ),
                  ),
                  child: Stack(
                    children: [
                      // Concentric rings around the emoji
                      Center(
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 280,
                              height: 280,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            Container(
                              width: 220,
                              height: 220,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.15),
                              ),
                            ),
                            Container(
                              width: 160,
                              height: 160,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                            ),
                            Container(
                              width: 110,
                              height: 110,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: onSkip,
                                child: Text(
                                  'Skip',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15,
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      Center(
                        child: Hero(
                          tag: 'onboarding_$currentIndex',
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 64),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      children: [
                        const SizedBox(height: 40),
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w800,
                            fontSize: 30,
                            color: AppColors.textPrimary,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          description,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedSmoothIndicator(
                              activeIndex: currentIndex,
                              count: totalPages,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: color,
                                dotColor: AppColors.dividerGray,
                                expansionFactor: 4,
                                spacing: 6,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: color,
                              foregroundColor: AppColors.whiteSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 0,
                            ),
                            onPressed: onNext,
                            child: Text(
                              buttonText,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
