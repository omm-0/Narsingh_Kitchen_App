enum ProductKind { fastFood, tiffinMeal, spice }

/// Shared catalog item used across Fast Food, Tiffin, and Spices flows.
class ProductModel {
  const ProductModel({
    required this.id,
    required this.name,
    required this.emoji,
    required this.kind,
    required this.price,
    required this.rating,
    required this.tag,
    required this.subtitle,
    this.spiceCategory = 'All',
    this.weightPrices,
    this.mealComponents = const [],
    this.nutritionLines = const [],
    this.weeklyRotation = const [],
    this.farmRegion,
    this.purityPercent,
    this.deliveryEta,
  });

  final String id;
  final String name;
  final String emoji;
  final ProductKind kind;

  /// Default unit price (INR) — meal price, base spice price, or smallest weight.
  final double price;

  /// Numeric rating for sorting (e.g. 4.8).
  final double rating;

  final String tag;
  final String subtitle;

  /// Spice shelf category for chips / category screen.
  final String spiceCategory;

  /// Optional per-weight spice pricing (label → INR).
  final Map<String, double>? weightPrices;

  final List<String> mealComponents;
  final List<String> nutritionLines;
  final List<String> weeklyRotation;

  final String? farmRegion;
  final double? purityPercent;

  /// Fast food ETA label when relevant.
  final String? deliveryEta;

  String get ratingLabel => rating.toStringAsFixed(1);

  double priceForVariant(String? weightLabel) {
    if (weightPrices == null || weightPrices!.isEmpty) return price;
    if (weightLabel == null || !weightPrices!.containsKey(weightLabel)) {
      return weightPrices!.values.first;
    }
    return weightPrices![weightLabel]!;
  }

  Iterable<String> get weightOptions =>
      weightPrices?.keys ?? const Iterable<String>.empty();
}
