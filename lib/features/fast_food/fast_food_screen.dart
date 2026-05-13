import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/cart_dock.dart';
import '../../core/widgets/product_card.dart';
import '../../core/services/product_service.dart';
import '../../data/cart_service.dart';
import '../../models/product_model.dart';

class FastFoodScreen extends StatefulWidget {
  const FastFoodScreen({super.key});

  @override
  State<FastFoodScreen> createState() => _FastFoodScreenState();
}

class _FastFoodScreenState extends State<FastFoodScreen> {
  final List<String> _filters = const [
    'All',
    'Burger',
    'Pizza',
    'Rolls',
    'Drinks',
  ];

  int _selectedFilter = 0;
  String _searchQuery = '';

  List<ProductModel> _applyFilters(List<ProductModel> all) {
    final selectedCategory = _filters[_selectedFilter];
    var filtered = selectedCategory == 'All'
        ? all
        : all.where((p) => p.tag == selectedCategory).toList();
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
          ProductKind.fastFood,
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
                    color: AppColors.primaryRed,
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
                                '🍔 Fast Food',
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
                          height: 40,
                          child: ListView.separated(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: _filters.length,
                            separatorBuilder: (context, index) =>
                                const SizedBox(width: 8),
                            itemBuilder: (context, index) {
                              final selected = _selectedFilter == index;
                              return ChoiceChip(
                                label: Text(_filters[index]),
                                selected: selected,
                                labelStyle: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color: selected
                                      ? AppColors.primaryRed
                                      : AppColors.whiteSurface,
                                ),
                                selectedColor: AppColors.whiteSurface,
                                backgroundColor: Colors.transparent,
                                side: BorderSide(
                                  color: selected
                                      ? AppColors.whiteSurface
                                      : AppColors.whiteSurface.withValues(
                                          alpha: 0.5,
                                        ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                onSelected: (_) =>
                                    setState(() => _selectedFilter = index),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        if (snapshot.hasError)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Text(
                              'Fast food catalog is unavailable from backend. Showing starter items.',
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        Expanded(
                          child: visible.isEmpty
                              ? Center(
                                  child: Text(
                                    'No items found',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                )
                              : GridView.builder(
                                  physics: const BouncingScrollPhysics(),
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
                                    return ProductCard(
                                      name: p.name,
                                      price: '₹${p.price.toStringAsFixed(0)}',
                                      emoji: p.emoji,
                                      rating: p.ratingLabel,
                                      time: p.deliveryEta ?? 'Fresh batch',
                                      tag: p.tag.isNotEmpty ? p.tag : 'Popular',
                                      tagColor: AppColors.primaryOrange,
                                      accentColor: AppColors.primaryRed,
                                      onTap: () => Navigator.pushNamed(
                                        context,
                                        AppRoutes.productDetail,
                                        arguments: p,
                                      ),
                                      onAdd: () async {
                                        await CartService.instance.addProduct(
                                          p,
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
          title: const Text('Search Fast Food'),
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
