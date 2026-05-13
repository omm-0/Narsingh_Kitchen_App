import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/constants/order_ui.dart';
import '../../../core/services/admin_service.dart';
import '../../../models/order_model.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  OrderStatus? _filter;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<OrderModel>>(
        stream: AdminService.instance.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final allOrders = snapshot.data ?? [];
          final filteredOrders = _filter == null
              ? allOrders
              : allOrders.where((o) => o.status == _filter).toList();

          return Column(
            children: [
              _buildHeader(context, allOrders.length),
              _buildFilterChips(),
              Expanded(
                child: filteredOrders.isEmpty
                    ? Center(
                        child: Text(
                          'No orders found',
                          style: GoogleFonts.poppins(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                        itemCount: filteredOrders.length,
                        itemBuilder: (_, i) =>
                            _OrderTile(order: filteredOrders[i]),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int totalCount) {
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
            'Orders',
            style: GoogleFonts.poppins(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: AppColors.whiteSurface,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '$totalCount total',
              style: GoogleFonts.poppins(
                color: AppColors.whiteSurface,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    final filters = <String, OrderStatus?>{
      'All': null,
      'Pending': OrderStatus.pending,
      'Preparing': OrderStatus.preparing,
      'On Way': OrderStatus.outForDelivery,
      'Delivered': OrderStatus.delivered,
      'Cancelled': OrderStatus.cancelled,
    };

    return SizedBox(
      height: 52,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: filters.entries.map((e) {
          final selected = _filter == e.value;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                e.key,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? AppColors.whiteSurface
                      : AppColors.textPrimary,
                ),
              ),
              selected: selected,
              onSelected: (_) => setState(() => _filter = e.value),
              selectedColor: AppColors.primaryRed,
              backgroundColor: AppColors.whiteSurface,
              checkmarkColor: AppColors.whiteSurface,
              side: BorderSide(
                color: selected ? AppColors.primaryRed : AppColors.dividerGray,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderModel order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        AppRoutes.orderDetail,
        arguments: order.id,
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: AppColors.whiteSurface,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppColors.cardShadow,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order.shortCode,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                    color: AppColors.textPrimary,
                  ),
                ),
                _statusChip(order.status),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(
                  Icons.person_outline_rounded,
                  size: 14,
                  color: AppColors.textSecondary,
                ),
                const SizedBox(width: 4),
                Text(
                  order.userName,
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              OrderUi.statusHeadline(order.status),
              style: GoogleFonts.poppins(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '₹${order.totalAmount.toStringAsFixed(2)}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryRed,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    final fg = OrderUi.statusColor(status);
    final bg = fg.withValues(alpha: 0.12);
    final label = OrderUi.statusLabel(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
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
