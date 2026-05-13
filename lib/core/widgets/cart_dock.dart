import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../data/cart_service.dart';
import '../constants/app_colors.dart';
import '../constants/app_routes.dart';

class CartDock extends StatelessWidget {
  const CartDock({super.key, this.bottomPadding = 0});

  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: CartService.instance,
      builder: (context, _) {
        final cart = CartService.instance;
        if (cart.isEmpty) return const SizedBox.shrink();

        return SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPadding),
            child: Material(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(18),
              elevation: 8,
              child: InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryRed,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${cart.items.length}',
                          style: GoogleFonts.outfit(
                            color: AppColors.whiteSurface,
                            fontWeight: FontWeight.w800,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View cart',
                              style: GoogleFonts.outfit(
                                color: AppColors.whiteSurface,
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              cart.formatInr(cart.total),
                              style: GoogleFonts.outfit(
                                color: AppColors.whiteSurface.withValues(
                                  alpha: 0.78,
                                ),
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Open',
                        style: GoogleFonts.outfit(
                          color: AppColors.whiteSurface,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.shopping_cart_checkout_rounded,
                        color: AppColors.whiteSurface,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
