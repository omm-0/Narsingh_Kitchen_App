import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../core/services/product_service.dart';
import '../../../models/product_model.dart';

class ManageProductsScreen extends StatefulWidget {
  const ManageProductsScreen({super.key});

  @override
  State<ManageProductsScreen> createState() => _ManageProductsScreenState();
}

class _ManageProductsScreenState extends State<ManageProductsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Container(
            color: AppColors.whiteSurface,
            child: TabBar(
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
              unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w400, fontSize: 13),
              labelColor: AppColors.primaryRed,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryRed,
              tabs: const [
                Tab(text: 'Fast Food'),
                Tab(text: 'Tiffin'),
                Tab(text: 'Spices'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: const [
                _ProductList(kind: ProductKind.fastFood),
                _ProductList(kind: ProductKind.tiffinMeal),
                _ProductList(kind: ProductKind.spice),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final routes = [AppRoutes.addFastFood, AppRoutes.addTiffin, AppRoutes.addSpice];
          Navigator.pushNamed(context, routes[_tabController.index]);
        },
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.whiteSurface,
        icon: const Icon(Icons.add_rounded),
        label: Text('Add Product', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB71C1C), AppColors.primaryRed],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Row(
        children: [
          Text(
            'Products',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface),
          ),
          const Spacer(),
          Icon(Icons.restaurant_menu_rounded, color: AppColors.whiteSurface.withValues(alpha: 0.8)),
        ],
      ),
    );
  }
}

class _ProductList extends StatelessWidget {
  final ProductKind kind;
  const _ProductList({required this.kind});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ProductModel>>(
      stream: ProductService.instance.getProducts(kind),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final products = snapshot.data ?? [];
        if (products.isEmpty) {
          return Center(
            child: Text('No products yet.',
                style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          );
        }
        return ListView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
          itemCount: products.length,
          itemBuilder: (_, i) {
            final p = products[i];
            return _ProductCard(
              product: p,
              onEdit: () {
                final route = switch (kind) {
                  ProductKind.fastFood => AppRoutes.addFastFood,
                  ProductKind.tiffinMeal => AppRoutes.addTiffin,
                  ProductKind.spice => AppRoutes.addSpice,
                };
                Navigator.pushNamed(
                  context,
                  route,
                  arguments: {'product': p},
                );
              },
              onDelete: () async {
                final confirm = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Delete Product'),
                    content: Text('Are you sure you want to delete ${p.name}?'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
                    ],
                  ),
                );
                if (confirm == true) {
                  await ProductService.instance.deleteProduct(p.id);
                }
              },
              onToggle: (v) {
                // For now, availability isn't in ProductModel, we could add it or just ignore for now.
                // Let's assume we update some field if needed.
              },
            );
          },
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _ProductCard({
    required this.product,
    required this.onEdit,
    required this.onDelete,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
                color: AppColors.lightPinkBg, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Text(product.emoji, style: const TextStyle(fontSize: 26)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                Text('₹${product.price.toStringAsFixed(0)}  ·  ⭐ ${product.ratingLabel}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.primaryRed, fontWeight: FontWeight.w500)),
                Text(_categoryDetail(product),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Switch.adaptive(
                value: true, // TODO: Add isAvailable to ProductModel
                onChanged: onToggle,
                activeTrackColor: AppColors.successGreen,
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: onEdit,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.edit_rounded, size: 18, color: Colors.blue),
                    ),
                  ),
                  InkWell(
                    onTap: onDelete,
                    borderRadius: BorderRadius.circular(8),
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.delete_rounded, size: 18, color: AppColors.primaryRed),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  static String _categoryDetail(ProductModel p) {
    switch (p.kind) {
      case ProductKind.fastFood:
        return '${p.subtitle} · ${p.deliveryEta ?? "20 min"}';
      case ProductKind.tiffinMeal:
        final n = p.mealComponents.length;
        return '${p.subtitle} · $n meal items';
      case ProductKind.spice:
        final n = p.weightPrices?.length ?? 0;
        return '${p.spiceCategory} · $n weight options';
    }
  }
}
