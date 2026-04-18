import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/product_card.dart';
import '../../data/dummy_data.dart';
import '../../models/product_model.dart';

class SpicesScreen extends StatefulWidget {
  const SpicesScreen({super.key});

  @override
  State<SpicesScreen> createState() => _SpicesScreenState();
}

class _SpicesScreenState extends State<SpicesScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _filters = const [
    'All',
    'Whole',
    'Ground',
    'Blends',
    'Seeds',
  ];

  int _selected = 0;
  late final AnimationController _promoCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  List<ProductModel> get _visible {
    final chip = _filters[_selected];
    return DummyData.spicesFiltered(chip);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(30),
              ),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.primaryBrown,
                      AppColors.primaryBrown.withValues(alpha: 0.82),
                      AppColors.lightBrownBg.withValues(alpha: 0.75),
                    ],
                  ),
                ),
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.maybePop(context),
                          icon: const Icon(
                            Icons.arrow_back_ios_new_rounded,
                            color: AppColors.whiteSurface,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '🌶️ Spices',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.whiteSurface,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.whiteSurface,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 42,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _filters.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final selected = _selected == index;
                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 260),
                            curve: Curves.easeOutCubic,
                            child: Material(
                              color: selected
                                  ? AppColors.whiteSurface
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(50),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(50),
                                onTap: () =>
                                    setState(() => _selected = index),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  child: Text(
                                    _filters[index],
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: selected
                                          ? AppColors.primaryBrown
                                          : AppColors.whiteSurface,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AnimatedBuilder(
                      animation: _promoCtrl,
                      builder: (context, child) {
                        final t = _promoCtrl.value;
                        final lift = 6 + t * 6;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                AppColors.primaryBrown,
                                AppColors.primaryBrown
                                    .withValues(alpha: 0.88),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(22),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.12),
                                blurRadius: lift + 12,
                                offset: Offset(0, lift),
                              ),
                            ],
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(16),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: AppColors.lightBrownBg,
                                  alignment: Alignment.center,
                                  child: const Text(
                                    '🌿',
                                    style: TextStyle(fontSize: 32),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Farm Fresh Collection',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: AppColors.whiteSurface,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Direct from Rajasthan farms',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: AppColors.whiteSurface
                                            .withValues(alpha: 0.78),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Up to 30% off on bulk orders',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: AppColors.whiteSurface
                                            .withValues(alpha: 0.78),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton.icon(
                        onPressed: () => Navigator.pushNamed(
                          context,
                          AppRoutes.spiceCategory,
                          arguments: _filters[_selected],
                        ),
                        icon: const Icon(Icons.grid_view_rounded,
                            color: AppColors.primaryBrown, size: 20),
                        label: Text(
                          'Open category view',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: _visible.length,
                      itemBuilder: (context, index) {
                        final p = _visible[index];
                        final priceLabel =
                            '₹${p.priceForVariant("500g").toStringAsFixed(0)} / 500g';
                        return ProductCard(
                          name: p.name,
                          price: priceLabel,
                          emoji: p.emoji,
                          rating: p.ratingLabel,
                          time: p.spiceCategory,
                          tag: p.tag,
                          tagColor: AppColors.primaryBrown,
                          accentColor: AppColors.primaryBrown,
                          heroTag: 'spice-${p.id}',
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.spiceDetail,
                            arguments: p.id,
                          ),
                          onAdd: () {},
                        );
                      },
                    ),
                    const SizedBox(height: 72),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Material(
        color: AppColors.primaryBrown,
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        elevation: 6,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, AppRoutes.cart),
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              Icons.shopping_cart_rounded,
              color: AppColors.whiteSurface,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }
}
