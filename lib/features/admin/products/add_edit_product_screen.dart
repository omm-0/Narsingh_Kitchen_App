import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/admin_dummy_data.dart';

class AddEditProductScreen extends StatefulWidget {
  final AdminProduct? product;
  final String initialCategory;

  const AddEditProductScreen({
    super.key,
    this.product,
    required this.initialCategory,
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
  late String _selectedCategory;
  late bool _isAvailable;

  final _categories = ['Fast Food', 'Tiffin', 'Spices'];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.description ?? '');
    _emojiCtrl = TextEditingController(text: p?.emoji ?? '🍽️');
    _selectedCategory = p?.category ?? widget.initialCategory;
    _isAvailable = p?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _emojiCtrl.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    if (_isEditing) {
      widget.product!
        ..name = _nameCtrl.text.trim()
        ..price = double.parse(_priceCtrl.text.trim())
        ..description = _descCtrl.text.trim()
        ..emoji = _emojiCtrl.text.trim()
        ..category = _selectedCategory
        ..isAvailable = _isAvailable;
    } else {
      final newProduct = AdminProduct(
        id: 'P-${DateTime.now().millisecondsSinceEpoch}',
        name: _nameCtrl.text.trim(),
        price: double.parse(_priceCtrl.text.trim()),
        category: _selectedCategory,
        description: _descCtrl.text.trim(),
        emoji: _emojiCtrl.text.trim(),
        isAvailable: _isAvailable,
      );
      switch (_selectedCategory) {
        case 'Fast Food':
          AdminDummyData.fastFoodProducts.add(newProduct);
        case 'Tiffin':
          AdminDummyData.tiffinProducts.add(newProduct);
        case 'Spices':
          AdminDummyData.spicesProducts.add(newProduct);
      }
    }
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
              _categoryDropdown(),
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

  Widget _categoryDropdown() {
    return DropdownButtonFormField<String>(
      initialValue: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        prefixIcon: const Icon(Icons.category_rounded, size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.whiteSurface,
      ),
      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
      items: _categories
          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
          .toList(),
      onChanged: (v) => setState(() => _selectedCategory = v!),
    );
  }

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
