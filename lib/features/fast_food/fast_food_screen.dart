import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/product_card.dart';

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

  List<Map<String, dynamic>> get _visible {
    final selectedCategory = _filters[_selectedFilter];
    var filtered = selectedCategory == 'All'
        ? List<Map<String, dynamic>>.from(_products)
        : _products
              .where((p) => (p['category'] as String) == selectedCategory)
              .toList();
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
            (p) => (p['name'] as String).toLowerCase().contains(
              _searchQuery.toLowerCase(),
            ),
          )
          .toList();
    }
    return filtered;
  }

  static final List<Map<String, dynamic>> _products = [
    {
      'name': 'Classic Veg Burger',
      'emoji': '🍔',
      'rating': '4.8',
      'time': '22 min',
      'tag': 'Popular',
      'price': '₹180',
      'category': 'Burger',
    },
    {
      'name': 'Cheese Burst Pizza',
      'emoji': '🍕',
      'rating': '4.6',
      'time': '35 min',
      'tag': 'Chef pick',
      'price': '₹299',
      'category': 'Pizza',
    },
    {
      'name': 'Paneer Tikka Roll',
      'emoji': '🌯',
      'rating': '4.7',
      'time': '28 min',
      'tag': 'New',
      'price': '₹149',
      'category': 'Rolls',
    },
    {
      'name': 'Masala Fries',
      'emoji': '🍟',
      'rating': '4.5',
      'time': '18 min',
      'tag': 'Snack',
      'price': '₹99',
      'category': 'Burger',
    },
    {
      'name': 'Chocolate Shake',
      'emoji': '🥤',
      'rating': '4.9',
      'time': '15 min',
      'tag': 'Cold',
      'price': '₹129',
      'category': 'Drinks',
    },
    {
      'name': 'Mexican Taco',
      'emoji': '🌮',
      'rating': '4.4',
      'time': '26 min',
      'tag': 'Fusion',
      'price': '₹159',
      'category': 'Rolls',
    },
  ];

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
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search fast food...',
                          hintStyle: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.textSecondary,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                          ),
                        ),
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: GridView.builder(
                  physics: const BouncingScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.72,
                  ),
                  itemCount: _visible.length,
                  itemBuilder: (context, index) {
                    final p = _visible[index];
                    return ProductCard(
                      name: p['name'] as String,
                      price: p['price'] as String,
                      emoji: p['emoji'] as String,
                      rating: p['rating'] as String,
                      time: p['time'] as String,
                      tag: p['tag'] as String,
                      tagColor: AppColors.primaryOrange,
                      accentColor: AppColors.primaryRed,
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.productDetail),
                      onAdd: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              '${p['name']} added to cart',
                              style: GoogleFonts.poppins(),
                            ),
                            duration: const Duration(milliseconds: 1200),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
