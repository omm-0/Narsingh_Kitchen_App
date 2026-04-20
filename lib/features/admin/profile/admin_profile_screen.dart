import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/auth_service.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  Future<void> _logout(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to logout?',
            style: GoogleFonts.poppins(color: AppColors.textSecondary)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.whiteSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await AuthService.instance.logout();
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (_) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildSettingsSection(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 20,
        left: 20,
        right: 20,
        bottom: 32,
      ),
      child: Column(
        children: [
          Container(
            width: 86,
            height: 86,
            decoration: BoxDecoration(
              color: AppColors.whiteSurface,
              shape: BoxShape.circle,
              boxShadow: AppColors.cardShadow,
            ),
            alignment: Alignment.center,
            child: const Text('👨‍💼', style: TextStyle(fontSize: 44)),
          ),
          const SizedBox(height: 12),
          Text('Admin',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Super Admin',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.whiteSurface, fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _section('Account', [
            _tile(context, Icons.edit_rounded, 'Edit Profile', Colors.blue, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Edit Profile — coming soon', style: GoogleFonts.poppins()),
                  duration: const Duration(seconds: 1),
                ),
              );
            }),
            _tile(context, Icons.lock_outline_rounded, 'Change Password', Colors.orange, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Change Password — coming soon', style: GoogleFonts.poppins()),
                  duration: const Duration(seconds: 1),
                ),
              );
            }),
          ]),
          const SizedBox(height: 12),
          _section('Admin Tools', [
            _tile(context, Icons.people_rounded, 'Manage Customers', AppColors.primaryOrange,
                () => Navigator.pushNamed(context, AppRoutes.manageCustomers)),
            _tile(context, Icons.subscriptions_rounded, 'Subscriptions', Colors.blue,
                () => Navigator.pushNamed(context, AppRoutes.manageSubscriptions)),
            _tile(context, Icons.local_offer_rounded, 'Promo Codes', AppColors.successGreen,
                () => Navigator.pushNamed(context, AppRoutes.managePromos)),
            _tile(context, Icons.notifications_rounded, 'Notifications', Colors.purple,
                () => Navigator.pushNamed(context, AppRoutes.manageNotifications)),
          ]),
          const SizedBox(height: 12),
          _section('App', [
            _tile(context, Icons.settings_rounded, 'App Settings', Colors.grey, () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('App Settings — coming soon', style: GoogleFonts.poppins()),
                  duration: const Duration(seconds: 1),
                ),
              );
            }),
            _tile(context, Icons.logout_rounded, 'Logout', AppColors.primaryRed,
                () => _logout(context),
                trailing: const SizedBox.shrink()),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
            child: Text(title,
                style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                    letterSpacing: 0.5)),
          ),
          ...items,
        ],
      ),
    );
  }

  Widget _tile(
    BuildContext context,
    IconData icon,
    String label,
    Color color,
    VoidCallback onTap, {
    Widget? trailing,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(label,
                  style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: label == 'Logout' ? AppColors.primaryRed : AppColors.textPrimary)),
            ),
            trailing ??
                Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}
