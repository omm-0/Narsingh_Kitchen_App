import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import '../models/product_model.dart';
import '../core/services/auth_service.dart';

/// Simple app-wide cart with Firestore persistence.
class CartService extends ChangeNotifier {
  CartService._() {
    _initFirestoreListener();
  }

  static final CartService instance = CartService._();

  List<CartItemModel> _items = [];
  final Random _rand = Random();
  StreamSubscription? _cartSubscription;

  String? _appliedPromo;
  static const double _deliveryFee = 30;
  static const double _gstRate = 0.05;

  static const Map<String, double> validPromoCodes = {
    'FEAST10': 0.10,
    'SAVE20': 0.20,
    'WELCOME5': 0.05,
    'FOODLOVER': 0.15,
  };

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  String? get _uid => AuthService.instance.currentUser?.uid;

  void _initFirestoreListener() {
    AuthService.instance.authStateChanges.listen((user) {
      _cartSubscription?.cancel();
      if (user != null) {
        _cartSubscription = _firestore
            .collection('users')
            .doc(user.uid)
            .collection('cart')
            .snapshots()
            .listen((snapshot) async {
              _items = [];
              for (var doc in snapshot.docs) {
                final data = doc.data();
                // We need to fetch product detail or use a placeholder
                // For now, using a simplified product model constructed from stored data
                final product = ProductModel(
                  id: data['productId'] ?? '',
                  name: data['productName'] ?? '',
                  emoji: data['productEmoji'] ?? '🍔',
                  kind: ProductKind.fastFood, // Fallback
                  price: (data['unitPrice'] ?? 0.0).toDouble(),
                  rating: 5.0,
                  tag: '',
                  subtitle: '',
                );
                _items.add(CartItemModel.fromMap(data, product));
              }
              notifyListeners();
            });
      } else {
        _items = [];
        notifyListeners();
      }
    });
  }

  List<CartItemModel> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;

  Future<void> clear() async {
    if (_uid == null) return;
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
    _appliedPromo = null;
    notifyListeners();
  }

  void applyPromoCode(String code) {
    final normalized = code.trim().toUpperCase();
    if (validPromoCodes.containsKey(normalized)) {
      _appliedPromo = normalized;
    } else {
      _appliedPromo = null;
    }
    notifyListeners();
  }

  bool get promoActive => _appliedPromo != null;
  String? get appliedPromo => _appliedPromo;

  double get subtotal =>
      _items.fold<double>(0, (runningTotal, e) => runningTotal + e.lineTotal);
  double get promoDiscount {
    if (!promoActive || _appliedPromo == null) return 0;
    return subtotal * (validPromoCodes[_appliedPromo] ?? 0);
  }

  double get taxableBase =>
      (subtotal - promoDiscount).clamp(0, double.infinity);
  double get gstAmount => taxableBase * _gstRate;
  double get total => taxableBase + _deliveryFee + gstAmount;
  static double get deliveryFee => _deliveryFee;

  Future<void> addProduct(
    ProductModel product, {
    int quantity = 1,
    String? variantLabel,
  }) async {
    if (_uid == null) return;
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');
    final docId = '${product.id}_${variantLabel ?? 'base'}';

    final doc = await cartRef.doc(docId).get();
    if (doc.exists) {
      await cartRef.doc(docId).update({
        'quantity': FieldValue.increment(quantity),
      });
    } else {
      await cartRef.doc(docId).set({
        'lineId': docId,
        'productId': product.id,
        'productName': product.name,
        'productEmoji': product.emoji,
        'unitPrice': product.priceForVariant(variantLabel),
        'quantity': quantity,
        'variantLabel': variantLabel,
      });
    }
  }

  Future<void> updateQuantity(String lineId, int next) async {
    if (_uid == null) return;
    final q = next.clamp(1, 99);
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(lineId)
        .update({'quantity': q});
  }

  Future<void> removeLine(String lineId) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(lineId)
        .delete();
  }

  Future<String> placeOrder(
    String address, {
    required String paymentMethod,
  }) async {
    if (_uid == null || _items.isEmpty) return '';

    final userDoc = await AuthService.instance.getUserDetails(_uid!);
    final userName = userDoc?['name'] ?? 'Customer';
    final now = DateTime.now();
    final orderCode = 'NK-${100000 + _rand.nextInt(900000)}';
    final timeline = [
      OrderStatusEvent(
        status: OrderStatus.pending,
        title: 'Order placed',
        message: 'We have received your order and shared it with the kitchen.',
        createdAt: now,
      ),
    ];

    final orderData = {
      'orderCode': orderCode,
      'userId': _uid,
      'userName': userName,
      'items': _items.map((i) => i.toMap()).toList(),
      'subtotalAmount': subtotal,
      'deliveryFee': _deliveryFee,
      'taxAmount': gstAmount,
      'discountAmount': promoDiscount,
      'totalAmount': total,
      'paymentMethod': paymentMethod,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
      'deliveryAddress': address,
      'statusTimeline': timeline.map((event) => event.toMap()).toList(),
    };

    final docRef = await _firestore.collection('orders').add(orderData);
    await clear();
    return docRef.id;
  }

  String formatInr(double v) =>
      '₹${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}';
}
