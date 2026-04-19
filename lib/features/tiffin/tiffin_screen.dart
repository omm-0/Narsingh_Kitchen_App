import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../data/dummy_data.dart';
import '../../models/product_model.dart';
import '../../models/subscription_model.dart';

class TiffinScreen extends StatefulWidget {
  const TiffinScreen({super.key});

  @override
  State<TiffinScreen> createState() => _TiffinScreenState();
}

class _TiffinScreenState extends State<TiffinScreen> {
  bool _monthly = true;
  String _searchQuery = '';

  ProductModel get _today => DummyData.todayTiffinMeal;

  @override
  Widget build(BuildContext context) {
    final plans = DummyData.subscriptionPlans;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        clipBehavior: Clip.none,
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
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primaryOrange,
                          AppColors.primaryOrange.withValues(alpha: 0.78),
                          AppColors.lightOrangeBg.withValues(alpha: 0.95),
                        ],
                      ),
                    ),
                    child: SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 8, 8, 22),
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
                                    '🍱 Tiffin Service',
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
                            AnimatedSwitcher(
                              duration: const Duration(milliseconds: 280),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, anim) =>
                                  FadeTransition(
                                    opacity: anim,
                                    child: SlideTransition(
                                      position: Tween<Offset>(
                                        begin: const Offset(0.04, 0),
                                        end: Offset.zero,
                                      ).animate(anim),
                                      child: child,
                                    ),
                                  ),
                              child: Container(
                                key: ValueKey<bool>(_monthly),
                                decoration: BoxDecoration(
                                  color: AppColors.whiteSurface.withValues(
                                    alpha: 0.14,
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                padding: const EdgeInsets.all(4),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: _toggleSide(
                                        label: 'Monthly',
                                        selected: _monthly,
                                        onTap: () =>
                                            setState(() => _monthly = true),
                                      ),
                                    ),
                                    Expanded(
                                      child: _toggleSide(
                                        label: 'One-Time',
                                        selected: !_monthly,
                                        onTap: () =>
                                            setState(() => _monthly = false),
                                      ),
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
                ),
              ),
              SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, _monthly ? 110 : 28),
                sliver: SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        "Today's Menu",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Material(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(22),
                        elevation: 0,
                        shadowColor: Colors.black26,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          customBorder: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.tiffinDetail,
                            arguments: _today.id,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(18),
                                  child: Container(
                                    width: 82,
                                    height: 82,
                                    color: AppColors.lightOrangeBg,
                                    alignment: Alignment.center,
                                    child: Hero(
                                      tag: 'tiffin-${_today.id}',
                                      child: Material(
                                        type: MaterialType.transparency,
                                        child: Text(
                                          _today.emoji,
                                          style: const TextStyle(fontSize: 40),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _today.name,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        _today.subtitle,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Wrap(
                                        spacing: 8,
                                        runSpacing: 8,
                                        children: [
                                          _tag(
                                            '🌱 Pure Veg',
                                            AppColors.successGreen,
                                            AppColors.lightGrayBg,
                                          ),
                                          _tag(
                                            '🔥 Fresh Daily',
                                            AppColors.primaryOrange,
                                            AppColors.lightOrangeBg,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.successGreen
                                              .withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(
                                            50,
                                          ),
                                        ),
                                        child: Text(
                                          '✅ Healthy',
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                            color: AppColors.successGreen,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        '₹${_today.price.toStringAsFixed(0)}/meal',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16,
                                          color: AppColors.primaryOrange,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.chevron_right_rounded,
                                  color: AppColors.textSecondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Subscription Plans',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 12),
                      ...plans.map(
                        (plan) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _planPreviewCard(plan),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Material(
                        color: AppColors.whiteSurface,
                        borderRadius: BorderRadius.circular(22),
                        elevation: 0,
                        shadowColor: Colors.black26,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(22),
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.deliverySlot,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '🕒 Lunch: 12–1 PM • Dinner: 7–8 PM',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  'Change',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                    color: AppColors.primaryOrange,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (_monthly)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 280),
                curve: Curves.easeOutCubic,
                offset: _monthly ? Offset.zero : const Offset(0, 1.2),
                child: Material(
                  elevation: 16,
                  color: AppColors.whiteSurface,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                      child: SizedBox(
                        height: 54,
                        width: double.infinity,
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
                          child: const Text('Subscribe monthly'),
                        ),
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

  Widget _toggleSide({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: selected ? AppColors.whiteSurface : Colors.transparent,
        boxShadow: selected
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(50),
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Center(
              child: Text(
                label,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                  color: selected
                      ? AppColors.primaryOrange
                      : AppColors.whiteSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _tag(String label, Color fg, Color bg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontWeight: FontWeight.w500,
          fontSize: 11,
          color: fg,
        ),
      ),
    );
  }

  Widget _planPreviewCard(SubscriptionModel plan) {
    return Material(
      color: AppColors.whiteSurface,
      borderRadius: BorderRadius.circular(22),
      elevation: 0,
      shadowColor: Colors.black26,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => Navigator.pushNamed(context, AppRoutes.subscriptionPlan),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            boxShadow: AppColors.cardShadow,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      plan.title,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                        fontSize: 17,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    plan.savingsLabel,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.successGreen,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                plan.mealsLabel,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '₹${plan.price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Compare plans →',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.primaryOrange,
                    ),
                  ),
                ],
              ),
            ],
          ),
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
          title: const Text('Search Tiffin'),
          content: TextField(
            onChanged: (v) => query = v,
            decoration: const InputDecoration(
              hintText: 'Search by meal type...',
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
