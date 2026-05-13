import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/cart_dock.dart';
import '../../data/cart_service.dart';
import '../../models/product_model.dart';

class TiffinDetailScreen extends StatelessWidget {
  const TiffinDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const CartDock(bottomPadding: 64),
      body: Stack(
        children: [
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Container(
                    height: 280,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lightOrangeBg,
                          AppColors.primaryOrange.withValues(alpha: 0.85),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () => Navigator.maybePop(context),
                              style: IconButton.styleFrom(
                                backgroundColor: AppColors.whiteSurface
                                    .withValues(alpha: 0.9),
                              ),
                              icon: const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 18,
                              ),
                            ),
                            const Spacer(),
                            Center(
                              child: Hero(
                                tag: 'tiffin-${product.id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    product.emoji,
                                    style: const TextStyle(fontSize: 96),
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 100 + bottom),
                sliver: SliverList.list(
                  children: [
                    Text(
                      product.name,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      product.subtitle,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starYellow,
                          size: 20,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${product.ratingLabel} rating',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '₹${product.price.toStringAsFixed(0)}/meal',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Meal breakdown'),
                    const SizedBox(height: 12),
                    ...product.mealComponents.map(
                      (line) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('• ', style: TextStyle(fontSize: 18)),
                            Expanded(
                              child: Text(
                                line,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14,
                                  height: 1.45,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _sectionTitle('Nutrition snapshot'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: product.nutritionLines
                            .map(
                              (l) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Text(
                                  l,
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _sectionTitle('Weekly rotation'),
                    const SizedBox(height: 12),
                    ...product.weeklyRotation.map(
                      (l) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: AppColors.primaryOrange,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                l,
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 14,
              color: AppColors.whiteSurface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: OutlinedButton(
                            onPressed: () async {
                              await CartService.instance.addProduct(product);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${product.name} added to cart',
                                    style: GoogleFonts.poppins(),
                                  ),
                                  duration: const Duration(milliseconds: 900),
                                ),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryOrange,
                              side: const BorderSide(
                                color: AppColors.primaryOrange,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            child: const Text('Buy once'),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 54,
                          child: ElevatedButton(
                            onPressed: () => Navigator.pushNamed(
                              context,
                              AppRoutes.subscriptionPlan,
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryOrange,
                              foregroundColor: AppColors.whiteSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                            child: const Text('Subscribe'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String t) {
    return Text(
      t,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 17,
        color: AppColors.textPrimary,
      ),
    );
  }
}
