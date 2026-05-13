import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../../../models/product_model.dart';

class AddFastFoodScreen extends StatefulWidget {
  final ProductModel? product;

  const AddFastFoodScreen({super.key, this.product});

  @override
  State<AddFastFoodScreen> createState() => _AddFastFoodScreenState();
}

class _AddFastFoodScreenState extends State<AddFastFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _emojiCtrl;
  late TextEditingController _tagCtrl;
  late TextEditingController _ratingCtrl;
  late TextEditingController _etaCtrl;
  late bool _isAvailable;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.subtitle ?? '');
    _emojiCtrl = TextEditingController(text: p?.emoji ?? '🍔');
    _tagCtrl = TextEditingController(text: p?.tag ?? 'Popular');
    _ratingCtrl = TextEditingController(text: p != null ? p.rating.toString() : '4.5');
    _etaCtrl = TextEditingController(text: p?.deliveryEta ?? '20 min');
    _isAvailable = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _emojiCtrl.dispose();
    _tagCtrl.dispose();
    _ratingCtrl.dispose();
    _etaCtrl.dispose();
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
      kind: ProductKind.fastFood,
      tag: _tagCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text.trim()) ?? 4.5,
      deliveryEta: _etaCtrl.text.trim(),
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
            _isEditing ? 'Fast food updated!' : 'Fast food added!',
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
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 140,
            pinned: true,
            backgroundColor: AppColors.primaryRed,
            foregroundColor: AppColors.whiteSurface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFFB71C1C), AppColors.primaryRed],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
                ),
                child: SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        ValueListenableBuilder(
                          valueListenable: _emojiCtrl,
                          builder: (_, v, __) => Text(
                            v.text.isEmpty ? '🍔' : v.text,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEditing ? 'Edit Fast Food' : 'Add Fast Food',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.whiteSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _sectionLabel('Basic Info'),
                    const SizedBox(height: 8),
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
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _field(
                            controller: _priceCtrl,
                            label: 'Price (₹)',
                            hint: '149',
                            icon: Icons.currency_rupee_rounded,
                            keyboardType: TextInputType.number,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                            validator: (v) {
                              if (v == null || v.isEmpty) return 'Required';
                              if (double.tryParse(v) == null) return 'Invalid';
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: _field(
                            controller: _ratingCtrl,
                            label: 'Rating',
                            hint: '4.5',
                            icon: Icons.star_rounded,
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _descCtrl,
                      label: 'Description',
                      hint: 'Crispy patty with fresh veggies...',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Fast Food Details'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _field(
                            controller: _tagCtrl,
                            label: 'Tag',
                            hint: 'Popular',
                            icon: Icons.label_rounded,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _field(
                            controller: _etaCtrl,
                            label: 'Delivery ETA',
                            hint: '20 min',
                            icon: Icons.timer_rounded,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _availableToggle(),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded),
                        label: Text(_isEditing ? 'Update Fast Food' : 'Save Fast Food'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: AppColors.whiteSurface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 15),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w700,
        fontSize: 16,
        color: AppColors.textPrimary,
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
