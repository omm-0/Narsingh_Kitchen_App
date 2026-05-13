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

  factory SubscriptionModel.fromFirestore(
    Map<String, dynamic> json,
    String docId,
  ) {
    return SubscriptionModel(
      id: docId,
      title: json['title'] ?? '',
      mealsLabel: json['mealsLabel'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      savingsLabel: json['savingsLabel'] ?? '',
      months: json['months'] ?? 1,
      highlight: json['highlight'] ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'mealsLabel': mealsLabel,
      'price': price,
      'savingsLabel': savingsLabel,
      'months': months,
      'highlight': highlight,
    };
  }
}
