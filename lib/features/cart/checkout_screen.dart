import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';
import '../../data/cart_service.dart';

enum _PayMethod { cod, upi, card }

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _addressCtrl = TextEditingController(
    text: 'Plot 42, Sector 9, Near City Mall — ${AppStrings.userLocation}',
  );

  _PayMethod _pay = _PayMethod.upi;

  @override
  void dispose() {
    _addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.maybePop(context),
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                  ),
                  Expanded(
                    child: Text(
                      'Checkout',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 22,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Delivery address',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _addressCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightPinkBg,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      style: GoogleFonts.poppins(fontSize: 14),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Payment method',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _payTile(
                      title: 'Cash on delivery',
                      icon: Icons.payments_rounded,
                      value: _PayMethod.cod,
                    ),
                    const SizedBox(height: 10),
                    _payTile(
                      title: 'UPI (GPay / PhonePe)',
                      icon: Icons.account_balance_wallet_rounded,
                      value: _PayMethod.upi,
                    ),
                    const SizedBox(height: 10),
                    _payTile(
                      title: 'Credit / Debit card',
                      icon: Icons.credit_card_rounded,
                      value: _PayMethod.card,
                    ),
                    const SizedBox(height: 28),
                    Text(
                      'Order breakdown',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        children: [
                          _row('Subtotal', cart.formatInr(cart.subtotal)),
                          const SizedBox(height: 10),
                          _row('Delivery', cart.formatInr(CartService.deliveryFee)),
                          const SizedBox(height: 10),
                          _row(
                            'Promo',
                            cart.promoActive
                                ? '− ${cart.formatInr(cart.promoDiscount)}'
                                : '—',
                            valueColor: cart.promoActive
                                ? AppColors.successGreen
                                : AppColors.textSecondary,
                          ),
                          const SizedBox(height: 10),
                          _row('GST 5%', cart.formatInr(cart.gstAmount)),
                          const Divider(height: 24),
                          _row(
                            'Total',
                            cart.formatInr(cart.total),
                            strong: true,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          final id = cart.generateOrderId();
                          cart.clear();
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.orderSuccess,
                            arguments: id,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.whiteSurface,
                    disabledBackgroundColor:
                        AppColors.dividerGray.withValues(alpha: 0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    textStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16,
                    ),
                  ),
                  child: const Text('Confirm order'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _payTile({
    required String title,
    required IconData icon,
    required _PayMethod value,
  }) {
    final selected = _pay == value;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? AppColors.primaryRed : AppColors.dividerGray,
          width: selected ? 1.6 : 1,
        ),
        color: selected
            ? AppColors.lightPinkBg
            : AppColors.whiteSurface,
        boxShadow: selected ? AppColors.cardShadow : null,
      ),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primaryRed),
        title: Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        trailing: Icon(
          selected ? Icons.check_circle_rounded : Icons.circle_outlined,
          color:
              selected ? AppColors.primaryRed : AppColors.textSecondary,
        ),
        onTap: () => setState(() => _pay = value),
      ),
    );
  }

  Widget _row(String label, String value,
      {Color? valueColor, bool strong = false}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: strong ? FontWeight.w700 : FontWeight.w400,
              fontSize: strong ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: strong ? 17 : 14,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
