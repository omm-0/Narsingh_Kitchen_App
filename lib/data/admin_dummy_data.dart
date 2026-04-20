// Dummy data models and lists for admin panel screens.

enum OrderStatus { pending, preparing, outForDelivery, delivered, cancelled }

class AdminOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final List<OrderItem> items;
  OrderStatus status;

  AdminOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.customerAddress,
    required this.items,
    required this.status,
  });

  double get subtotal => items.fold(0.0, (s, i) => s + i.lineTotal);
  double get deliveryFee => 30.0;
  double get gst => subtotal * 0.05;
  double get total => subtotal + deliveryFee + gst;
}

class OrderItem {
  final String name;
  final String emoji;
  final int qty;
  final double unitPrice;
  double get lineTotal => qty * unitPrice;

  const OrderItem({
    required this.name,
    required this.emoji,
    required this.qty,
    required this.unitPrice,
  });
}

class AdminCustomer {
  final String id;
  final String name;
  final String email;
  final String phone;
  bool isBlocked;

  AdminCustomer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isBlocked = false,
  });

  String get initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return parts[0][0].toUpperCase();
  }
}

class AdminSubscription {
  final String id;
  final String customerName;
  final String plan;
  final String startDate;
  final String endDate;
  bool isActive;

  AdminSubscription({
    required this.id,
    required this.customerName,
    required this.plan,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
  });
}

class PromoCode {
  final String id;
  final String code;
  final int discountPercent;
  final String expiry;
  bool isActive;

  PromoCode({
    required this.id,
    required this.code,
    required this.discountPercent,
    required this.expiry,
    this.isActive = true,
  });
}

class AdminProduct {
  final String id;
  String name;
  double price;
  String category;
  String description;
  String emoji;
  bool isAvailable;

  AdminProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    required this.description,
    required this.emoji,
    this.isAvailable = true,
  });
}

class WeeklyBarData {
  final String day;
  final int orders;
  const WeeklyBarData(this.day, this.orders);
}

class AdminDummyData {
  AdminDummyData._();

