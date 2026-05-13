import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../data/cart_service.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';
import '../saved/saved_screen.dart';
import 'home_screen.dart';

class BottomNavScreen extends StatefulWidget {
  const BottomNavScreen({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int _index;

  late final List<Widget> _pages = [
    const HomeScreen(),
    const SavedScreen(embeddedInNav: true),
    const CartScreen(embeddedInNav: true),
    const OrdersScreen(embeddedInNav: true),
    const ProfileScreen(embeddedInNav: true),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, _pages.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: ListenableBuilder(
        listenable: CartService.instance,
        builder: (context, _) {
          final cartCount = CartService.instance.items.length;
          return Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _index,
              selectedItemColor: AppColors.primaryRed,
              unselectedItemColor: AppColors.textSecondary,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedLabelStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
              unselectedLabelStyle: GoogleFonts.outfit(
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
              onTap: (i) => setState(() => _index = i),
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_rounded),
                  activeIcon: Icon(Icons.home_rounded),
                  label: 'Home',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_outline_rounded),
                  activeIcon: Icon(Icons.favorite_rounded),
                  label: 'Saved',
                ),
                BottomNavigationBarItem(
                  icon: _cartIcon(active: false, cartCount: cartCount),
                  activeIcon: _cartIcon(active: true, cartCount: cartCount),
                  label: 'Cart',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.receipt_long_outlined),
                  activeIcon: Icon(Icons.receipt_long_rounded),
                  label: 'Orders',
                ),
                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline_rounded),
                  activeIcon: Icon(Icons.person_rounded),
                  label: 'Profile',
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _cartIcon({required bool active, required int cartCount}) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(
          active ? Icons.shopping_cart_rounded : Icons.shopping_cart_outlined,
        ),
        if (cartCount > 0)
          Positioned(
            right: -8,
            top: -6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
              decoration: BoxDecoration(
                color: AppColors.primaryRed,
                borderRadius: BorderRadius.circular(10),
              ),
              constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
              child: Center(
                child: Text(
                  cartCount > 99 ? '99+' : '$cartCount',
                  style: GoogleFonts.outfit(
                    color: AppColors.whiteSurface,
                    fontWeight: FontWeight.w700,
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
