import 'package:flutter/material.dart';

import '../../models/order_model.dart';
import 'app_colors.dart';

abstract final class OrderUi {
  OrderUi._();

  static String statusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Placed';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.outForDelivery:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  static String statusHeadline(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order received by kitchen';
      case OrderStatus.preparing:
        return 'Your food is being prepared';
      case OrderStatus.outForDelivery:
        return 'Rider is heading to you';
      case OrderStatus.delivered:
        return 'Order completed';
      case OrderStatus.cancelled:
        return 'Order cancelled';
    }
  }

  static String statusDescription(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'We have lined it up and will start preparing shortly.';
      case OrderStatus.preparing:
        return 'The kitchen team is packing everything for dispatch.';
      case OrderStatus.outForDelivery:
        return 'Track the final leg while the order is on route.';
      case OrderStatus.delivered:
        return 'The delivery has been closed successfully.';
      case OrderStatus.cancelled:
        return 'This order is no longer active.';
    }
  }

  static Color statusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.primaryOrange;
      case OrderStatus.preparing:
        return const Color(0xFF1976D2);
      case OrderStatus.outForDelivery:
        return const Color(0xFF5E35B1);
      case OrderStatus.delivered:
        return AppColors.successGreen;
      case OrderStatus.cancelled:
        return AppColors.primaryRed;
    }
  }

  static IconData statusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.receipt_long_rounded;
      case OrderStatus.preparing:
        return Icons.soup_kitchen_rounded;
      case OrderStatus.outForDelivery:
        return Icons.delivery_dining_rounded;
      case OrderStatus.delivered:
        return Icons.check_circle_rounded;
      case OrderStatus.cancelled:
        return Icons.cancel_rounded;
    }
  }
}
