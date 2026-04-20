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

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(milliseconds: 2500), _navigate);
  }

  Future<void> _navigate() async {
    if (!mounted) return;
    final role = await AuthService.instance.getUserRole();
    if (!mounted) return;
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, AppRoutes.adminBottomNav);
    } else if (role == 'customer') {
      Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryRed,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            bottom: -100,
            left: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteSurface.withValues(alpha: 0.08),
              ),
            ),
          ),
          Positioned(
            top: -80,
            right: -80,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.whiteSurface.withValues(alpha: 0.06),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: AppColors.whiteSurface,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Text('🍽️', style: TextStyle(fontSize: 64)),
                ),
                const SizedBox(height: 24),
                Text(
                  AppStrings.appDisplayName,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 32,
                    color: AppColors.whiteSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  AppStrings.tagline,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    color: AppColors.whiteSurface.withValues(alpha: 0.7),
                  ),
                ),
                const Spacer(),
                Text(
                  AppStrings.footerSplash,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: AppColors.whiteSurface,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.whiteSurface,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface.withValues(alpha: 0.4),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
