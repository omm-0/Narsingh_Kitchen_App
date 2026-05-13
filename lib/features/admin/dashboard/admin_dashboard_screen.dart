import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/admin_service.dart';
import '../../../models/order_model.dart';
import '../../../models/product_model.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader(context)),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _buildStatCards(),
                const SizedBox(height: 20),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                _buildRecentOrders(context),
                const SizedBox(height: 20),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back, Admin 👋',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.whiteSurface,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Here's what's happening today",
                  style: GoogleFonts.poppins(
                    fontSize: 13,
                    color: AppColors.whiteSurface.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          const CircleAvatar(
            radius: 22,
            backgroundColor: AppColors.whiteSurface,
            child: Text('👨‍💼', style: TextStyle(fontSize: 22)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCards() {
    return StreamBuilder<Map<String, dynamic>>(
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

        final stats = [
          _StatData(
            'Orders Today',
            statsData['totalOrders'].toString(),
            Icons.receipt_long_rounded,
            const Color(0xFFFFE0E0),
            AppColors.primaryRed,
          ),
          _StatData(
            'Revenue',
            '₹${(statsData['revenue'] as double).toStringAsFixed(0)}',
            Icons.currency_rupee_rounded,
            const Color(0xFFE8F5E9),
            AppColors.successGreen,
          ),
          _StatData(
            'Delivered',
            statsData['deliveredOrders'].toString(),
            Icons.check_circle_outline_rounded,
            const Color(0xFFE3F2FD),
            Colors.blue,
          ),
          _StatData(
            'Pending',
            statsData['pendingOrders'].toString(),
            Icons.hourglass_top_rounded,
            const Color(0xFFFFF8E1),
            AppColors.primaryOrange,
          ),
        ];

        return GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: stats.map((s) => _StatCard(data: s)).toList(),
        );
      },
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      _QuickAction(
        'Add Fast Food',
        Icons.fastfood_rounded,
        AppRoutes.addFastFood,
        null,
      ),
      _QuickAction(
        'Add Tiffin',
        Icons.lunch_dining_rounded,
        AppRoutes.addTiffin,
        null,
      ),
      _QuickAction('Add Spice', Icons.grass_rounded, AppRoutes.addSpice, null),
      _QuickAction(
        'Add Promo',
        Icons.local_offer_rounded,
        AppRoutes.managePromos,
        null,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: actions
                .map(
                  (a) => Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ActionChip(
                      avatar: Icon(
                        a.icon,
                        size: 16,
                        color: AppColors.primaryRed,
                      ),
                      label: Text(
                        a.label,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      backgroundColor: AppColors.lightPinkBg,
                      side: const BorderSide(color: Color(0xFFFFCDD2)),
                      onPressed: () => Navigator.pushNamed(context, a.route),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentOrders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Orders',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
            TextButton(
              onPressed: () =>
                  Navigator.pushNamed(context, AppRoutes.adminOrders),
              child: Text(
                'View All',
                style: GoogleFonts.poppins(
                  color: AppColors.primaryRed,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        StreamBuilder<List<OrderModel>>(
          stream: AdminService.instance.getAllOrders(),
          builder: (context, snapshot) {
            if (!snapshot.hasData &&
                snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            final orders = snapshot.data!.take(5).toList();
            if (orders.isEmpty) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'No recent orders',
                    style: GoogleFonts.poppins(color: AppColors.textSecondary),
                  ),
                ),
              );
            }
            return Column(
              children: [
                if (snapshot.hasError)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Text(
                      'Recent orders could not be fully loaded from backend.',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                ...orders.map((o) => _OrderCard(order: o)),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color bg;
  final Color iconColor;
  const _StatData(this.label, this.value, this.icon, this.bg, this.iconColor);
}

class _StatCard extends StatelessWidget {
  final _StatData data;
  const _StatCard({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: data.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, color: data.iconColor, size: 20),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.value,
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                data.label,
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickAction {
  final String label;
  final IconData icon;
  final String route;
  final ProductKind? kind;
  const _QuickAction(this.label, this.icon, this.route, this.kind);
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.orderDetail,
        arguments: order.id,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.shortCode,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    order.userName,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.items.length} item${order.items.length > 1 ? 's' : ''} · ₹${order.totalAmount.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            _StatusChip(status: order.status),
          ],
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;
    String label;
    switch (status) {
      case OrderStatus.pending:
        bg = const Color(0xFFFFF3E0);
        fg = AppColors.primaryOrange;
        label = 'Pending';
      case OrderStatus.preparing:
        bg = const Color(0xFFE3F2FD);
        fg = Colors.blue;
        label = 'Preparing';
      case OrderStatus.outForDelivery:
        bg = const Color(0xFFE8EAF6);
        fg = Colors.indigo;
        label = 'On Way';
      case OrderStatus.delivered:
        bg = const Color(0xFFE8F5E9);
        fg = AppColors.successGreen;
        label = 'Delivered';
      case OrderStatus.cancelled:
        bg = const Color(0xFFFFEBEE);
        fg = AppColors.primaryRed;
        label = 'Cancelled';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
