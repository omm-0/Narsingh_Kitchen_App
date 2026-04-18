/// Tiffin subscription offering row.
class SubscriptionModel {
  const SubscriptionModel({
    required this.id,
    required this.title,
    required this.mealsLabel,
    required this.price,
    required this.savingsLabel,
    required this.months,
    required this.highlight,
  });

  final String id;
  final String title;
  final String mealsLabel;

  /// INR total plan price.
  final double price;

  final String savingsLabel;
  final int months;

  /// Marketing line shown on cards.
  final bool highlight;
}
