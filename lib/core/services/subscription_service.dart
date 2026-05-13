import 'package:cloud_firestore/cloud_firestore.dart';

import '../../data/dummy_data.dart';
import '../../models/subscription_model.dart';
import 'auth_service.dart';

class SubscriptionService {
  SubscriptionService._();
  static final SubscriptionService instance = SubscriptionService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => AuthService.instance.currentUser?.uid;

  Stream<List<SubscriptionModel>> getPlans() {
    return _firestore.collection('subscription_plans').snapshots().map((
      snapshot,
    ) {
      final plans = snapshot.docs
          .map((doc) => SubscriptionModel.fromFirestore(doc.data(), doc.id))
          .toList();
      return plans.isEmpty ? DummyData.subscriptionPlans : plans;
    });
  }

  Stream<List<Map<String, dynamic>>> getMySubscriptions() {
    if (_uid == null) return Stream.value([]);

    return _firestore
        .collection('user_subscriptions')
        .where('userId', isEqualTo: _uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => {...doc.data(), 'id': doc.id})
              .toList();
        });
  }

  Future<void> createSubscription({
    required SubscriptionModel plan,
    required String mealType,
    required String deliveryTime,
    required String deliveryAddress,
  }) async {
    if (_uid == null) return;

    final user = await AuthService.instance.getUserDetails(_uid!);
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month + plan.months, now.day);

    await _firestore.collection('user_subscriptions').add({
      'userId': _uid,
      'userName': user?['name'] ?? 'Customer',
      'planId': plan.id,
      'planTitle': plan.title,
      'mealsLabel': plan.mealsLabel,
      'months': plan.months,
      'price': plan.price,
      'mealType': mealType,
      'deliveryTime': deliveryTime,
      'deliveryAddress': deliveryAddress,
      'isActive': true,
      'startDate': _formatDate(now),
      'endDate': _formatDate(endDate),
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  String _formatDate(DateTime value) {
    final monthNames = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${value.day.toString().padLeft(2, '0')} ${monthNames[value.month - 1]} ${value.year}';
  }
}
