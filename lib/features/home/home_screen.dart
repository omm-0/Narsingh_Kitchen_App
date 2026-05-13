import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/services/product_service.dart';
import '../../core/services/auth_service.dart';
import '../../models/product_model.dart';
import '../../models/category_model.dart';
import '../../models/address_model.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/app_strings.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showLocationPicker(BuildContext context) {
    final user = AuthService.instance.currentUser;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        if (user == null) {
          return Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Delivery Location',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Sign in to manage saved delivery addresses.',
                  style: GoogleFonts.outfit(color: AppColors.textSecondary),
                ),
              ],
            ),
          );
        }

        return StreamBuilder<List<AddressModel>>(
          stream: AuthService.instance.getAddressesStream(user.uid),
          builder: (context, snapshot) {
            final addresses = snapshot.data ?? [];
            return Container(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Delivery Location',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (addresses.isEmpty)
                    Text(
                      'No saved addresses yet. Add one from your profile to use live delivery locations.',
                      style: GoogleFonts.outfit(color: AppColors.textSecondary),
                    )
                  else
                    ...addresses.map(
                      (address) => _locationTile(
                        context,
                        address.label,
                        address.fullAddress,
                      ),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _locationTile(BuildContext context, String title, String address) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: const Icon(
        Icons.location_on_outlined,
        color: AppColors.primaryRed,
      ),
      title: Text(
        title,
        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(address, style: GoogleFonts.outfit(fontSize: 12)),
      onTap: () => Navigator.pop(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = AuthService.instance.currentUser;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 110,
            floating: false,
            pinned: true,
            elevation: 0,
            automaticallyImplyLeading: false,
            backgroundColor: AppColors.primaryRed,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [AppColors.primaryRed, Color(0xFFB71C1C)],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(32),
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      top: -10,
                      right: -10,
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.whiteSurface.withValues(
                          alpha: 0.05,
                        ),
                      ),
                    ),
                    SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _HeaderIdentity(
                                userId: currentUser?.uid,
                                onTapLocation: () =>
                                    _showLocationPicker(context),
                              ),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.notifications_none_rounded,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {},
                                ),
                                CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.2,
                                  ),
                                  child: Text(
                                    'RB',
                                    style: GoogleFonts.outfit(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (currentUser == null)
                    _infoStrip(
                      'Browse mode active. Sign in to sync addresses, orders, and subscriptions.',
                    ),
                  if (currentUser == null) const SizedBox(height: 16),
                  // Search Bar
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.whiteSurface,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search delicious meals...',
                        hintStyle: GoogleFonts.outfit(
                          color: AppColors.textSecondary,
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.primaryRed,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Categories
                  Text(
                    'Explore Categories',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<CategoryModel>>(
                    stream: ProductService.instance.getCategoriesWithFallback(),
                    builder: (context, snapshot) {
                      var categories = snapshot.data ?? [];

                      if (categories.isEmpty &&
                          snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _sectionNote(
                                'Live categories are unavailable. Showing starter categories.',
                              ),
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: categories.map((cat) {
                              return _CategoryItem(
                                title: cat.title,
                                image: cat.image,
                                color: cat.color,
                                onTap: () {
                                  if (cat.title == 'Fast Food') {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.fastFood,
                                    );
                                  }
                                  if (cat.title == 'Tiffin') {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.tiffin,
                                    );
                                  }
                                  if (cat.title == 'Spices') {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.spices,
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Popular Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Popular Right Now',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'See All',
                          style: GoogleFonts.outfit(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  StreamBuilder<List<ProductModel>>(
                    stream: ProductService.instance.getPopularProducts(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final products = snapshot.data!;
                      if (products.isEmpty) {
                        return Center(
                          child: Text(
                            'No popular items found',
                            style: GoogleFonts.outfit(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (snapshot.hasError)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _sectionNote(
                                'Popular items could not be loaded from backend. Showing starter picks.',
                              ),
                            ),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            physics: const BouncingScrollPhysics(),
                            child: Row(
                              children: products.map((prod) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 16),
                                  child: PopularFoodCard(
                                    title: prod.name,
                                    category: prod.kind == ProductKind.fastFood
                                        ? 'Fast Food'
                                        : 'Tiffin',
                                    emoji: prod.emoji,
                                    price: '₹${prod.price.toInt()}',
                                    rating: prod.ratingLabel,
                                    accent: prod.kind == ProductKind.fastFood
                                        ? AppColors.primaryRed
                                        : AppColors.primaryOrange,
                                    onTap: () => Navigator.pushNamed(
                                      context,
                                      prod.kind == ProductKind.fastFood
                                          ? AppRoutes.productDetail
                                          : AppRoutes.tiffinDetail,
                                      arguments: prod,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 32),

                  // Promo Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryOrange, Color(0xFFFF9800)],
                      ),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryOrange.withValues(alpha: 0.3),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '20% OFF',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w900,
                            fontSize: 32,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'On your first Tiffin subscription!',
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryOrange,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Subscribe Now'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoStrip(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.lightOrangeBg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: AppColors.primaryBrown,
        ),
      ),
    );
  }

  Widget _sectionNote(String text) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: AppColors.textSecondary,
      ),
    );
  }
}

class _HeaderIdentity extends StatelessWidget {
  final String? userId;
  final VoidCallback onTapLocation;

  const _HeaderIdentity({required this.userId, required this.onTapLocation});

  @override
  Widget build(BuildContext context) {
    if (userId == null) {
      return _IdentityText(
        name: AppStrings.userName,
        address: 'Set your delivery address after sign in',
        onTapLocation: onTapLocation,
      );
    }

    return StreamBuilder<Map<String, dynamic>?>(
      stream: AuthService.instance.getUserDetailsStream(userId!),
      builder: (context, userSnapshot) {
        final name =
            userSnapshot.data?['name'] as String? ?? AppStrings.userName;
        return StreamBuilder<AddressModel?>(
          stream: AuthService.instance.getDefaultAddressStream(userId!),
          builder: (context, addressSnapshot) {
            final address = addressSnapshot.data?.fullAddress;
            return _IdentityText(
              name: name,
              address: address == null || address.isEmpty
                  ? 'Add a default delivery address'
                  : address,
              onTapLocation: onTapLocation,
            );
          },
        );
      },
    );
  }
}

class _IdentityText extends StatelessWidget {
  final String name;
  final String address;
  final VoidCallback onTapLocation;

  const _IdentityText({
    required this.name,
    required this.address,
    required this.onTapLocation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Hello, $name',
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        GestureDetector(
          onTap: onTapLocation,
          child: Row(
            children: [
              const Icon(
                Icons.location_on_rounded,
                size: 14,
                color: Colors.white70,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  address,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w400,
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 14,
                color: Colors.white70,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({
    required this.title,
    required this.image,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String image;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: Text(image, style: const TextStyle(fontSize: 32)),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class PopularFoodCard extends StatelessWidget {
  const PopularFoodCard({
    super.key,
    required this.title,
    required this.category,
    required this.emoji,
    required this.price,
    required this.rating,
    required this.accent,
    required this.onTap,
  });

  final String title;
  final String category;
  final String emoji;
  final String price;
  final String rating;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              child: Container(
                height: 140,
                width: 200,
                color: accent.withValues(alpha: 0.12),
                alignment: Alignment.center,
                child: Text(emoji, style: const TextStyle(fontSize: 72)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.starYellow,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '$rating · $category',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w400,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: accent,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accent,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
