import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/order_model.dart';

class AdminService {
  static final AdminService instance = AdminService._();
  AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Stats ───────────────────────────────────────────────────────────────
  Stream<Map<String, dynamic>> getDashboardStats() {
    return _firestore.collection('orders').snapshots().asyncMap((
      snapshot,
    ) async {
      double revenue = 0;
      int pending = 0;
      int delivered = 0;

      // Weekly orders data map: day name -> count
      final weeklyMap = <String, int>{};
      final now = DateTime.now();
      for (int i = 0; i < 7; i++) {
        final day = now.subtract(Duration(days: i));
        final dayName = [
          'Mon',
          'Tue',
          'Wed',
          'Thu',
          'Fri',
          'Sat',
          'Sun',
        ][day.weekday - 1];
        weeklyMap[dayName] = 0;
      }

      // Top products map: emoji+name -> count
      final productMap = <String, Map<String, dynamic>>{};

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final status = data['status'] ?? 'pending';
        final amount = (data['totalAmount'] ?? 0.0).toDouble();
        final createdAt =
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now();

        if (status == 'delivered') {
          revenue += amount;
          delivered++;
        } else if (status == 'pending' || status == 'preparing') {
          pending++;
        }

        // Weekly logic (last 7 days)
        if (now.difference(createdAt).inDays < 7) {
          final dayName = [
            'Mon',
            'Tue',
            'Wed',
            'Thu',
            'Fri',
            'Sat',
            'Sun',
          ][createdAt.weekday - 1];
          if (weeklyMap.containsKey(dayName)) {
            weeklyMap[dayName] = (weeklyMap[dayName] ?? 0) + 1;
          }
        }

        // Top products logic
        final items = data['items'] as List<dynamic>? ?? [];
        for (var item in items) {
          final name = item['name'] as String? ?? 'Unknown';
          final emoji = item['emoji'] as String? ?? '🍔';
          final key = '$emoji $name';
          if (!productMap.containsKey(key)) {
            productMap[key] = {'name': name, 'emoji': emoji, 'orders': 0};
          }
          productMap[key]!['orders'] = (productMap[key]!['orders'] as int) + 1;
        }
      }

      // Convert maps to sorted lists for the UI
      final weeklyOrders = weeklyMap.entries
          .map((e) => {'day': e.key, 'orders': e.value})
          .toList()
          .reversed // Oldest first
          .toList();

      final topProducts = productMap.values.toList();
      topProducts.sort(
        (a, b) => (b['orders'] as int).compareTo(a['orders'] as int),
      );

      // Customer count
      final usersSnap = await _firestore.collection('users').get();
      final customerCount = usersSnap.docs.length;

      return {
        'totalOrders': snapshot.docs.length,
        'revenue': revenue,
        'pendingOrders': pending,
        'deliveredOrders': delivered,
        'customerCount': customerCount,
        'weeklyOrders': weeklyOrders,
        'topProducts': topProducts.take(5).toList(),
      };
    });
  }

  // ── Orders ──────────────────────────────────────────────────────────────
  Stream<List<OrderModel>> getAllOrders() {
    return _firestore
        .collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => OrderModel.fromFirestore(doc.data(), doc.id))
              .toList();
        });
  }

  Stream<OrderModel?> getOrderById(String orderId) {
    if (orderId.isEmpty) return Stream.value(null);
    return _firestore.collection('orders').doc(orderId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return OrderModel.fromFirestore(doc.data()!, doc.id);
    });
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    final docRef = _firestore.collection('orders').doc(orderId);
    final snapshot = await docRef.get();
    if (!snapshot.exists || snapshot.data() == null) return;

    final order = OrderModel.fromFirestore(snapshot.data()!, snapshot.id);
    final timeline = List<OrderStatusEvent>.from(order.statusTimeline);
    final now = DateTime.now();

    final event = _buildStatusEvent(status, now);
    final alreadyRecorded = timeline.any((item) => item.status == status);
    if (!alreadyRecorded || status == OrderStatus.cancelled) {
      timeline.add(event);
    }

    await docRef.update({
      'status': status.name,
      'updatedAt': FieldValue.serverTimestamp(),
      'statusTimeline': timeline.map((item) => item.toMap()).toList(),
    });
  }

  // ── Customer Management ──────────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getCustomersStream() {
    return _firestore
        .collection('users')
        .where('role', isEqualTo: 'customer')
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  Future<void> toggleUserBlock(String uid, bool currentStatus) async {
    await _firestore.collection('users').doc(uid).update({
      'isBlocked': !currentStatus,
    });
  }

  // ── Subscription Management ──────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getSubscriptionsStream() {
    return _firestore
        .collection('user_subscriptions')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
        );
  }

  Future<void> cancelSubscription(String subId) async {
    await _firestore.collection('user_subscriptions').doc(subId).update({
      'isActive': false,
    });
  }

  // ── Promo Management ─────────────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getPromosStream() {
    return _firestore
        .collection('promos')
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((doc) => {...doc.data(), 'id': doc.id}).toList(),
        );
  }

  Future<void> addPromo(Map<String, dynamic> promoData) async {
    await _firestore.collection('promos').add(promoData);
  }

  Future<void> deletePromo(String promoId) async {
    await _firestore.collection('promos').doc(promoId).delete();
  }

  Future<void> togglePromo(String promoId, bool currentStatus) async {
    await _firestore.collection('promos').doc(promoId).update({
      'isActive': !currentStatus,
    });
  }

  // ── Notification Management ─────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getSentNotificationsStream() {
    return _firestore
        .collection('admin_notifications')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snap) => snap.docs.map((doc) => doc.data()).toList());
  }

  Future<void> sendNotification(Map<String, dynamic> notificationData) async {
    await _firestore.collection('admin_notifications').add({
      ...notificationData,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  OrderStatusEvent _buildStatusEvent(OrderStatus status, DateTime time) {
    switch (status) {
      case OrderStatus.pending:
        return OrderStatusEvent(
          status: status,
          title: 'Order placed',
          message: 'The kitchen has accepted the order and queued it.',
          createdAt: time,
        );
      case OrderStatus.preparing:
        return OrderStatusEvent(
          status: status,
          title: 'Preparing now',
          message: 'The kitchen team has started preparing the order.',
          createdAt: time,
        );
      case OrderStatus.outForDelivery:
        return OrderStatusEvent(
          status: status,
          title: 'Out for delivery',
          message: 'The order has left the kitchen and is on the way.',
          createdAt: time,
        );
      case OrderStatus.delivered:
        return OrderStatusEvent(
          status: status,
          title: 'Delivered',
          message: 'The order has been delivered to the customer.',
          createdAt: time,
        );
      case OrderStatus.cancelled:
        return OrderStatusEvent(
          status: status,
          title: 'Order cancelled',
          message: 'The order has been cancelled by the admin team.',
          createdAt: time,
        );
    }
  }
}
