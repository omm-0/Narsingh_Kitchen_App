import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/admin_dummy_data.dart';

class ManageSubscriptionsScreen extends StatefulWidget {
  const ManageSubscriptionsScreen({super.key});

  @override
  State<ManageSubscriptionsScreen> createState() => _ManageSubscriptionsScreenState();
}

class _ManageSubscriptionsScreenState extends State<ManageSubscriptionsScreen> {
  final _subs = AdminDummyData.subscriptions;

  void _cancel(AdminSubscription s) {
    setState(() => s.isActive = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Subscription for ${s.customerName} cancelled', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: _subs.length,
              itemBuilder: (_, i) => _SubCard(sub: _subs[i], onCancel: () => _cancel(_subs[i])),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
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
              '${_subs.where((s) => s.isActive).length} active',
              style: GoogleFonts.poppins(color: AppColors.whiteSurface, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _SubCard extends StatelessWidget {
  final AdminSubscription sub;
  final VoidCallback onCancel;

  const _SubCard({required this.sub, required this.onCancel});

  @override
  Widget build(BuildContext context) {
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
              Text(sub.customerName,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
              _statusBadge(sub.isActive),
            ],
          ),
          const SizedBox(height: 8),
          _row(Icons.card_membership_rounded, 'Plan: ${sub.plan}', Colors.blue),
          _row(Icons.calendar_today_rounded, 'Start: ${sub.startDate}', AppColors.textSecondary),
          _row(Icons.event_rounded, 'End: ${sub.endDate}', AppColors.textSecondary),
          if (sub.isActive) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 40,
              child: OutlinedButton(
                onPressed: onCancel,
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
