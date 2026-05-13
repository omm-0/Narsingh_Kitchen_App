import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/order_ui.dart';
import '../../../core/services/admin_service.dart';
import '../../../models/order_model.dart';

class OrderDetailScreen extends StatefulWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  Future<void> _updateStatus(OrderStatus status) async {
    await AdminService.instance.updateOrderStatus(widget.orderId, status);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Status updated to ${OrderUi.statusLabel(status)}',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: OrderUi.statusColor(status),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: AdminService.instance.getOrderById(widget.orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(color: AppColors.primaryRed),
            ),
          );
        }

        final order = snapshot.data;
        if (order == null) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Center(
              child: Text(
                'Order not found',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        }

        return Scaffold(
          backgroundColor: AppColors.background,
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 180,
                pinned: true,
                backgroundColor: AppColors.primaryRed,
                foregroundColor: AppColors.whiteSurface,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFFB71C1C), AppColors.primaryRed],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    padding: const EdgeInsets.fromLTRB(20, 86, 20, 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          order.shortCode,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 24,
                            color: AppColors.whiteSurface,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          OrderUi.statusHeadline(order.status),
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            color: AppColors.whiteSurface.withValues(
                              alpha: 0.92,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            _headerChip(OrderUi.statusLabel(order.status)),
                            const SizedBox(width: 10),
                            _headerChip(
                              '₹${order.totalAmount.toStringAsFixed(0)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.all(16),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    _sectionCard(
                      'Pipeline control',
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: OrderStatus.values.map((status) {
                              final selected = order.status == status;
                              return ChoiceChip(
                                label: Text(OrderUi.statusLabel(status)),
                                selected: selected,
                                selectedColor: OrderUi.statusColor(status),
                                labelStyle: GoogleFonts.poppins(
                                  color: selected
                                      ? AppColors.whiteSurface
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                                onSelected: (_) => _updateStatus(status),
                                backgroundColor: AppColors.background,
                                side: BorderSide(
                                  color: selected
                                      ? OrderUi.statusColor(status)
                                      : AppColors.dividerGray,
                                ),
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 14),
                          Row(
                            children: [
                              Expanded(
                                child: _primaryAction(
                                  label: 'Mark Preparing',
                                  onTap: order.status == OrderStatus.pending
                                      ? () =>
                                            _updateStatus(OrderStatus.preparing)
                                      : null,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _primaryAction(
                                  label: 'Dispatch',
                                  color: const Color(0xFF5E35B1),
                                  onTap: order.status == OrderStatus.preparing
                                      ? () => _updateStatus(
                                          OrderStatus.outForDelivery,
                                        )
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sectionCard(
                      'Customer',
                      Column(
                        children: [
                          _infoRow(Icons.person_rounded, order.userName),
                          const SizedBox(height: 10),
                          _infoRow(
                            Icons.location_on_rounded,
                            order.deliveryAddress,
                          ),
                          const SizedBox(height: 10),
                          _infoRow(Icons.payments_rounded, order.paymentMethod),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sectionCard(
                      'Status timeline',
                      Column(
                        children: order.statusTimeline.reversed.map((event) {
                          final color = OrderUi.statusColor(event.status);
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: AppColors.dividerGray,
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        event.title,
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 14,
                                          color: AppColors.textPrimary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        event.message,
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat(
                                          'dd MMM, hh:mm a',
                                        ).format(event.createdAt),
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: color,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sectionCard(
                      'Items',
                      Column(
                        children: order.items.map((item) {
                          final qty = item['quantity'] ?? 1;
                          final price =
                              ((item['unitPrice'] ?? item['price'] ?? 0) as num)
                                  .toDouble();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Row(
                              children: [
                                Text(
                                  item['productEmoji'] ??
                                      item['emoji'] ??
                                      '🍽️',
                                  style: const TextStyle(fontSize: 24),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item['productName'] ??
                                        item['name'] ??
                                        'Item',
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 13,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                ),
                                Text(
                                  '$qty x ₹${price.toStringAsFixed(0)}',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    _sectionCard(
                      'Price breakdown',
                      Column(
                        children: [
                          _priceRow('Subtotal', order.subtotalAmount),
                          _priceRow('Delivery fee', order.deliveryFee),
                          _priceRow('GST', order.taxAmount),
                          _priceRow(
                            'Discount',
                            -order.discountAmount,
                            color: order.discountAmount > 0
                                ? AppColors.successGreen
                                : AppColors.textPrimary,
                          ),
                          const Divider(),
                          _priceRow(
                            'Total Amount',
                            order.totalAmount,
                            bold: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _primaryAction(
                            label: 'Deliver',
                            color: AppColors.successGreen,
                            onTap: order.status != OrderStatus.delivered
                                ? () => _updateStatus(OrderStatus.delivered)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: order.status == OrderStatus.cancelled
                                ? null
                                : () => _updateStatus(OrderStatus.cancelled),
                            icon: const Icon(Icons.cancel_rounded, size: 18),
                            label: Text(
                              'Cancel',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.primaryRed,
                              side: const BorderSide(
                                color: AppColors.primaryRed,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                              minimumSize: const Size.fromHeight(52),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                  ]),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _headerChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.whiteSurface,
        ),
      ),
    );
  }

  Widget _sectionCard(String title, Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(18),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: AppColors.primaryRed),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _priceRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: bold ? AppColors.textPrimary : AppColors.textSecondary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
              color:
                  color ??
                  (bold ? AppColors.primaryRed : AppColors.textPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _primaryAction({
    required String label,
    required VoidCallback? onTap,
    Color color = AppColors.primaryRed,
  }) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        disabledBackgroundColor: AppColors.dividerGray,
        foregroundColor: AppColors.whiteSurface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        minimumSize: const Size.fromHeight(52),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
      ),
    );
  }
}
