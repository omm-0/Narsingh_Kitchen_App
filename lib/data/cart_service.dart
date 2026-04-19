import 'dart:math';

import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';
import '../models/product_model.dart';
import 'dummy_data.dart';

/// Simple app-wide cart with promo + totals (demo / offline-first).
class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final List<CartItemModel> _items = [];
  final Random _rand = Random();

  String? _appliedPromo;
  static const double _deliveryFee = 30;
  static const double _gstRate = 0.05;

  // Valid promo codes with their discount percentages
  static const Map<String, double> validPromoCodes = {
    'FEAST10': 0.10, // 10% discount
    'SAVE20': 0.20, // 20% discount
    'WELCOME5': 0.05, // 5% discount
    'FOODLOVER': 0.15, // 15% discount
  };

  List<CartItemModel> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  void seedDemoIfEmpty() {
    if (_items.isNotEmpty) return;
    _addInternal(
      DummyData.fastFoodItems.first,
      quantity: 1,
      variantLabel: null,
    );
    _addInternal(DummyData.todayTiffinMeal, quantity: 2, variantLabel: null);
    _addInternal(DummyData.spiceItems.first, quantity: 1, variantLabel: '500g');
    notifyListeners();
  }

  String generateOrderId() =>
      'FE-${DateTime.now().year}${100000 + _rand.nextInt(899999)}';

  void clear() {
    _items.clear();
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

  double get subtotal => _items.fold<double>(0, (sum, e) => sum + e.lineTotal);

  double get promoDiscount {
    if (!promoActive || _appliedPromo == null) return 0;
    final discountRate = validPromoCodes[_appliedPromo] ?? 0;
    return subtotal * discountRate;
  }

  double get taxableBase =>
      (subtotal - promoDiscount).clamp(0, double.infinity);

  double get gstAmount => taxableBase * _gstRate;

  double get total => taxableBase + _deliveryFee + gstAmount;

  static double get deliveryFee => _deliveryFee;

  void addProduct(
    ProductModel product, {
    int quantity = 1,
    String? variantLabel,
  }) {
    _addInternal(product, quantity: quantity, variantLabel: variantLabel);
    notifyListeners();
  }

  void _addInternal(
    ProductModel product, {
    required int quantity,
    required String? variantLabel,
  }) {
    final unit = product.priceForVariant(variantLabel);
    CartItemModel? existing;
    for (final e in _items) {
      if (e.product.id == product.id && e.variantLabel == variantLabel) {
        existing = e;
        break;
      }
    }
    if (existing != null) {
      existing.quantity += quantity;
      return;
    }
    _items.add(
      CartItemModel(
        lineId:
            '${product.id}-${variantLabel ?? "base"}-${DateTime.now().microsecondsSinceEpoch}',
        product: product,
        unitPrice: unit,
        quantity: quantity,
        variantLabel: variantLabel,
      ),
    );
  }

  void updateQuantity(String lineId, int next) {
    final q = next.clamp(1, 99);
    final index = _items.indexWhere((e) => e.lineId == lineId);
    if (index < 0) return;
    _items[index].quantity = q;
    notifyListeners();
  }

  void removeLine(String lineId) {
    _items.removeWhere((e) => e.lineId == lineId);
    notifyListeners();
  }

  String formatInr(double v) =>
      '₹${v.toStringAsFixed(v.truncateToDouble() == v ? 0 : 2)}';
}
