import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/subscription_service.dart';

class SubscriptionsScreen extends StatelessWidget {
  const SubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Please sign in to view subscriptions')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.textPrimary,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Subscriptions',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 24,
            color: AppColors.textPrimary,
          ),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: SubscriptionService.instance.getMySubscriptions(),
        builder: (context, snapshot) {
          final subscriptions = snapshot.data ?? [];
          if (subscriptions.isEmpty &&
              snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (snapshot.hasError) ...[
                  _buildInfoBox(
                    'Live subscription history is unavailable right now. Please retry after backend sync.',
                  ),
                  const SizedBox(height: 18),
                ],
                if (subscriptions.isEmpty)
                  _buildEmptyState()
                else
                  ...subscriptions.map(
                    (sub) => Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: _subscriptionCard(sub),
                    ),
                  ),
                const SizedBox(height: 16),
                _buildInfoBox(
                  'Subscriptions are synced from backend and reflect active tiffin plans created by the customer.',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        children: [
          const Text('🍱', style: TextStyle(fontSize: 44)),
          const SizedBox(height: 16),
          Text(
            'No subscriptions yet',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose a tiffin plan to start a recurring meal schedule.',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  Widget _subscriptionCard(Map<String, dynamic> sub) {
    final title = sub['planTitle'] ?? 'Tiffin Plan';
    final subtitle = sub['mealsLabel'] ?? 'Meal schedule';
    final isActive = sub['isActive'] == true;
    final expiry = isActive
        ? 'Valid until ${sub['endDate'] ?? 'N/A'}'
        : 'Ended on ${sub['endDate'] ?? 'N/A'}';

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              alignment: Alignment.center,
              child: const Text('🍱', style: TextStyle(fontSize: 28)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expiry,
                    style: GoogleFonts.outfit(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color:
                    (isActive
                            ? AppColors.successGreen
                            : AppColors.textSecondary)
                        .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                isActive ? 'Active' : 'Inactive',
                style: GoogleFonts.outfit(
                  color: isActive
                      ? AppColors.successGreen
                      : AppColors.textSecondary,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryRed.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryRed.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, color: AppColors.primaryRed),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.outfit(
                color: AppColors.primaryRed,
                fontWeight: FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
