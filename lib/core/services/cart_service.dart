import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';
import '../../models/order_model.dart';
import 'auth_service.dart';

class CartService {
  static final CartService instance = CartService._();
  CartService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String? get _uid => AuthService.instance.currentUser?.uid;

  // ── Cart Operations ──────────────────────────────────────────────────────
  Stream<List<Map<String, dynamic>>> getCartItems() {
    if (_uid == null) return Stream.value([]);
    return _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> addToCart(ProductModel product, {int quantity = 1, String? variant}) async {
    if (_uid == null) return;
    
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');
    final docId = '${product.id}_${variant ?? 'default'}';
    
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
        'unitPrice': product.price,
        'quantity': quantity,
        'variantLabel': variant,
      });
    }
  }

  Future<void> removeFromCart(String lineId) async {
    if (_uid == null) return;
    await _firestore
        .collection('users')
        .doc(_uid)
        .collection('cart')
        .doc(lineId)
        .delete();
  }

  Future<void> clearCart() async {
    if (_uid == null) return;
    final cartRef = _firestore.collection('users').doc(_uid).collection('cart');
    final snapshot = await cartRef.get();
    for (var doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // ── Order Operations ─────────────────────────────────────────────────────
  Future<void> placeOrder(List<Map<String, dynamic>> items, double total, String address) async {
    if (_uid == null) return;

    final userDoc = await AuthService.instance.getUserDetails(_uid!);
    final userName = userDoc?['name'] ?? 'Customer';

    final orderData = {
      'userId': _uid,
      'userName': userName,
      'items': items,
      'totalAmount': total,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
      'deliveryAddress': address,
    };

    await _firestore.collection('orders').add(orderData);
    await clearCart();
  }
}
