import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../../../models/product_model.dart';

class AddTiffinScreen extends StatefulWidget {
  final ProductModel? product;

  const AddTiffinScreen({super.key, this.product});

  @override
  State<AddTiffinScreen> createState() => _AddTiffinScreenState();
}

class _AddTiffinScreenState extends State<AddTiffinScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _emojiCtrl;
  late TextEditingController _tagCtrl;
  late TextEditingController _ratingCtrl;
  late TextEditingController _mealComponentsCtrl;
  late TextEditingController _nutritionCtrl;
  late TextEditingController _weeklyRotationCtrl;
  late bool _isAvailable;

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.subtitle ?? '');
    _emojiCtrl = TextEditingController(text: p?.emoji ?? '🍱');
    _tagCtrl = TextEditingController(text: p?.tag ?? 'Pure Veg');
    _ratingCtrl = TextEditingController(text: p != null ? p.rating.toString() : '4.5');
    _mealComponentsCtrl = TextEditingController(
      text: p?.mealComponents.join('\n') ?? '',
    );
    _nutritionCtrl = TextEditingController(
      text: p?.nutritionLines.join('\n') ?? '',
    );
    _weeklyRotationCtrl = TextEditingController(
      text: p?.weeklyRotation.join('\n') ?? '',
    );
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
    _mealComponentsCtrl.dispose();
    _nutritionCtrl.dispose();
    _weeklyRotationCtrl.dispose();
    super.dispose();
  }

  List<String> _linesToList(String text) {
    return text
        .split('\n')
        .map((l) => l.trim())
        .where((l) => l.isNotEmpty)
        .toList();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      id: widget.product?.id ?? '',
      name: _nameCtrl.text.trim(),
      price: double.parse(_priceCtrl.text.trim()),
      subtitle: _descCtrl.text.trim(),
      emoji: _emojiCtrl.text.trim(),
      kind: ProductKind.tiffinMeal,
      tag: _tagCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text.trim()) ?? 4.5,
      mealComponents: _linesToList(_mealComponentsCtrl.text),
      nutritionLines: _linesToList(_nutritionCtrl.text),
      weeklyRotation: _linesToList(_weeklyRotationCtrl.text),
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
            _isEditing ? 'Tiffin meal updated!' : 'Tiffin meal added!',
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
            backgroundColor: AppColors.primaryOrange,
            foregroundColor: AppColors.whiteSurface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryOrange,
                      AppColors.primaryOrange.withValues(alpha: 0.78),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
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
                            v.text.isEmpty ? '🍱' : v.text,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEditing ? 'Edit Tiffin Meal' : 'Add Tiffin Meal',
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
                      hint: '🍱',
                      icon: Icons.emoji_emotions_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _nameCtrl,
                      label: 'Meal Name',
                      hint: 'e.g. North Indian Thali',
                      icon: Icons.lunch_dining_rounded,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _field(
                            controller: _priceCtrl,
                            label: 'Price per meal (₹)',
                            hint: '80',
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
                      hint: 'Home-cooked balanced meal...',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _tagCtrl,
                      label: 'Tag',
                      hint: 'Pure Veg',
                      icon: Icons.label_rounded,
                    ),
                    const SizedBox(height: 24),

                    _sectionLabel('Meal Components'),
                    const SizedBox(height: 4),
                    Text(
                      'One item per line (e.g. "Dal Tadka", "2 Roti")',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      controller: _mealComponentsCtrl,
                      label: 'Meal Items',
                      hint: 'Dal Tadka\n2 Roti\nJeera Rice\nSalad\nPickle',
                      icon: Icons.restaurant_menu_rounded,
                      maxLines: 6,
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Nutrition Snapshot'),
                    const SizedBox(height: 4),
                    Text(
                      'One line per entry (e.g. "Calories: ~550 kcal")',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      controller: _nutritionCtrl,
                      label: 'Nutrition Info',
                      hint: 'Calories: ~550 kcal\nProtein: 18g\nCarbs: 70g\nFat: 12g',
                      icon: Icons.monitor_heart_rounded,
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Weekly Rotation'),
                    const SizedBox(height: 4),
                    Text(
                      'One day per line (e.g. "Mon – Rajma Rice")',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    _field(
                      controller: _weeklyRotationCtrl,
                      label: 'Weekly Menu',
                      hint: 'Mon – Rajma Rice\nTue – Paneer Roti\nWed – Chole Rice',
                      icon: Icons.calendar_month_rounded,
                      maxLines: 7,
                    ),
                    const SizedBox(height: 16),
                    _availableToggle(),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded),
                        label: Text(_isEditing ? 'Update Tiffin Meal' : 'Save Tiffin Meal'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryOrange,
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
        prefixIcon: Padding(
          padding: EdgeInsets.only(bottom: maxLines > 1 ? (maxLines - 1) * 20.0 : 0),
          child: Icon(icon, size: 20),
        ),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        filled: true,
        fillColor: AppColors.whiteSurface,
        alignLabelWithHint: true,
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
