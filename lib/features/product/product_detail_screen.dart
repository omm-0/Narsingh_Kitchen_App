import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/widgets/quantity_stepper.dart';

import '../../data/cart_service.dart';
import '../../models/product_model.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final ProductModel product;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _tabIndex = 0;
  int _sizeIndex = 0;
  bool _addonCheese = true;
  bool _addonPatty = false;
  int _qty = 1;

  static const List<String> _sizes = ['Regular', 'Large', 'Extra Large'];

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.only(bottom: 100 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(30),
                  ),
                  child: Container(
                    height: 380,
                    width: double.infinity,
                    color: AppColors.lightPinkBg,
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              children: [
                                Material(
                                  color: AppColors.whiteSurface,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => Navigator.maybePop(context),
                                    customBorder: const CircleBorder(),
                                    child: const SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 18,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Material(
                                  color: AppColors.whiteSurface,
                                  shape: const CircleBorder(),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () {},
                                    customBorder: const CircleBorder(),
                                    child: const SizedBox(
                                      width: 44,
                                      height: 44,
                                      child: Icon(
                                        Icons.favorite_border_rounded,
                                        color: AppColors.primaryRed,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Center(
                              child: Text(
                                widget.product.emoji,
                                style: const TextStyle(fontSize: 130),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Transform.translate(
                  offset: const Offset(0, -24),
                  child: Container(
                    decoration: const BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(30),
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                widget.product.name,
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Text(
                              '₹${widget.product.price.toStringAsFixed(0)}',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w700,
                                fontSize: 22,
                                color: AppColors.primaryRed,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${_kindLabel(widget.product.kind)}   •   ⭐ ${widget.product.rating} (320 reviews)',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 13,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: List.generate(3, (i) {
                            final selected = _tabIndex == i;
                            final labels = ['Details', 'Reviews', 'Nutrition'];
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(right: i < 2 ? 8 : 0),
                                child: Material(
                                  color: selected
                                      ? AppColors.primaryRed
                                      : AppColors.lightGrayBg,
                                  borderRadius: BorderRadius.circular(50),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => setState(() => _tabIndex = i),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      child: Center(
                                        child: Text(
                                          labels[i],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: selected
                                                ? AppColors.whiteSurface
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          widget.product.subtitle.isNotEmpty
                              ? widget.product.subtitle
                              : 'Authentic flavor crafted with the finest ingredients. '
                                    'Prepared fresh daily to ensure premium quality and taste.',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Customize',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: List.generate(_sizes.length, (i) {
                            final selected = _sizeIndex == i;
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: i < _sizes.length - 1 ? 8 : 0,
                                ),
                                child: Material(
                                  color: selected
                                      ? AppColors.primaryRed
                                      : AppColors.lightGrayBg,
                                  borderRadius: BorderRadius.circular(50),
                                  clipBehavior: Clip.antiAlias,
                                  child: InkWell(
                                    onTap: () => setState(() => _sizeIndex = i),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      child: Center(
                                        child: Text(
                                          _sizes[i],
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13,
                                            color: selected
                                                ? AppColors.whiteSurface
                                                : AppColors.textPrimary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Add-ons',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _addonRow(
                          title: 'Extra Cheese',
                          price: '+₹30',
                          selected: _addonCheese,
                          onTap: () =>
                              setState(() => _addonCheese = !_addonCheese),
                        ),
                        const SizedBox(height: 8),
                        _addonRow(
                          title: 'Smoky Patty Upgrade',
                          price: '+₹50',
                          selected: _addonPatty,
                          onTap: () =>
                              setState(() => _addonPatty = !_addonPatty),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Material(
              elevation: 12,
              color: AppColors.whiteSurface,
              child: SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
                  child: Row(
                    children: [
                      QuantityStepper(
                        quantity: _qty,
                        onMinus: () =>
                            setState(() => _qty = (_qty - 1).clamp(1, 99)),
                        onPlus: () =>
                            setState(() => _qty = (_qty + 1).clamp(1, 99)),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 52,
                          child: ElevatedButton(
                            onPressed: () async {
                              final variant =
                                  widget.product.kind == ProductKind.spice
                                  ? _sizes[_sizeIndex]
                                  : null;

                              await CartService.instance.addProduct(
                                widget.product,
                                quantity: _qty,
                                variantLabel: variant,
                              );

                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Added to cart! Quantity: $_qty',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    duration: const Duration(milliseconds: 900),
                                  ),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryRed,
                              foregroundColor: AppColors.whiteSurface,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            child: Text(
                              '🛒  Add to Cart  •  ₹${(widget.product.priceForVariant(widget.product.kind == ProductKind.spice ? _sizes[_sizeIndex] : null) * _qty).toStringAsFixed(0)}',
                            ),
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

  String _kindLabel(ProductKind kind) {
    switch (kind) {
      case ProductKind.fastFood:
        return '🍔 Fast Food';
      case ProductKind.tiffinMeal:
        return '🍱 Tiffin Meal';
      case ProductKind.spice:
        return '🌶️ Spices';
    }
  }

  Widget _addonRow({
    required String title,
    required String price,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: AppColors.lightGrayBg,
      borderRadius: BorderRadius.circular(14),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                price,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected
                    ? AppColors.primaryRed
                    : AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
