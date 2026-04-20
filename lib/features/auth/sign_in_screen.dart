import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _selectedRole = 'customer';

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) return 'Email is required';
    if (!value.contains('@')) return 'Enter a valid email';
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) return 'Password is required';
    if (value.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;
    await AuthService.instance.saveUserRole(_selectedRole);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.otp);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(40)),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: AppColors.primaryRed,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 40),
                      Text(
                        'Welcome Back 👋',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: AppColors.whiteSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Sign in to continue',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.whiteSurface.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      // ── Role Toggle ──────────────────────────────────────
                      Text(
                        'Sign in as',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _RoleChip(
                            label: 'Customer',
                            icon: Icons.person_rounded,
                            selected: _selectedRole == 'customer',
                            onTap: () => setState(() => _selectedRole = 'customer'),
                          ),
                          const SizedBox(width: 12),
                          _RoleChip(
                            label: 'Admin',
                            icon: Icons.admin_panel_settings_rounded,
                            selected: _selectedRole == 'admin',
                            onTap: () => setState(() => _selectedRole = 'admin'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // ── Email ────────────────────────────────────────────
                      TextFormField(
                        controller: _emailCtrl,
                        decoration: InputDecoration(
                          label: const Text('Email Address'),
                          hintText: 'you@email.com',
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 16),
                      // ── Password ─────────────────────────────────────────
                      TextFormField(
                        controller: _passwordCtrl,
                        decoration: InputDecoration(
                          label: const Text('Password'),
                          hintText: '••••••••',
                          prefixIcon: const Icon(Icons.lock_outline_rounded),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        obscureText: true,
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerRight,
                        child: SizedBox(
                          height: 28,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {},
                              borderRadius: BorderRadius.circular(8),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Text(
                                    'Forgot Password?',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: AppColors.whiteSurface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          child: const Text('Sign In'),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          const Expanded(child: Divider(color: AppColors.dividerGray)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text('or continue with',
                                style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.textSecondary)),
                          ),
                          const Expanded(child: Divider(color: AppColors.dividerGray)),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Google Sign-In not configured',
                                        style: GoogleFonts.poppins()),
                                    duration: const Duration(seconds: 1),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.lightGrayBg,
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.dividerGray),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  textStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                child: const Text('G  Google'),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: SizedBox(
                              height: 52,
                              child: OutlinedButton(
                                onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Phone Sign-In not configured',
                                        style: GoogleFonts.poppins()),
                                    duration: const Duration(seconds: 1),
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  backgroundColor: AppColors.lightGrayBg,
                                  foregroundColor: AppColors.textPrimary,
                                  side: const BorderSide(color: AppColors.dividerGray),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14)),
                                  textStyle: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500, fontSize: 14),
                                ),
                                child: const Text('📱  Phone'),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Don't have an account?  ",
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  color: AppColors.textSecondary)),
                          SizedBox(
                            height: 28,
                            child: Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: () => Navigator.pushNamed(context, AppRoutes.signUp),
                                borderRadius: BorderRadius.circular(4),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  child: Center(
                                    child: Text('Sign up',
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.primaryRed)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 50,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryRed : AppColors.lightGrayBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? AppColors.primaryRed : AppColors.dividerGray,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon,
                  size: 18,
                  color: selected ? AppColors.whiteSurface : AppColors.textSecondary),
              const SizedBox(width: 6),
              Text(label,
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: selected ? AppColors.whiteSurface : AppColors.textPrimary)),
            ],
          ),
        ),
      ),
    );
  }
}
