import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../data/cart_service.dart';
import '../../models/product_model.dart';

class SpiceDetailScreen extends StatefulWidget {
  const SpiceDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<SpiceDetailScreen> createState() => _SpiceDetailScreenState();
}

class _SpiceDetailScreenState extends State<SpiceDetailScreen> {
  late String _weightLabel;

  @override
  void initState() {
    super.initState();
    final opts = widget.product.weightOptions.toList();
    if (opts.isEmpty) {
      _weightLabel = '500g';
    } else {
      _weightLabel = opts.length > 2 ? opts[2] : opts.first;
    }
  }

  double get _unit => widget.product.priceForVariant(_weightLabel);

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
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
                    height: 300,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.lightBrownBg,
                          AppColors.primaryBrown.withValues(alpha: 0.88),
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
                                backgroundColor:
                                    AppColors.whiteSurface.withValues(alpha: 0.92),
                              ),
                              icon: const Icon(Icons.arrow_back_ios_new_rounded,
                                  size: 18),
                            ),
                            const Spacer(),
                            Center(
                              child: Hero(
                                tag: 'spice-${p.id}',
                                child: Material(
                                  type: MaterialType.transparency,
                                  child: Text(
                                    p.emoji,
                                    style: const TextStyle(fontSize: 100),
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
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        p.name,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        p.subtitle,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded,
                              color: AppColors.starYellow),
                          const SizedBox(width: 6),
                          Text(
                            '${p.ratingLabel} rating',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '₹${_unit.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                              color: AppColors.primaryBrown,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Pack size',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: p.weightOptions.map((w) {
                          final sel = _weightLabel == w;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 240),
                            curve: Curves.easeOutCubic,
                            child: Material(
                              color: sel
                                  ? AppColors.primaryBrown
                                  : AppColors.lightGrayBg,
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () =>
                                    setState(() => _weightLabel = w),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 18,
                                    vertical: 12,
                                  ),
                                  child: Text(
                                    w,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: sel
                                          ? AppColors.whiteSurface
                                          : AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 28),
                      Text(
                        'Purity index',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: LinearProgressIndicator(
                          minHeight: 10,
                          value: (p.purityPercent ?? 98) / 100,
                          backgroundColor: AppColors.dividerGray,
                          color: AppColors.successGreen,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${p.purityPercent?.toStringAsFixed(1) ?? "98"}% lab-verified batch',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Farm source',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.whiteSurface,
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: AppColors.cardShadow,
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.agriculture_rounded,
                                color: AppColors.primaryBrown),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                p.farmRegion ??
                                    'Partner farms across Rajasthan',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  height: 1.45,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  child: SizedBox(
                    height: 54,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        CartService.instance.addProduct(
                          p,
                          quantity: 1,
                          variantLabel: _weightLabel,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${p.name} ($_weightLabel) added to cart',
                              style: GoogleFonts.poppins(),
                            ),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBrown,
                        foregroundColor: AppColors.whiteSurface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Add to cart'),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
