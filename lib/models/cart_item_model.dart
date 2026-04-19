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

  double get lineTotal => unitPrice * quantity;
}
