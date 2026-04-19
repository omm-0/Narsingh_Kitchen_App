import '../models/product_model.dart';
import '../models/subscription_model.dart';

abstract final class DummyData {
  DummyData._();

  static final ProductModel todayTiffinMeal = ProductModel(
    id: 'tiffin-thali-raj',
    name: 'Rajasthani Thali',
    emoji: '🍱',
    kind: ProductKind.tiffinMeal,
    price: 120,
    rating: 4.9,
    tag: 'Chef’s pick',
    subtitle: '2 Roti • Dal • Sabzi • Rice • Salad',
    mealComponents: const [
      'Whole wheat roti (2)',
      'Dal tadka',
      'Seasonal sabzi',
      'Jeera rice',
      'Garden salad',
      'Pickle & papad',
    ],
    nutritionLines: const [
      '~580 kcal per meal',
      'Protein-forward vegetarian plate',
      'Low-oil preparation',
    ],
    weeklyRotation: const [
      'Mon — Gujarati specials',
      'Tue — Rajasthani classics',
      'Wed — Punjabi comfort',
      'Thu — South-inspired bowls',
      'Fri — Street-food inspired (veg)',
    ],
  );

  static final List<ProductModel> fastFoodItems = [
    ProductModel(
      id: 'ff-burger-classic',
      name: 'Classic Veg Burger',
      emoji: '🍔',
      kind: ProductKind.fastFood,
      price: 180,
      rating: 4.8,
      tag: 'Popular',
      subtitle: 'Crispy patty • fresh veggies',
      deliveryEta: '22 min',
    ),
    ProductModel(
      id: 'ff-pizza-cheese',
      name: 'Cheese Burst Pizza',
      emoji: '🍕',
      kind: ProductKind.fastFood,
      price: 299,
      rating: 4.6,
      tag: 'Chef pick',
      subtitle: 'Wood-fired style crust',
      deliveryEta: '35 min',
    ),
    ProductModel(
      id: 'ff-roll-paneer',
      name: 'Paneer Tikka Roll',
      emoji: '🌯',
      kind: ProductKind.fastFood,
      price: 149,
      rating: 4.7,
      tag: 'New',
      subtitle: 'Smoky marinade wrap',
      deliveryEta: '28 min',
    ),
  ];

  static final List<ProductModel> spiceItems = [
    ProductModel(
      id: 'sp-chilli',
      name: 'Red Chilli Powder',
      emoji: '🌶️',
      kind: ProductKind.spice,
      price: 85,
      rating: 4.9,
      tag: 'Hot',
      subtitle: 'Stone-ground intensity',
      spiceCategory: 'Ground',
      farmRegion: 'Byadgi & Mathania blend — Rajasthan packing unit',
      purityPercent: 99.2,
      weightPrices: const {
        '100g': 45,
        '250g': 95,
        '500g': 180,
      },
    ),
    ProductModel(
      id: 'sp-turmeric',
      name: 'Turmeric Powder',
      emoji: '🟡',
      kind: ProductKind.spice,
      price: 55,
      rating: 4.8,
      tag: 'Pure',
      subtitle: 'High curcumin grade',
      spiceCategory: 'Ground',
      farmRegion: 'Erode cooperative — sealed in Jaipur',
      purityPercent: 99.5,
      weightPrices: const {
        '100g': 35,
        '250g': 75,
        '500g': 120,
      },
    ),
    ProductModel(
      id: 'sp-cumin',
      name: 'Cumin Seeds',
      emoji: '🌿',
      kind: ProductKind.spice,
      price: 70,
      rating: 4.7,
      tag: 'Whole',
      subtitle: 'Bold aroma for tadka',
      spiceCategory: 'Whole',
      farmRegion: 'Jodhpur sorting facility',
      purityPercent: 98.8,
      weightPrices: const {
        '100g': 55,
        '250g': 110,
        '500g': 160,
      },
    ),
    ProductModel(
      id: 'sp-coriander',
      name: 'Coriander Powder',
      emoji: '🍃',
      kind: ProductKind.spice,
      price: 40,
      rating: 4.6,
      tag: 'Fresh',
      subtitle: 'Cool citrus notes',
      spiceCategory: 'Ground',
      farmRegion: 'Kota cold-storage batch',
      purityPercent: 99.0,
      weightPrices: const {
        '100g': 28,
        '250g': 58,
        '500g': 90,
      },
    ),
    ProductModel(
      id: 'sp-garam',
      name: 'Kitchen King Blend',
      emoji: '🫙',
      kind: ProductKind.spice,
      price: 95,
      rating: 4.85,
      tag: 'Blends',
      subtitle: 'Chef-balanced masala',
      spiceCategory: 'Blends',
      farmRegion: 'In-house blending — Jaipur',
      purityPercent: 98.5,
      weightPrices: const {
        '100g': 48,
        '250g': 105,
        '500g': 195,
      },
    ),
    ProductModel(
      id: 'sp-mustard',
      name: 'Mustard Seeds',
      emoji: '⚪',
      kind: ProductKind.spice,
      price: 42,
      rating: 4.5,
      tag: 'Seeds',
      subtitle: 'Sharp popping heat',
      spiceCategory: 'Seeds',
      farmRegion: 'Rajasthan plains harvest',
      purityPercent: 98.2,
      weightPrices: const {
        '100g': 25,
        '250g': 48,
        '500g': 82,
      },
    ),
  ];

  static final List<SubscriptionModel> subscriptionPlans = [
    const SubscriptionModel(
      id: 'sub-1m',
      title: '1 Month',
      mealsLabel: '30 meals • Lunch + Dinner slots',
      price: 2999,
      savingsLabel: 'Save ₹601',
      months: 1,
      highlight: false,
    ),
    const SubscriptionModel(
      id: 'sub-3m',
      title: '3 Months',
      mealsLabel: '90 meals • Priority routing',
      price: 7999,
      savingsLabel: 'Save ₹2,201',
      months: 3,
      highlight: true,
    ),
    const SubscriptionModel(
      id: 'sub-6m',
      title: '6 Months',
      mealsLabel: '180 meals • Dedicated meal coach',
      price: 14999,
      savingsLabel: 'Save ₹5,401',
      months: 6,
      highlight: false,
    ),
  ];

  static ProductModel? findById(String id) {
    if (todayTiffinMeal.id == id) return todayTiffinMeal;
    for (final p in fastFoodItems) {
      if (p.id == id) return p;
    }
    for (final p in spiceItems) {
      if (p.id == id) return p;
    }
    return null;
  }

  static List<ProductModel> spicesFiltered(String chipLabel) {
    if (chipLabel == 'All') return List<ProductModel>.from(spiceItems);
    return spiceItems.where((p) => p.spiceCategory == chipLabel).toList();
  }
}
