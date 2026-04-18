import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/widgets/product_card.dart';

class SpicesScreen extends StatefulWidget {
  const SpicesScreen({super.key});

  @override
  State<SpicesScreen> createState() => _SpicesScreenState();
}

class _SpicesScreenState extends State<SpicesScreen> {
  final List<String> _filters = const [
    'All',
    'Whole',
    'Ground',
    'Blends',
    'Seeds',
  ];

  int _selected = 0;

  static final List<Map<String, dynamic>> _items = [
    {
      'name': 'Red Chilli Powder',
      'emoji': '🌶️',
      'rating': '4.9',
      'time': 'Farm pack',
      'tag': 'Hot',
      'price': '₹180 / 500g',
    },
    {
      'name': 'Turmeric Powder',
      'emoji': '🟡',
      'rating': '4.8',
      'time': 'Organic',
      'tag': 'Pure',
      'price': '₹120 / 500g',
    },
    {
      'name': 'Cumin Seeds',
      'emoji': '🌿',
      'rating': '4.7',
      'time': 'Whole',
      'tag': 'Aroma',
      'price': '₹160 / 500g',
    },
    {
      'name': 'Coriander Powder',
      'emoji': '🍃',
      'rating': '4.6',
      'time': 'Ground',
      'tag': 'Fresh',
      'price': '₹90 / 500g',
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
                color: AppColors.primaryBrown,
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
                      height: 40,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: _filters.length,
                        separatorBuilder: (context, index) =>
                            const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final selected = _selected == index;
                          return ChoiceChip(
                            label: Text(_filters[index]),
                            selected: selected,
                            labelStyle: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: selected
                                  ? AppColors.primaryBrown
                                  : AppColors.whiteSurface,
                            ),
                            selectedColor: AppColors.whiteSurface,
                            backgroundColor: Colors.transparent,
                            side: BorderSide(
                              color: AppColors.whiteSurface
                                  .withValues(alpha: 0.45),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            onSelected: (_) =>
                                setState(() => _selected = index),
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
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBrown,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: AppColors.cardShadow,
                      ),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Up to 30% off on bulk orders',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: AppColors.whiteSurface
                                        .withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
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
                      itemCount: _items.length,
                      itemBuilder: (context, index) {
                        final p = _items[index];
                        return ProductCard(
                          name: p['name'] as String,
                          price: p['price'] as String,
                          emoji: p['emoji'] as String,
                          rating: p['rating'] as String,
                          time: p['time'] as String,
                          tag: p['tag'] as String,
                          tagColor: AppColors.primaryBrown,
                          accentColor: AppColors.primaryBrown,
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.productDetail,
                          ),
                          onAdd: () {},
                        );
                      },
                    ),
                    const SizedBox(height: 80),
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
        child: InkWell(
          onTap: () {},
          customBorder: const CircleBorder(),
          child: const SizedBox(
            width: 56,
            height: 56,
            child: Icon(
              Icons.add_rounded,
              color: AppColors.whiteSurface,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
