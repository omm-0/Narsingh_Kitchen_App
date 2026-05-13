import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  final bool embeddedInNav;
  const ProfileScreen({super.key, this.embeddedInNav = false});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;

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
              'Profile',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                fontSize: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ),
      body: SafeArea(
        child: user == null 
          ? _buildNotSignedIn(context)
          : StreamBuilder<Map<String, dynamic>?>(
              stream: AuthService.instance.getUserDetailsStream(user.uid),
              builder: (context, snapshot) {
                final userData = snapshot.data;
                final name = userData?['name'] ?? 'User';
                final email = user.email ?? 'No email';
                final phone = userData?['phone'] ?? 'Add phone number';
                
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      if (embeddedInNav)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 32),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Profile',
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w800,
                                fontSize: 28,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                        ),
                      
                      // Profile Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: AppColors.whiteSurface,
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 1.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primaryRed.withValues(alpha: 0.3),
                                        blurRadius: 12,
                                        offset: const Offset(0, 6),
                                      ),
                                    ],
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    name.isNotEmpty ? name[0].toUpperCase() : 'U',
                                    style: GoogleFonts.outfit(
                                      fontSize: 32,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 22,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        email,
                                        style: GoogleFonts.outfit(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => _showEditProfile(context, user.uid, name, phone),
                                  icon: const Icon(Icons.edit_note_rounded, color: AppColors.primaryRed),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            const Divider(color: AppColors.dividerGray),
                            const SizedBox(height: 16),
                            _profileInfoRow(Icons.phone_iphone_rounded, phone),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                      
                      _sectionHeader('Account Settings'),
                      const SizedBox(height: 12),
                      _menuItem(Icons.payment_rounded, 'Payment Methods', 'Manage your cards & wallets', 
                          () => Navigator.pushNamed(context, AppRoutes.paymentMethods)),
                      _menuItem(Icons.location_on_rounded, 'Saved Addresses', 'Home, Office & other addresses', 
                          () => Navigator.pushNamed(context, AppRoutes.savedAddresses)),
                      _menuItem(Icons.notifications_none_rounded, 'Notifications', 'Customize your alerts', () {}),
                      
                      const SizedBox(height: 24),
                      _sectionHeader('Subscriptions'),
                      const SizedBox(height: 12),
                      _menuItem(Icons.card_membership_rounded, 'Active Subscriptions', 'View your tiffin plans', 
                          () => Navigator.pushNamed(context, AppRoutes.mySubscriptions)),
                      _menuItem(Icons.history_rounded, 'Subscription History', 'Past tiffin subscriptions', () {}),

                      const SizedBox(height: 24),
                      _sectionHeader('Support'),
                      const SizedBox(height: 12),
                      _menuItem(Icons.help_outline_rounded, 'Help & Support', 'FAQs & customer care', () {}),
                      _menuItem(Icons.info_outline_rounded, 'About Us', 'Our story & mission', () {}),
                      
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton.icon(
                          onPressed: () => _showLogoutDialog(context),
                          icon: const Icon(Icons.logout_rounded, color: Colors.red),
                          label: Text(
                            'Logout',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                              color: Colors.red,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            backgroundColor: Colors.red.withValues(alpha: 0.1),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                );
              },
            ),
      ),
    );
  }

  Widget _buildNotSignedIn(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.person_outline_rounded, size: 80, color: AppColors.dividerGray),
          const SizedBox(height: 24),
          Text(
            'Not Signed In',
            style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to view your profile and orders',
            style: GoogleFonts.outfit(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.signIn),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Sign In', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w700,
          fontSize: 16,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _profileInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.textSecondary),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 14,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _menuItem(IconData icon, String title, String subtitle, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.whiteSurface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryRed.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: AppColors.primaryRed, size: 22),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded, color: AppColors.textSecondary),
            ],
          ),
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
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24,
          left: 24,
          right: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Edit Profile',
                style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
              ),
              const SizedBox(height: 24),
              _textField(nameController, 'Full Name', Icons.person_outline_rounded),
              const SizedBox(height: 16),
              _textField(phoneController, 'Phone Number', Icons.phone_iphone_rounded, keyboardType: TextInputType.phone),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await AuthService.instance.updateUserDetails(uid, {
                      'name': nameController.text,
                      'phone': phoneController.text,
                    });
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text('Save Changes', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label, IconData icon, {TextInputType? keyboardType}) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
        prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
        filled: true,
        fillColor: AppColors.lightGrayBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: AppColors.primaryRed, width: 2)),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text('Logout', style: GoogleFonts.outfit(fontWeight: FontWeight.w800)),
        content: Text('Are you sure you want to logout?', style: GoogleFonts.outfit()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.outfit(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () async {
              await AuthService.instance.logout();
              if (context.mounted) {
                Navigator.pushNamedAndRemoveUntil(context, AppRoutes.signIn, (route) => false);
              }
            },
            child: Text('Logout', style: GoogleFonts.outfit(color: Colors.red, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
