import 'package:flutter/material.dart';

import 'core/constants/app_routes.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/otp_screen.dart';
import 'features/auth/sign_in_screen.dart';
import 'features/auth/sign_up_screen.dart';
import 'features/cart/cart_screen.dart';
import 'features/fast_food/fast_food_screen.dart';
import 'features/home/bottom_nav_screen.dart';
import 'features/home/home_screen.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/product/product_detail_screen.dart';
import 'features/spices/spices_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/tiffin/tiffin_screen.dart';

void main() {
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
      },
    );
  }
}
