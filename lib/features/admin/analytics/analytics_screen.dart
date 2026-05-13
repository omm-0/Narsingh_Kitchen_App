import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/admin_service.dart';

class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<Map<String, dynamic>>(
        stream: AdminService.instance.getDashboardStats(),
        builder: (context, snapshot) {
          final statsData =
              snapshot.data ??
              {
                'totalOrders': 0,
                'revenue': 0.0,
                'pendingOrders': 0,
                'deliveredOrders': 0,
              };

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _header(context)),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    if (snapshot.hasError)
                      Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.lightOrangeBg,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Text(
                          'Analytics backend is unavailable. Numbers below may be incomplete.',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryBrown,
                          ),
                        ),
                      ),
                    _topStats(statsData),
                    const SizedBox(height: 20),
                    _weeklyChart(
                      statsData['weeklyOrders'] as List<dynamic>? ?? [],
                    ),
                    const SizedBox(height: 20),
                    _topProducts(
                      statsData['topProducts'] as List<dynamic>? ?? [],
                    ),
                    const SizedBox(height: 20),
                  ]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Text(
            'Analytics',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteSurface,
            ),
          ),
          const Spacer(),
          Icon(
            Icons.bar_chart_rounded,
            color: AppColors.whiteSurface.withValues(alpha: 0.8),
          ),
        ],
      ),
    );
  }

  Widget _topStats(Map<String, dynamic> data) {
    final stats = [
      (
        'Revenue',
        '₹${(data['revenue'] as double? ?? 0.0).toStringAsFixed(0)}',
        Icons.currency_rupee_rounded,
        AppColors.successGreen,
      ),
      (
        'Orders',
        (data['totalOrders'] ?? 0).toString(),
        Icons.receipt_long_rounded,
        Colors.blue,
      ),
      (
        'Customers',
        (data['customerCount'] ?? 0).toString(),
        Icons.people_rounded,
        AppColors.primaryOrange,
      ),
    ];

    return Row(
      children: stats.map((s) {
        return Expanded(
          child: Container(
            margin: EdgeInsets.only(right: s == stats.last ? 0 : 10),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: AppColors.cardShadow,
            ),
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Icon(s.$3, color: s.$4, size: 22),
                const SizedBox(height: 6),
                Text(
                  s.$2,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  s.$1,
                  style: GoogleFonts.poppins(
                    fontSize: 10,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _weeklyChart(List<dynamic> data) {
    if (data.isEmpty) return const SizedBox.shrink();
    final maxOrders = data
        .map((d) => d['orders'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Weekly Orders',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: data.map((d) {
                final fraction = maxOrders > 0
                    ? (d['orders'] as int) / maxOrders
                    : 0.0;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      '${d['orders']}',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeOut,
                      width: 28,
                      height: 100 * fraction + 4,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.primaryRed, Color(0xFFEF9A9A)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      d['day'] as String,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topProducts(List<dynamic> products) {
    if (products.isEmpty) return const SizedBox.shrink();
    final maxOrders = products
        .map((p) => p['orders'] as int)
        .reduce((a, b) => a > b ? a : b);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Selling Products',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
          ...products.asMap().entries.map((entry) {
            final i = entry.key;
            final p = entry.value;
            final fraction = maxOrders > 0
                ? (p['orders'] as int) / maxOrders
                : 0.0;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Text(
                    '${i + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    p['emoji'] as String,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          p['name'] as String,
                          style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: fraction,
                            backgroundColor: AppColors.lightGrayBg,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primaryRed,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    '${p['orders']}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
