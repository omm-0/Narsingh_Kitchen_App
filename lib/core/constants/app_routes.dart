abstract final class AppRoutes {
  AppRoutes._();

  // ── User Routes ───────────────────────────────────────────────────────────
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String signIn = '/sign-in';
  static const String signUp = '/sign-up';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String bottomNav = '/bottom-nav';
  static const String fastFood = '/fast-food';
  static const String tiffin = '/tiffin';
  static const String spices = '/spices';
  static const String cart = '/cart';
  static const String productDetail = '/product-detail';

  static const String tiffinDetail = '/tiffin-detail';
  static const String subscriptionPlan = '/subscription-plan';
  static const String deliverySlot = '/delivery-slot';

  static const String spiceDetail = '/spice-detail';
  static const String spiceCategory = '/spice-category';

  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';

  // ── Admin Routes ──────────────────────────────────────────────────────────
  static const String adminBottomNav = '/admin-bottom-nav';
  static const String adminDashboard = '/admin-dashboard';
  static const String adminOrders = '/admin-orders';
  static const String orderDetail = '/order-detail';
  static const String manageProducts = '/manage-products';
  static const String manageFastFood = '/manage-fast-food';
  static const String manageTiffin = '/manage-tiffin';
  static const String manageSpices = '/manage-spices';
  static const String addEditProduct = '/add-edit-product';
  static const String manageCustomers = '/manage-customers';
  static const String manageSubscriptions = '/manage-subscriptions';
  static const String managePromos = '/manage-promos';
  static const String analytics = '/analytics';
  static const String manageNotifications = '/manage-notifications';
  static const String adminProfile = '/admin-profile';
}
