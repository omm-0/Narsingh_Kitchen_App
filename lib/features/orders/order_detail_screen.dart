import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/order_ui.dart';
import '../../core/services/order_service.dart';
import '../../models/order_model.dart';

class UserOrderDetailScreen extends StatelessWidget {
  final String orderId;

  const UserOrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<OrderModel?>(
      stream: OrderService.instance.getOrderById(orderId),
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
            backgroundColor: AppColors.background,
            appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0),
            body: Center(
              child: Text(
                'Order not found',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          );
        }

        final statusColor = OrderUi.statusColor(order.status);

        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text(
              order.shortCode,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.whiteSurface,
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: AppColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: Icon(
                            OrderUi.statusIcon(order.status),
                            color: statusColor,
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                OrderUi.statusHeadline(order.status),
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 22,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                OrderUi.statusDescription(order.status),
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        _factChip(
                          Icons.schedule_rounded,
                          DateFormat('dd MMM, hh:mm a').format(order.createdAt),
                        ),
                        _factChip(Icons.payments_rounded, order.paymentMethod),
                        _factChip(
                          Icons.currency_rupee_rounded,
                          '₹${order.totalAmount.toStringAsFixed(0)}',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _sectionCard(
                title: 'Live status',
                child: Column(
                  children: order.statusTimeline.reversed.map((event) {
                    final isCurrent = event.status == order.status;
                    final color = OrderUi.statusColor(event.status);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                width: 14,
                                height: 14,
                                decoration: BoxDecoration(
                                  color: isCurrent
                                      ? color
                                      : color.withValues(alpha: 0.25),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              Container(
                                width: 2,
                                height: 44,
                                color: AppColors.dividerGray,
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  event.title,
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  event.message,
                                  style: GoogleFonts.outfit(
                                    fontSize: 13,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  DateFormat(
                                    'dd MMM, hh:mm a',
                                  ).format(event.createdAt),
                                  style: GoogleFonts.outfit(
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
              const SizedBox(height: 18),
              _sectionCard(
                title: 'Delivery details',
                child: Column(
                  children: [
                    _infoRow(Icons.location_on_rounded, order.deliveryAddress),
                    const SizedBox(height: 12),
                    _infoRow(
                      Icons.receipt_rounded,
                      '${order.items.length} item${order.items.length == 1 ? '' : 's'} in this order',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              _sectionCard(
                title: 'Items ordered',
                child: Column(
                  children: order.items.map((item) {
                    final qty = item['quantity'] ?? 1;
                    final price =
                        ((item['unitPrice'] ?? item['price'] ?? 0) as num)
                            .toDouble();
                    final variant = item['variantLabel'] as String?;
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Text(
                            item['productEmoji'] ?? item['emoji'] ?? '🍽️',
                            style: const TextStyle(fontSize: 26),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['productName'] ?? item['name'] ?? 'Item',
                                  style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                if (variant != null && variant.isNotEmpty)
                                  Text(
                                    variant,
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          Text(
                            '$qty x ₹${price.toStringAsFixed(0)}',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 18),
              _sectionCard(
                title: 'Bill summary',
                child: Column(
                  children: [
                    _billRow('Subtotal', order.subtotalAmount),
                    _billRow('Delivery fee', order.deliveryFee),
                    _billRow('GST', order.taxAmount),
                    _billRow(
                      'Discount',
                      -order.discountAmount,
                      color: order.discountAmount > 0
                          ? AppColors.successGreen
                          : AppColors.textPrimary,
                    ),
                    const Divider(height: 22),
                    _billRow('Grand total', order.totalAmount, bold: true),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _sectionCard({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w800,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 14),
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
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.outfit(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _billRow(
    String label,
    double value, {
    bool bold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.outfit(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w500,
              fontSize: bold ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            '₹${value.toStringAsFixed(0)}',
            style: GoogleFonts.outfit(
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              fontSize: bold ? 18 : 14,
              color: color ?? AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _factChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: AppColors.primaryRed),
          const SizedBox(width: 8),
          Text(
            text,
            style: GoogleFonts.outfit(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
