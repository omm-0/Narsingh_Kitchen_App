import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/admin_dummy_data.dart';

class AdminOrdersScreen extends StatefulWidget {
  const AdminOrdersScreen({super.key});

  @override
  State<AdminOrdersScreen> createState() => _AdminOrdersScreenState();
}

class _AdminOrdersScreenState extends State<AdminOrdersScreen> {
  OrderStatus? _filter;

  List<AdminOrder> get _filtered => _filter == null
      ? AdminDummyData.orders
      : AdminDummyData.orders.where((o) => o.status == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          _buildFilterChips(),
          Expanded(
            child: _filtered.isEmpty
                ? Center(
                    child: Text('No orders found',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: _filtered.length,
                    itemBuilder: (_, i) => _OrderTile(order: _filtered[i]),
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
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${AdminDummyData.orders.length} total',
              style: GoogleFonts.poppins(color: AppColors.whiteSurface, fontSize: 12),
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
              label: Text(e.key,
                  style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: selected ? AppColors.whiteSurface : AppColors.textPrimary)),
              selected: selected,
              onSelected: (_) => setState(() => _filter = e.value),
              selectedColor: AppColors.primaryRed,
              backgroundColor: AppColors.whiteSurface,
              checkmarkColor: AppColors.whiteSurface,
              side: BorderSide(color: selected ? AppColors.primaryRed : AppColors.dividerGray),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final AdminOrder order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, AppRoutes.orderDetail, arguments: order.id),
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
                Text(order.id,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700, fontSize: 14, color: AppColors.textPrimary)),
                _statusChip(order.status),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.person_outline_rounded, size: 14, color: AppColors.textSecondary),
                const SizedBox(width: 4),
                Text(order.customerName,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                    '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text('₹${order.total.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                        fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.primaryRed)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    Color bg; Color fg; String label;
    switch (status) {
      case OrderStatus.pending:
        bg = const Color(0xFFFFF3E0); fg = AppColors.primaryOrange; label = 'Pending';
      case OrderStatus.preparing:
        bg = const Color(0xFFE3F2FD); fg = Colors.blue; label = 'Preparing';
      case OrderStatus.outForDelivery:
        bg = const Color(0xFFE8EAF6); fg = Colors.indigo; label = 'On Way';
      case OrderStatus.delivered:
        bg = const Color(0xFFE8F5E9); fg = AppColors.successGreen; label = 'Delivered';
      case OrderStatus.cancelled:
        bg = const Color(0xFFFFEBEE); fg = AppColors.primaryRed; label = 'Cancelled';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: GoogleFonts.poppins(fontSize: 11, fontWeight: FontWeight.w600, color: fg)),
    );
  }
}
