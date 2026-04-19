import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/animated_quantity_stepper.dart';
import '../../data/cart_service.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key, this.embeddedInNav = false});

  final bool embeddedInNav;

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final _promoCtrl = TextEditingController();

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartService.instance,
      builder: (context, _) {
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
                      if (!widget.embeddedInNav)
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        )
                      else
                        const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'My Cart',
                          textAlign: widget.embeddedInNav
                              ? TextAlign.left
                              : TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 22,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      Text(
                        '${cart.items.length} items',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 13,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: cart.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 72,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.35,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Your cart is empty',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Browse fast food, tiffin, or spices and tap add to cart.',
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 24),
                                OutlinedButton(
                                  onPressed: () =>
                                      Navigator.pushNamedAndRemoveUntil(
                                        context,
                                        AppRoutes.bottomNav,
                                        (r) => false,
                                      ),
                                  child: Text(
                                    'Start shopping',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ...cart.items.map(
                                (line) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _DismissLine(
                                    line: line,
                                    child: _cartLine(cart, line),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.lightOrangeBg,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _promoCtrl,
                                        decoration: InputDecoration(
                                          hintText: 'Try FEAST10',
                                          hintStyle: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: AppColors.textSecondary,
                                          ),
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      width: 80,
                                      height: 44,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          cart.applyPromoCode(_promoCtrl.text);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryRed,
                                          foregroundColor:
                                              AppColors.whiteSurface,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          textStyle: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        child: const Text('Apply'),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (cart.promoActive) ...[
                                const SizedBox(height: 8),
                                Text(
                                  'Promo FEAST10 applied — enjoy savings on this order.',
                                  style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    color: AppColors.successGreen,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteSurface,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: AppColors.cardShadow,
                                ),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Text(
                                      'Order Summary',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _summaryRow(
                                      'Subtotal',
                                      cart.formatInr(cart.subtotal),
                                    ),
                                    const SizedBox(height: 10),
                                    _summaryRow(
                                      'Delivery Fee',
                                      cart.formatInr(CartService.deliveryFee),
                                    ),
                                    const SizedBox(height: 10),
                                    _summaryRow(
                                      'Promo Discount',
                                      cart.promoActive
                                          ? '− ${cart.formatInr(cart.promoDiscount)}'
                                          : '—',
                                      valueColor: cart.promoActive
                                          ? AppColors.successGreen
                                          : AppColors.textSecondary,
                                    ),
                                    const SizedBox(height: 10),
                                    _summaryRow(
                                      'GST 5%',
                                      cart.formatInr(cart.gstAmount),
                                    ),
                                    const Divider(
                                      height: 24,
                                      color: AppColors.dividerGray,
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          'Total',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                        const Spacer(),
                                        Text(
                                          cart.formatInr(cart.total),
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ],
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
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: cart.isEmpty
                          ? null
                          : () => Navigator.pushNamed(
                              context,
                              AppRoutes.checkout,
                            ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryRed,
                        foregroundColor: AppColors.whiteSurface,
                        disabledBackgroundColor: AppColors.dividerGray
                            .withValues(alpha: 0.45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('🛒  Proceed to checkout'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cartLine(CartService cart, CartItemModel line) {
    final variant = line.variantLabel != null ? ' · ${line.variantLabel}' : '';
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 60,
              height: 60,
              color: AppColors.lightPinkBg,
              alignment: Alignment.center,
              child: Text(
                line.product.emoji,
                style: const TextStyle(fontSize: 28),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  line.product.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${_kindLabel(line.product.kind)}$variant',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  cart.formatInr(line.unitPrice),
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ),
          AnimatedQuantityStepper(
            quantity: line.quantity,
            onMinus: () => cart.updateQuantity(line.lineId, line.quantity - 1),
            onPlus: () => cart.updateQuantity(line.lineId, line.quantity + 1),
          ),
        ],
      ),
    );
  }

  String _kindLabel(ProductKind kind) {
    switch (kind) {
      case ProductKind.fastFood:
        return 'Fast Food';
      case ProductKind.tiffinMeal:
        return 'Tiffin';
      case ProductKind.spice:
        return 'Spices';
    }
  }

  Widget _summaryRow(String label, String value, {Color? valueColor}) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _DismissLine extends StatelessWidget {
  const _DismissLine({required this.line, required this.child});

  final CartItemModel line;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(line.lineId),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.primaryRed.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const Icon(
          Icons.delete_outline_rounded,
          color: AppColors.primaryRed,
        ),
      ),
      onDismissed: (_) {
        CartService.instance.removeLine(line.lineId);
      },
      child: child,
    );
  }
}
