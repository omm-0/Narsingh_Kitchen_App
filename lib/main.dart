import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'data/cart_service.dart';
import 'data/dummy_data.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/auth/sign_up_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/cart/checkout_screen.dart';
import 'features/cart/order_success_screen.dart';
import 'features/fast_food/fast_food_screen.dart';
import 'features/home/bottom_nav_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/product/product_detail_screen.dart';
import 'features/spices/spice_category_screen.dart';
import 'features/spices/spice_detail_screen.dart';
import 'features/spices/spices_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/tiffin/delivery_slot_screen.dart';
import 'features/tiffin/subscription_plan_screen.dart';
import 'features/tiffin/tiffin_detail_screen.dart';
import 'features/tiffin/tiffin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  CartService.instance.seedDemoIfEmpty();
  runApp(const NarsinghKitchenApp());
}

class NarsinghKitchenApp extends StatelessWidget {
  const NarsinghKitchenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FoodieExpress',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      initialRoute: AppRoutes.splash,
      routes: {
        AppRoutes.splash: (_) => const SplashScreen(),
        AppRoutes.onboarding: (_) => const OnboardingScreen(),
        AppRoutes.signIn: (_) => const SignInScreen(),
        AppRoutes.signUp: (_) => const SignUpScreen(),
        AppRoutes.otp: (_) => const OtpScreen(),
        AppRoutes.home: (_) => const HomeScreen(),
        AppRoutes.bottomNav: (_) => const BottomNavScreen(),
        AppRoutes.fastFood: (_) => const FastFoodScreen(),
        AppRoutes.tiffin: (_) => const TiffinScreen(),
        AppRoutes.spices: (_) => const SpicesScreen(),
        AppRoutes.cart: (_) => const CartScreen(),
        AppRoutes.productDetail: (_) => const ProductDetailScreen(),
        AppRoutes.tiffinDetail: _buildTiffinDetail,
        AppRoutes.subscriptionPlan: (_) => const SubscriptionPlanScreen(),
        AppRoutes.deliverySlot: (_) => const DeliverySlotScreen(),
        AppRoutes.spiceDetail: _buildSpiceDetail,
        AppRoutes.spiceCategory: _buildSpiceCategory,
        AppRoutes.checkout: (_) => const CheckoutScreen(),
        AppRoutes.orderSuccess: _buildOrderSuccess,
      },
    );
  }

  static Widget _buildTiffinDetail(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final id = arg is String ? arg : DummyData.todayTiffinMeal.id;
    final product = DummyData.findById(id) ?? DummyData.todayTiffinMeal;
    return TiffinDetailScreen(product: product);
  }

  static Widget _buildSpiceDetail(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final id = arg is String ? arg : DummyData.spiceItems.first.id;
    final product = DummyData.findById(id) ?? DummyData.spiceItems.first;
    return SpiceDetailScreen(product: product);
  }

  static Widget _buildSpiceCategory(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final cat = arg is String ? arg : 'All';
    return SpiceCategoryScreen(category: cat);
  }

  static Widget _buildOrderSuccess(BuildContext context) {
    final arg = ModalRoute.of(context)?.settings.arguments;
    final orderId = arg is String ? arg : 'FE-000000';
    return OrderSuccessScreen(orderId: orderId);
  }
}
