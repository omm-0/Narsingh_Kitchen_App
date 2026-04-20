import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _controllers =
      List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  int _secondsLeft = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _timer?.cancel();
    _secondsLeft = 45;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_secondsLeft <= 0) { t.cancel(); setState(() {}); return; }
      setState(() => _secondsLeft -= 1);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) { c.dispose(); }
    for (final f in _focusNodes) { f.dispose(); }
    super.dispose();
  }

  String get _formattedTimer {
    final m = _secondsLeft ~/ 60;
    final s = _secondsLeft % 60;
    return '$m:${s.toString().padLeft(2, '0')}';
  }

  void _onDigitChanged(int index, String value) {
    if (value.length == 1 && index < 5) {
      _focusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  String get _enteredOtp => _controllers.map((c) => c.text).join();

  Future<void> _verifyOtp() async {
    if (_enteredOtp.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please enter all 6 digits', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    if (_enteredOtp != '123456') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid OTP. Try: 123456', style: GoogleFonts.poppins()),
          backgroundColor: AppColors.primaryRed,
        ),
      );
      return;
    }

    final role = await AuthService.instance.getUserRole();
    if (!mounted) return;
    if (role == 'admin') {
      Navigator.pushReplacementNamed(context, AppRoutes.adminBottomNav);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.bottomNav);
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
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: AppColors.lightPinkBg,
                  alignment: Alignment.center,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      shape: BoxShape.circle,
                      boxShadow: AppColors.cardShadow,
                    ),
                    alignment: Alignment.center,
                    child: const Text('📱', style: TextStyle(fontSize: 56)),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Verify Phone',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 26,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: 'Enter the 6-digit code sent to\n',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.textSecondary,
                            height: 1.5,
                          ),
                        ),
                        TextSpan(
                          text: '+91 98765 43210',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ]),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(6, (i) {
                        return SizedBox(
                          width: 50,
                          height: 60,
                          child: TextFormField(
                            controller: _controllers[i],
                            focusNode: _focusNodes[i],
                            maxLength: 1,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                              color: AppColors.textPrimary,
                            ),
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            decoration: InputDecoration(
                              counterText: '',
                              filled: true,
                              fillColor: AppColors.lightGrayBg,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: const BorderSide(
                                    color: AppColors.primaryRed, width: 1.2),
                              ),
                              contentPadding: EdgeInsets.zero,
                            ),
                            onChanged: (v) => _onDigitChanged(i, v),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.whiteSurface,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          textStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                        child: const Text('Verify & Continue'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Didn't receive code?  ",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: AppColors.textSecondary)),
                        SizedBox(
                          height: 28,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: _secondsLeft == 0
                                  ? () => setState(_startResendTimer)
                                  : null,
                              borderRadius: BorderRadius.circular(6),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                child: Center(
                                  child: Text(
                                    _secondsLeft > 0
                                        ? 'Resend in $_formattedTimer'
                                        : 'Resend code',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: AppColors.primaryRed),
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
