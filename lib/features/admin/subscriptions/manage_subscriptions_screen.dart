import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/admin_service.dart';

class ManageSubscriptionsScreen extends StatelessWidget {
  const ManageSubscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: AdminService.instance.getSubscriptionsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final subs = snapshot.data ?? [];
          final activeCount = subs.where((s) => s['isActive'] == true).length;

          return Column(
            children: [
              _header(context, activeCount),
              Expanded(
                child: subs.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemCount: subs.length,
                        itemBuilder: (_, i) => _SubCard(sub: subs[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.subscriptions_outlined, size: 64, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No subscriptions found',
            style: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context, int activeCount) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Text('Subscriptions',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface)),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$activeCount active',
              style: GoogleFonts.poppins(color: AppColors.whiteSurface, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubCard extends StatelessWidget {
  final Map<String, dynamic> sub;

  const _SubCard({required this.sub});

  @override
  Widget build(BuildContext context) {
    final customerName = sub['userName'] ?? 'Unknown Customer';
    final plan = sub['planTitle'] ?? 'Standard Plan';
    final isActive = sub['isActive'] ?? false;
    final startDate = sub['startDate'] ?? 'N/A';
    final endDate = sub['endDate'] ?? 'N/A';
    final id = sub['id'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(customerName,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
              _statusBadge(isActive),
            ],
          ),
          const SizedBox(height: 8),
          _row(Icons.card_membership_rounded, 'Plan: $plan', Colors.blue),
          _row(Icons.calendar_today_rounded, 'Start: $startDate', AppColors.textSecondary),
          _row(Icons.event_rounded, 'End: $endDate', AppColors.textSecondary),
          if (isActive) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: () => AdminService.instance.cancelSubscription(id),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primaryRed,
                  side: const BorderSide(color: AppColors.primaryRed),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text('Cancel Subscription',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _row(IconData icon, String text, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Icon(icon, size: 15, color: color),
          const SizedBox(width: 6),
          Text(text,
              style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _statusBadge(bool active) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFE8F5E9) : const Color(0xFFFFEBEE),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? 'Active' : 'Cancelled',
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active ? AppColors.successGreen : AppColors.primaryRed,
        ),
      ),
    );
  }
}
