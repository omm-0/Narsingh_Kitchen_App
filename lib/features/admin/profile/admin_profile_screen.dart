import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/auth_service.dart';

class AdminProfileScreen extends StatelessWidget {
  const AdminProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : StreamBuilder<Map<String, dynamic>?>(
              stream: AuthService.instance.getUserDetailsStream(user.uid),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final name = userData?['name'] ?? 'Admin';
                final email = user.email ?? 'No email';
                final phone = userData?['phone'] ?? 'Add phone number';

                return CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverToBoxAdapter(child: _buildHeader(context, name, email)),
                    SliverPadding(
                      padding: const EdgeInsets.all(16),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          _buildSettingsSection(context, user.uid, name, phone),
                          const SizedBox(height: 24),
                        ]),
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildHeader(BuildContext context, String name, String email) {
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
              border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
            ),
            alignment: Alignment.center,
            child: const Text('👨‍💼', style: TextStyle(fontSize: 44)),
          ),
          const SizedBox(height: 12),
          Text(name,
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface)),
          Text(email,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.whiteSurface.withValues(alpha: 0.8))),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('Super Admin',
                style: GoogleFonts.poppins(
                    fontSize: 12, color: AppColors.whiteSurface, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, String uid, String name, String phone) {
    return Column(
      children: [
        _section('Account', [
          _tile(context, Icons.edit_rounded, 'Edit Profile', Colors.blue, 
              () => _showEditProfile(context, uid, name, phone)),
          _tile(context, Icons.lock_outline_rounded, 'Change Password', Colors.orange, () {
            AuthService.instance.resetPassword(AuthService.instance.currentUser?.email ?? '');
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Password reset email sent!', style: GoogleFonts.poppins())),
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
          _tile(context, Icons.settings_rounded, 'App Settings', Colors.grey, () {}),
          _tile(context, Icons.logout_rounded, 'Logout', AppColors.primaryRed,
              () => _showLogoutDialog(context),
              trailing: const SizedBox.shrink()),
        ]),
      ],
    );
  }

  Widget _section(String title, List<Widget> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      margin: const EdgeInsets.only(bottom: 16),
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

  Widget _tile(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap, {Widget? trailing}) {
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
              decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
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
            trailing ?? Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }

  void _showEditProfile(BuildContext context, String uid, String currentName, String currentPhone) {
    final nameController = TextEditingController(text: currentName);
    final phoneController = TextEditingController(text: currentPhone == 'Add phone number' ? '' : currentPhone);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom, top: 24, left: 24, right: 24),
        decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Edit Admin Profile', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 24),
            _textField(nameController, 'Name', Icons.person_outline_rounded),
            const SizedBox(height: 16),
            _textField(phoneController, 'Phone', Icons.phone_iphone_rounded, keyboardType: TextInputType.phone),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await AuthService.instance.updateUserDetails(uid, {'name': nameController.text, 'phone': phoneController.text});
                  if (context.mounted) Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: Text('Save Changes', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
        filled: true,
        fillColor: AppColors.lightGrayBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Logout', style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.poppins()),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary))),
          TextButton(
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
            },
            child: Text('Logout', style: GoogleFonts.poppins(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
