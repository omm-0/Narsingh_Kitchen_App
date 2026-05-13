import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';

class PaymentMethodsScreen extends StatelessWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Payment Methods',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 24, color: AppColors.textPrimary),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionHeader('Saved Cards'),
            const SizedBox(height: 16),
            _buildEmptyCard(context, 'No cards saved yet'),
            const SizedBox(height: 32),
            _sectionHeader('UPI & Wallets'),
            const SizedBox(height: 16),
            _buildEmptyCard(context, 'No UPI IDs linked'),
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: Text('Add New Payment Method', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(fontWeight: FontWeight.w700, fontSize: 18, color: AppColors.textPrimary),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          Icon(Icons.payment_rounded, size: 48, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            message,
            style: GoogleFonts.outfit(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}
