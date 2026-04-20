import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_routes.dart';
import '../../../data/admin_dummy_data.dart';

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
              children: [
                _ProductList(
                  products: AdminDummyData.fastFoodProducts,
                  category: 'Fast Food',
                ),
                _ProductList(
                  products: AdminDummyData.tiffinProducts,
                  category: 'Tiffin',
                ),
                _ProductList(
                  products: AdminDummyData.spicesProducts,
                  category: 'Spices',
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final categories = ['Fast Food', 'Tiffin', 'Spices'];
          final category = categories[_tabController.index];
          Navigator.pushNamed(
            context,
            AppRoutes.addEditProduct,
            arguments: {'category': category},
          );
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

class _ProductList extends StatefulWidget {
  final List<AdminProduct> products;
  final String category;
  const _ProductList({required this.products, required this.category});

  @override
  State<_ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<_ProductList> {
  void _deleteProduct(AdminProduct p) {
    setState(() => widget.products.remove(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${p.name} deleted', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) {
      return Center(
        child: Text('No products yet.',
            style: GoogleFonts.poppins(color: AppColors.textSecondary)),
      );
    }
    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      itemCount: widget.products.length,
      itemBuilder: (_, i) {
        final p = widget.products[i];
        return _ProductCard(
          product: p,
          onEdit: () async {
            await Navigator.pushNamed(
              context,
              AppRoutes.addEditProduct,
              arguments: {'product': p, 'category': widget.category},
            );
            if (mounted) setState(() {});
          },
          onDelete: () => _deleteProduct(p),
          onToggle: (v) => setState(() => p.isAvailable = v),
        );
      },
    );
  }
}

class _ProductCard extends StatelessWidget {
  final AdminProduct product;
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
                Text('₹${product.price.toStringAsFixed(0)}',
                    style: GoogleFonts.poppins(
                        fontSize: 13, color: AppColors.primaryRed, fontWeight: FontWeight.w500)),
                Text(product.description,
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
                value: product.isAvailable,
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
}
