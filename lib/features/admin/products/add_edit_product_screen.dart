import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../../../models/product_model.dart';

class AddEditProductScreen extends StatefulWidget {
  final ProductModel? product;
  final ProductKind initialKind;

  const AddEditProductScreen({
    super.key,
    this.product,
    required this.initialKind,
  });

  @override
  State<AddEditProductScreen> createState() => _AddEditProductScreenState();
}

class _AddEditProductScreenState extends State<AddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _emojiCtrl;
  late ProductKind _selectedKind;
  late bool _isAvailable;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.subtitle ?? '');
    _emojiCtrl = TextEditingController(text: p?.emoji ?? '🍽️');
    _selectedKind = p?.kind ?? widget.initialKind;
    _isAvailable = true; // Placeholder for now
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      id: widget.product?.id ?? '',
      name: _nameCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      subtitle: _descCtrl.text.trim(),
      emoji: _emojiCtrl.text.trim(),
      kind: _selectedKind,
      tag: 'New', 
      rating: widget.product?.rating ?? 5.0,
      spiceCategory: widget.product?.spiceCategory ?? 'All',
      weightPrices: widget.product?.weightPrices,
      mealComponents: widget.product?.mealComponents ?? [],
      nutritionLines: widget.product?.nutritionLines ?? [],
      weeklyRotation: widget.product?.weeklyRotation ?? [],
    );

    if (_isEditing) {
      await ProductService.instance.updateProduct(product);
    } else {
      await ProductService.instance.addProduct(product);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Product updated!' : 'Product added!',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'Edit Product' : 'Add Product',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: AppColors.whiteSurface),
        ),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.whiteSurface,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _emojiPreview(),
              const SizedBox(height: 16),
              _field(
                controller: _emojiCtrl,
                label: 'Emoji / Icon',
                hint: '🍔',
                icon: Icons.emoji_emotions_outlined,
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              _field(
                controller: _nameCtrl,
                label: 'Product Name',
                hint: 'e.g. Veg Burger',
                icon: Icons.fastfood_rounded,
                validator: (v) => v == null || v.trim().isEmpty ? 'Name is required' : null,
              ),
              const SizedBox(height: 12),
              _field(
                controller: _priceCtrl,
                label: 'Price (₹)',
                hint: '149',
                icon: Icons.currency_rupee_rounded,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Price is required';
                  if (double.tryParse(v) == null) return 'Enter valid price';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              _kindDropdown(),
              const SizedBox(height: 12),
              _field(
                controller: _descCtrl,
                label: 'Description',
                hint: 'Short product description',
                icon: Icons.notes_rounded,
                maxLines: 3,
                validator: (v) => v == null || v.trim().isEmpty ? 'Description is required' : null,
              ),
              const SizedBox(height: 16),
              _availableToggle(),
              const SizedBox(height: 24),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    foregroundColor: AppColors.whiteSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  child: Text(_isEditing ? 'Update Product' : 'Save Product'),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _kindDropdown() {
    return DropdownButtonFormField<ProductKind>(
      value: _selectedKind,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category_rounded, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.whiteSurface,
      ),
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
      items: ProductKind.values
          .map((k) => DropdownMenuItem(
                value: k,
                child: Text(k == ProductKind.fastFood
                    ? 'Fast Food'
                    : k == ProductKind.tiffinMeal
                        ? 'Tiffin'
                        : 'Spices'),
              ))
          .toList(),
      onChanged: (v) => setState(() => _selectedKind = v!),
    );
  }

  Widget _emojiPreview() {
    return Center(
      child: Container(
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          color: AppColors.lightPinkBg,
          borderRadius: BorderRadius.circular(24),
          boxShadow: AppColors.cardShadow,
        ),
        alignment: Alignment.center,
        child: ValueListenableBuilder(
          valueListenable: _emojiCtrl,
          builder: (_, v, _) => Text(
            v.text.isEmpty ? '🍽️' : v.text,
            style: const TextStyle(fontSize: 44),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.whiteSurface,
      ),
    );
  }

  // _kindDropdown handles this now.

  Widget _availableToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(14),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Available for Order',
              style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary)),
          Switch.adaptive(
            value: _isAvailable,
            onChanged: (v) => setState(() => _isAvailable = v),
            activeTrackColor: AppColors.successGreen,
          ),
        ],
      ),
    );
  }
}
