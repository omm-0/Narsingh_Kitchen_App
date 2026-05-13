import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class SavedScreen extends StatelessWidget {
  final bool embeddedInNav;
  const SavedScreen({super.key, this.embeddedInNav = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: embeddedInNav 
        ? null 
        : AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Saved Items',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (embeddedInNav)
                Text(
                  'Saved Items',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
              const Spacer(),
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: AppColors.primaryRed.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.favorite_rounded,
                        size: 64,
                        color: AppColors.primaryRed,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Your heart is empty!',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Save your favorite dishes to find them\neasily whenever you are hungry.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        // Maybe switch to home tab or pop
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        'Explore Menu',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
