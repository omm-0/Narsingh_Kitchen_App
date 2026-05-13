import 'package:cloud_firestore/cloud_firestore.dart';

enum OrderStatus { pending, preparing, outForDelivery, delivered, cancelled }

class OrderStatusEvent {
  final OrderStatus status;
  final String title;
  final String message;
  final DateTime createdAt;

  const OrderStatusEvent({
    required this.status,
    required this.title,
    required this.message,
    required this.createdAt,
  });

  factory OrderStatusEvent.fromMap(Map<String, dynamic> json) {
    return OrderStatusEvent(
      status: _statusFromName(json['status'] ?? 'pending'),
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      createdAt: _readDateTime(json['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'status': status.name,
      'title': title,
      'message': message,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}

class OrderModel {
  final String id;
  final String orderCode;
  final String userId;
  final String userName;
  final List<Map<String, dynamic>> items;
  final double subtotalAmount;
  final double deliveryFee;
  final double taxAmount;
  final double discountAmount;
  final double totalAmount;
  final String paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String deliveryAddress;
  final List<OrderStatusEvent> statusTimeline;

  OrderModel({
    required this.id,
    required this.orderCode,
    required this.userId,
    required this.userName,
    required this.items,
    required this.subtotalAmount,
    required this.deliveryFee,
    required this.taxAmount,
    required this.discountAmount,
    required this.totalAmount,
    required this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.deliveryAddress,
    required this.statusTimeline,
  });

  factory OrderModel.fromFirestore(Map<String, dynamic> json, String docId) {
    final createdAt = _readDateTime(json['createdAt']);
    final status = _statusFromName(json['status'] ?? 'pending');
    final storedTimeline = (json['statusTimeline'] as List<dynamic>? ?? [])
        .whereType<Map<String, dynamic>>()
        .map(OrderStatusEvent.fromMap)
        .toList();

    return OrderModel(
      id: docId,
      orderCode: json['orderCode'] ?? _fallbackOrderCode(docId),
      userId: json['userId'] ?? '',
      userName: json['userName'] ?? 'Customer',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      subtotalAmount: (json['subtotalAmount'] ?? json['totalAmount'] ?? 0.0)
          .toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0.0).toDouble(),
      taxAmount: (json['taxAmount'] ?? 0.0).toDouble(),
      discountAmount: (json['discountAmount'] ?? 0.0).toDouble(),
      totalAmount: (json['totalAmount'] ?? 0.0).toDouble(),
      paymentMethod: json['paymentMethod'] ?? 'UPI',
      status: status,
      createdAt: createdAt,
      updatedAt: json['updatedAt'] == null
          ? null
          : _readDateTime(json['updatedAt']),
      deliveryAddress: json['deliveryAddress'] ?? '',
      statusTimeline: storedTimeline.isNotEmpty
          ? storedTimeline
          : _defaultTimeline(status: status, createdAt: createdAt),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderCode': orderCode,
      'userId': userId,
      'userName': userName,
      'items': items,
      'subtotalAmount': subtotalAmount,
      'deliveryFee': deliveryFee,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'totalAmount': totalAmount,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt == null ? null : Timestamp.fromDate(updatedAt!),
      'deliveryAddress': deliveryAddress,
      'statusTimeline': statusTimeline.map((event) => event.toMap()).toList(),
    };
  }

  String get shortCode => '#$orderCode';
}

OrderStatus _statusFromName(String name) {
  return OrderStatus.values.firstWhere(
    (e) => e.name == name,
    orElse: () => OrderStatus.pending,
  );
}

DateTime _readDateTime(dynamic value) {
  if (value is Timestamp) return value.toDate();
  if (value is DateTime) return value;
  return DateTime.now();
}

String _fallbackOrderCode(String docId) {
  final clean = docId.replaceAll('-', '').toUpperCase();
  final suffix = clean.length >= 8
      ? clean.substring(0, 8)
      : clean.padRight(8, '0');
  return 'NK-$suffix';
}

List<OrderStatusEvent> _defaultTimeline({
  required OrderStatus status,
  required DateTime createdAt,
}) {
  final timeline = <OrderStatusEvent>[
    OrderStatusEvent(
      status: OrderStatus.pending,
      title: 'Order placed',
      message: 'The kitchen has received the order.',
      createdAt: createdAt,
    ),
  ];

  if (status.index >= OrderStatus.preparing.index &&
      status != OrderStatus.cancelled) {
    timeline.add(
      OrderStatusEvent(
        status: OrderStatus.preparing,
        title: 'Kitchen started preparing',
        message: 'Your items are now being prepared.',
        createdAt: createdAt,
      ),
    );
  }

  if (status.index >= OrderStatus.outForDelivery.index &&
      status != OrderStatus.cancelled) {
    timeline.add(
      OrderStatusEvent(
        status: OrderStatus.outForDelivery,
        title: 'Order dispatched',
        message: 'The order is on the way to the customer.',
        createdAt: createdAt,
      ),
    );
  }

  if (status == OrderStatus.delivered) {
    timeline.add(
      OrderStatusEvent(
        status: OrderStatus.delivered,
        title: 'Delivered successfully',
        message: 'The order was completed successfully.',
        createdAt: createdAt,
      ),
    );
  }

  if (status == OrderStatus.cancelled) {
    timeline.add(
      OrderStatusEvent(
        status: OrderStatus.cancelled,
        title: 'Order cancelled',
        message: 'This order was cancelled before completion.',
        createdAt: createdAt,
      ),
    );
  }

  return timeline;
}
