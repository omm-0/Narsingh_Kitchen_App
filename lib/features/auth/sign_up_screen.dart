import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../core/services/auth_service.dart';
import '../../core/widgets/custom_textfield.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  bool _isLoading = false;
  bool _isCustomer = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleCreateAccount() async {
    if (_emailCtrl.text.isEmpty || _passwordCtrl.text.isEmpty || _nameCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await AuthService.instance.signUp(
        _emailCtrl.text.trim(),
        _passwordCtrl.text.trim(),
        _nameCtrl.text.trim(),
        role: _isCustomer ? 'customer' : 'admin',
      );
      
      if (!mounted) return;
      
      // After sign up, redirect based on role
      if (_isCustomer) {
        Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.adminBottomNav);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
                        'Create Account ✨',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 28,
                          color: AppColors.whiteSurface,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Join ${AppStrings.appDisplayName} today!',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: _nameCtrl,
                      label: 'Full Name',
                      hint: 'John Doe',
                      prefixIcon: Icons.person_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _phoneCtrl,
                      label: 'Phone Number',
                      hint: '+91 98765 43210',
                      prefixIcon: Icons.phone_android_rounded,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _emailCtrl,
                      label: 'Email Address',
                      hint: 'john@email.com',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      controller: _passwordCtrl,
                      label: 'Password',
                      hint: 'Min. 8 characters',
                      obscureText: true,
                      prefixIcon: Icons.lock_outline_rounded,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'I am a',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => setState(() => _isCustomer = true),
                              borderRadius: BorderRadius.circular(14),
                              child: Ink(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: _isCustomer
                                      ? AppColors.primaryRed
                                      : AppColors.lightGrayBg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: _isCustomer
                                        ? AppColors.primaryRed
                                        : AppColors.dividerGray,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Customer',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: _isCustomer
                                          ? AppColors.whiteSurface
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => setState(() => _isCustomer = false),
                              borderRadius: BorderRadius.circular(14),
                              child: Ink(
                                height: 50,
                                decoration: BoxDecoration(
                                  color: !_isCustomer
                                      ? AppColors.primaryRed
                                      : AppColors.lightGrayBg,
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: !_isCustomer
                                        ? AppColors.primaryRed
                                        : AppColors.dividerGray,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    'Admin',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: !_isCustomer
                                          ? AppColors.whiteSurface
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleCreateAccount,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: AppColors.whiteSurface,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          child: _isLoading 
                            ? const SizedBox(
                                height: 24,
                                width: 24,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : const Text('Create Account'),
                        ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Already have an account?  ',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        SizedBox(
                          height: 28,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () => Navigator.pushReplacementNamed(
                                  context, AppRoutes.signIn),
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Center(
                                  child: Text(
                                    'Sign In',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14,
                                      color: AppColors.primaryRed,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
