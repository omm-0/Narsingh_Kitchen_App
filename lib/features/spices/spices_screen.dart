import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/cart_dock.dart';
import '../../core/widgets/product_card.dart';
import '../../data/cart_service.dart';
import '../../models/product_model.dart';
import '../../core/services/product_service.dart';

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
  String _searchQuery = '';
  late final AnimationController _promoCtrl = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 3),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _promoCtrl.dispose();
    super.dispose();
  }

  List<ProductModel> _applyFilters(List<ProductModel> all) {
    final chip = _filters[_selected];
    var filtered = all;

    if (chip != 'All') {
      filtered = filtered.where((p) => p.spiceCategory == chip).toList();
    }

    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => p.name.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }
    return filtered;
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
          final visible = _applyFilters(all);

          return SafeArea(
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
                              onPressed: () {
                                _showSearchDialog();
                              },
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
                        if (snapshot.hasError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Spice inventory is unavailable from backend. Showing starter catalog.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
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
                                    AppColors.primaryBrown.withValues(
                                      alpha: 0.88,
                                    ),
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
                            icon: const Icon(
                              Icons.grid_view_rounded,
                              color: AppColors.primaryBrown,
                              size: 20,
                            ),
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
                          itemCount: visible.length,
                          itemBuilder: (context, index) {
                            final p = visible[index];
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
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      '${p.name} added to cart',
                                      style: GoogleFonts.poppins(),
                                    ),
                                    duration: const Duration(milliseconds: 900),
                                  ),
                                );
                              },
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
          );
        },
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String query = _searchQuery;
        return AlertDialog(
          title: const Text('Search Spices'),
          content: TextField(
            onChanged: (v) => query = v,
            decoration: const InputDecoration(
              hintText: 'Search by name...',
              border: OutlineInputBorder(),
            ),
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _searchQuery = query);
                Navigator.pop(context);
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}
