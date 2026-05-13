import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/cart_dock.dart';
import '../../core/widgets/product_card.dart';
import '../../data/cart_service.dart';
import '../../models/product_model.dart';
import '../../core/services/product_service.dart';

enum _SortMode { priceLow, priceHigh, rating }

class SpiceCategoryScreen extends StatefulWidget {
  const SpiceCategoryScreen({super.key, required this.category});

  final String category;

  @override
  State<SpiceCategoryScreen> createState() => _SpiceCategoryScreenState();
}

class _SpiceCategoryScreenState extends State<SpiceCategoryScreen> {
  _SortMode _sort = _SortMode.rating;

  List<ProductModel> _applySortAndFilter(List<ProductModel> all) {
    var list = all;
    if (widget.category != 'All') {
      list = list.where((p) => p.spiceCategory == widget.category).toList();
    }

    switch (_sort) {
      case _SortMode.priceLow:
        list = [...list]..sort((a, b) => a.price.compareTo(b.price));
        break;
      case _SortMode.priceHigh:
        list = [...list]..sort((a, b) => b.price.compareTo(a.price));
        break;
      case _SortMode.rating:
        list = [...list]..sort((a, b) => b.rating.compareTo(a.rating));
        break;
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const CartDock(),
      body: StreamBuilder<List<ProductModel>>(
        stream: ProductService.instance.getProductsWithFallback(
          ProductKind.spice,
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final all = snapshot.data ?? [];
          final items = _applySortAndFilter(all);

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 16, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Text(
                          widget.category == 'All'
                              ? 'All spices'
                              : '${widget.category} spices',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<_SortMode>(
                          value: _sort,
                          icon: const Icon(
                            Icons.sort_rounded,
                            color: AppColors.primaryBrown,
                          ),
                          items: [
                            DropdownMenuItem(
                              value: _SortMode.priceLow,
                              child: Text(
                                'Price ↑',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: _SortMode.priceHigh,
                              child: Text(
                                'Price ↓',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                            DropdownMenuItem(
                              value: _SortMode.rating,
                              child: Text(
                                'Rating',
                                style: GoogleFonts.poppins(fontSize: 13),
                              ),
                            ),
                          ],
                          onChanged: (v) {
                            if (v != null) setState(() => _sort = v);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      if (snapshot.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Live spice data is unavailable. Showing starter category items.',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                      Expanded(
                        child: items.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(32),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text(
                                        '🫙',
                                        style: TextStyle(fontSize: 56),
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'No products in this category yet.',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(20),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      childAspectRatio: 0.72,
                                    ),
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  final p = items[index];
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
                                      arguments: p,
                                    ),
                                    onAdd: () async {
                                      await CartService.instance.addProduct(
                                        p,
                                        variantLabel: '500g',
                                      );
                                      if (!context.mounted) return;
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${p.name} added to cart',
                                            style: GoogleFonts.poppins(),
                                          ),
                                          duration: const Duration(
                                            milliseconds: 900,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
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
    );
  }
}
