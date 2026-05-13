import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/auth_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
    _timer = Timer(const Duration(milliseconds: 3000), _navigate);
  }

  Future<void> _navigate() async {
    debugPrint('SplashScreen: Starting navigation logic...');
    if (!mounted) return;
    try {
      final role = await AuthService.instance.getUserRole();
      debugPrint('SplashScreen: User role fetched: $role');
      if (!mounted) return;
      
      if (role == 'admin') {
        debugPrint('SplashScreen: Navigating to Admin Dashboard');
        Navigator.pushReplacementNamed(context, AppRoutes.adminBottomNav);
      } else if (role == 'customer') {
        debugPrint('SplashScreen: Navigating to Customer Home');
        Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
      } else {
        debugPrint('SplashScreen: No role found, navigating to Onboarding');
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    } catch (e) {
      debugPrint('SplashScreen: Error during navigation: $e');
      if (mounted) {
        Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.primaryRed,
              Color(0xFFB71C1C),
            ],
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Decorative background circles
            Positioned(
              top: -100,
              right: -100,
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.05),
                ),
              ),
            ),
            Positioned(
              bottom: -50,
              left: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
            ),
            
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: ScaleTransition(
                    scale: _scaleAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 120,
                        height: 120,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        AppStrings.appDisplayName,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 36,
                          color: Colors.white,
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.tagline,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: Colors.white.withValues(alpha: 0.8),
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            Positioned(
              bottom: 40,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    Text(
                      AppStrings.footerSplash,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
