import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/constants/order_ui.dart';
import '../../core/services/order_service.dart';
import '../../models/order_model.dart';

class OrdersScreen extends StatelessWidget {
  final bool embeddedInNav;
  const OrdersScreen({super.key, this.embeddedInNav = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: embeddedInNav
          ? null
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: AppColors.textPrimary,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              title: Text(
                'My Orders',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w800,
                  fontSize: 24,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (embeddedInNav)
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'My Orders',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            Expanded(
              child: StreamBuilder<List<OrderModel>>(
                stream: OrderService.instance.getMyOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryRed,
                      ),
                    );
                  }

                  final orders = snapshot.data ?? [];

                  if (orders.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                    physics: const BouncingScrollPhysics(),
                    itemCount: orders.length,
                    separatorBuilder: (context, index) =>
                        const SizedBox(height: 16),
                    itemBuilder: (context, index) =>
                        _OrderCard(order: orders[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: AppColors.primaryRed.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              size: 64,
              color: AppColors.primaryRed,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'No orders yet',
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your delicious journey starts here.\nPlace your first order now!',
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w400,
              fontSize: 16,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;
  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = OrderUi.statusColor(order.status);
    final statusText = OrderUi.statusLabel(order.status);
    final dateStr = DateFormat(
      'MMM dd, yyyy • hh:mm a',
    ).format(order.createdAt);

    // Get first item for emoji and name summary
    final firstItem = order.items.isNotEmpty ? order.items.first : null;
    final emoji = firstItem?['emoji'] ?? '🍔';
    final itemName = firstItem?['name'] ?? 'Order Item';
    final extraItems = order.items.length - 1;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRoutes.userOrderDetail,
                arguments: order.id,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          emoji,
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              extraItems > 0
                                  ? '$itemName +$extraItems more'
                                  : itemName,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w700,
                                fontSize: 17,
                                color: AppColors.textPrimary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              dateStr,
                              style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: statusColor.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                statusText,
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12,
                                  color: statusColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '₹${order.totalAmount.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${order.items.length} items',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1, color: AppColors.dividerGray),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Order ID: ${order.shortCode}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            order.status == OrderStatus.delivered
                                ? 'Reorder'
                                : 'Track order',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.primaryRed,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            order.status == OrderStatus.delivered
                                ? Icons.refresh_rounded
                                : Icons.arrow_forward_rounded,
                            size: 16,
                            color: AppColors.primaryRed,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