  // ── Orders ────────────────────────────────────────────────────────────────
  static final List<AdminOrder> orders = [
    AdminOrder(
      id: 'ORD-001',
      customerName: 'Rahul Sharma',
      customerPhone: '+91 98765 43210',
      customerAddress: '12, Civil Lines, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Veg Burger', emoji: '🍔', qty: 2, unitPrice: 149),
        OrderItem(name: 'Masala Fries', emoji: '🍟', qty: 1, unitPrice: 79),
      ],
      status: OrderStatus.pending,
    ),
    AdminOrder(
      id: 'ORD-002',
      customerName: 'Priya Meena',
      customerPhone: '+91 87654 32109',
      customerAddress: '45, Malviya Nagar, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Rajasthani Thali', emoji: '🍱', qty: 1, unitPrice: 120),
      ],
      status: OrderStatus.preparing,
    ),
    AdminOrder(
      id: 'ORD-003',
      customerName: 'Amit Verma',
      customerPhone: '+91 76543 21098',
      customerAddress: '7, Vaishali Nagar, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Paneer Roll', emoji: '🌯', qty: 3, unitPrice: 89),
        OrderItem(name: 'Red Chilli Powder 500g', emoji: '🌶️', qty: 1, unitPrice: 95),
      ],
      status: OrderStatus.outForDelivery,
    ),
    AdminOrder(
      id: 'ORD-004',
      customerName: 'Sunita Joshi',
      customerPhone: '+91 65432 10987',
      customerAddress: '3, Tonk Road, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Margherita Pizza', emoji: '🍕', qty: 1, unitPrice: 299),
      ],
      status: OrderStatus.delivered,
    ),
    AdminOrder(
      id: 'ORD-005',
      customerName: 'Deepak Gupta',
      customerPhone: '+91 54321 09876',
      customerAddress: '22, Jagatpura, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Cumin Seeds 250g', emoji: '🌿', qty: 2, unitPrice: 60),
        OrderItem(name: 'Turmeric 100g', emoji: '🟡', qty: 1, unitPrice: 40),
      ],
      status: OrderStatus.cancelled,
    ),
    AdminOrder(
      id: 'ORD-006',
      customerName: 'Kavita Singh',
      customerPhone: '+91 43210 98765',
      customerAddress: '8, Mansarovar, Jaipur, Rajasthan',
      items: const [
        OrderItem(name: 'Rajasthani Thali', emoji: '🍱', qty: 2, unitPrice: 120),
        OrderItem(name: 'Veg Burger', emoji: '🍔', qty: 1, unitPrice: 149),
      ],
      status: OrderStatus.pending,
    ),
  ];

  // ── Customers ─────────────────────────────────────────────────────────────
  static final List<AdminCustomer> customers = [
    AdminCustomer(
      id: 'CUS-001',
      name: 'Rahul Sharma',
      email: 'rahul@example.com',
      phone: '+91 98765 43210',
    ),
    AdminCustomer(
      id: 'CUS-002',
      name: 'Priya Meena',
      email: 'priya@example.com',
      phone: '+91 87654 32109',
    ),
    AdminCustomer(
      id: 'CUS-003',
      name: 'Amit Verma',
      email: 'amit@example.com',
      phone: '+91 76543 21098',
      isBlocked: true,
    ),
    AdminCustomer(
      id: 'CUS-004',
      name: 'Sunita Joshi',
      email: 'sunita@example.com',
      phone: '+91 65432 10987',
    ),
    AdminCustomer(
      id: 'CUS-005',
      name: 'Deepak Gupta',
      email: 'deepak@example.com',
      phone: '+91 54321 09876',
    ),
    AdminCustomer(
      id: 'CUS-006',
      name: 'Kavita Singh',
      email: 'kavita@example.com',
      phone: '+91 43210 98765',
    ),
  ];

  // ── Subscriptions ─────────────────────────────────────────────────────────
  static final List<AdminSubscription> subscriptions = [
    AdminSubscription(
      id: 'SUB-001',
      customerName: 'Rahul Sharma',
      plan: '1 Month',
      startDate: '01 Apr 2026',
      endDate: '30 Apr 2026',
    ),
    AdminSubscription(
      id: 'SUB-002',
      customerName: 'Priya Meena',
      plan: '3 Month',
      startDate: '15 Feb 2026',
      endDate: '14 May 2026',
    ),
    AdminSubscription(
      id: 'SUB-003',
      customerName: 'Kavita Singh',
      plan: '6 Month',
      startDate: '01 Jan 2026',
      endDate: '30 Jun 2026',
    ),
    AdminSubscription(
      id: 'SUB-004',
      customerName: 'Sunita Joshi',
      plan: '1 Month',
      startDate: '10 Apr 2026',
      endDate: '09 May 2026',
      isActive: false,
    ),
  ];

  // ── Promo Codes ───────────────────────────────────────────────────────────
  static final List<PromoCode> promos = [
    PromoCode(
      id: 'PRO-001',
      code: 'FEAST10',
      discountPercent: 10,
      expiry: '30 Apr 2026',
    ),
    PromoCode(
      id: 'PRO-002',
      code: 'SAVE20',
      discountPercent: 20,
      expiry: '15 May 2026',
    ),
    PromoCode(
      id: 'PRO-003',
      code: 'WELCOME5',
      discountPercent: 5,
      expiry: '31 Dec 2026',
    ),
    PromoCode(
      id: 'PRO-004',
      code: 'FOODLOVER',
      discountPercent: 15,
      expiry: '20 Apr 2026',
      isActive: false,
    ),
  ];

  // ── Products ──────────────────────────────────────────────────────────────
  static final List<AdminProduct> fastFoodProducts = [
    AdminProduct(
      id: 'FF-001',
      name: 'Veg Burger',
      price: 149,
      category: 'Fast Food',
      description: 'Crispy veg patty with fresh veggies',
      emoji: '🍔',
    ),
    AdminProduct(
      id: 'FF-002',
      name: 'Margherita Pizza',
      price: 299,
      category: 'Fast Food',
      description: 'Classic cheese and tomato pizza',
      emoji: '🍕',
    ),
    AdminProduct(
      id: 'FF-003',
      name: 'Paneer Roll',
      price: 89,
      category: 'Fast Food',
      description: 'Spicy paneer wrapped in paratha',
      emoji: '🌯',
    ),
  ];

  static final List<AdminProduct> tiffinProducts = [
    AdminProduct(
      id: 'TF-001',
      name: 'Rajasthani Thali',
      price: 120,
      category: 'Tiffin',
      description: 'Dal, Roti, Sabzi, Rice, Papad & Pickle',
      emoji: '🍱',
    ),
    AdminProduct(
      id: 'TF-002',
      name: 'South Indian Combo',
      price: 110,
      category: 'Tiffin',
      description: 'Idli, Dosa, Sambar & Chutney',
      emoji: '🥘',
    ),
  ];

  static final List<AdminProduct> spicesProducts = [
    AdminProduct(
      id: 'SP-001',
      name: 'Red Chilli Powder',
      price: 95,
      category: 'Spices',
      description: 'Pure Mathania red chilli powder',
      emoji: '🌶️',
    ),
    AdminProduct(
      id: 'SP-002',
      name: 'Turmeric Powder',
      price: 40,
      category: 'Spices',
      description: 'Lakadong turmeric, 98% curcumin',
      emoji: '🟡',
    ),
    AdminProduct(
      id: 'SP-003',
      name: 'Cumin Seeds',
      price: 60,
      category: 'Spices',
      description: 'Whole jeera from Rajasthan farms',
      emoji: '🌿',
    ),
    AdminProduct(
      id: 'SP-004',
      name: 'Kitchen King Blend',
      price: 85,
      category: 'Spices',
      description: 'Premium masala blend for daily cooking',
      emoji: '✨',
    ),
  ];

  // ── Analytics ─────────────────────────────────────────────────────────────
  static const List<WeeklyBarData> weeklyOrders = [
    WeeklyBarData('Mon', 12),
    WeeklyBarData('Tue', 19),
    WeeklyBarData('Wed', 8),
    WeeklyBarData('Thu', 25),
    WeeklyBarData('Fri', 32),
    WeeklyBarData('Sat', 28),
    WeeklyBarData('Sun', 15),
  ];

  static const topSellingProducts = [
    {'emoji': '🍔', 'name': 'Veg Burger', 'orders': 87},
    {'emoji': '🍱', 'name': 'Rajasthani Thali', 'orders': 74},
    {'emoji': '🌶️', 'name': 'Red Chilli Powder', 'orders': 61},
    {'emoji': '🍕', 'name': 'Margherita Pizza', 'orders': 48},
    {'emoji': '🌯', 'name': 'Paneer Roll', 'orders': 39},
  ];

  // ── Dashboard Stats ───────────────────────────────────────────────────────
  static int get totalOrdersToday => orders.length;
  static double get totalRevenue =>
      orders.fold(0, (s, o) => s + o.total);
  static int get activeSubscriptions =>
      subscriptions.where((s) => s.isActive).length;
  static int get pendingOrders =>
      orders.where((o) => o.status == OrderStatus.pending).length;

  // ── Notifications ─────────────────────────────────────────────────────────
  static final List<Map<String, String>> notifications = [
    {
      'title': 'Weekend Special Offer!',
      'message': 'Get 20% off on all tiffin orders this weekend.',
      'audience': 'All',
      'date': '18 Apr 2026',
    },
    {
      'title': 'New Spices Arrived',
      'message': 'Fresh batch of Mathania Red Chilli now available.',
      'audience': 'Customers',
      'date': '15 Apr 2026',
    },
    {
      'title': 'Subscription Renewal Reminder',
      'message': 'Your tiffin subscription expires in 3 days.',
      'audience': 'Subscribers',
      'date': '12 Apr 2026',
    },
  ];
}
