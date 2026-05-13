import 'product_model.dart';

/// Single payable row in the shopping cart.
class CartItemModel {
  CartItemModel({
    required this.lineId,
    required this.product,
    required this.unitPrice,
    required this.quantity,
    this.variantLabel,
  });

  final String lineId;
  final ProductModel product;

  /// INR per unit after variant selection.
  final double unitPrice;
  int quantity;

  /// e.g. "500g" for spices.
  final String? variantLabel;

  Map<String, dynamic> toMap() {
    return {
      'lineId': lineId,
      'productId': product.id,
      'productName': product.name,
      'productEmoji': product.emoji,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'variantLabel': variantLabel,
    };
  }

  factory CartItemModel.fromMap(Map<String, dynamic> map, ProductModel product) {
    return CartItemModel(
      lineId: map['lineId'] ?? '',
      product: product,
      unitPrice: (map['unitPrice'] ?? 0.0).toDouble(),
      quantity: map['quantity'] ?? 1,
      variantLabel: map['variantLabel'],
    );
  }

  double get lineTotal => unitPrice * quantity;
}
