import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/product_service.dart';
import '../../../models/product_model.dart';

class AddSpiceScreen extends StatefulWidget {
  final ProductModel? product;

  const AddSpiceScreen({super.key, this.product});

  @override
  State<AddSpiceScreen> createState() => _AddSpiceScreenState();
}

class _AddSpiceScreenState extends State<AddSpiceScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _priceCtrl;
  late TextEditingController _descCtrl;
  late TextEditingController _emojiCtrl;
  late TextEditingController _tagCtrl;
  late TextEditingController _ratingCtrl;
  late TextEditingController _purityCtrl;
  late TextEditingController _farmRegionCtrl;
  late String _spiceCategory;
  late bool _isAvailable;

  // Weight price controllers
  final List<_WeightEntry> _weightEntries = [];

  bool get _isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    _nameCtrl = TextEditingController(text: p?.name ?? '');
    _priceCtrl = TextEditingController(text: p != null ? p.price.toStringAsFixed(0) : '');
    _descCtrl = TextEditingController(text: p?.subtitle ?? '');
    _emojiCtrl = TextEditingController(text: p?.emoji ?? '🌶️');
    _tagCtrl = TextEditingController(text: p?.tag ?? 'Farm Fresh');
    _ratingCtrl = TextEditingController(text: p != null ? p.rating.toString() : '4.5');
    _purityCtrl = TextEditingController(
      text: p?.purityPercent?.toStringAsFixed(1) ?? '98.0',
    );
    _farmRegionCtrl = TextEditingController(
      text: p?.farmRegion ?? 'Partner farms across Rajasthan',
    );
    _spiceCategory = p?.spiceCategory ?? 'Whole';
    _isAvailable = true;

    // Init weight entries from existing product
    if (p?.weightPrices != null && p!.weightPrices!.isNotEmpty) {
      for (final entry in p.weightPrices!.entries) {
        _weightEntries.add(_WeightEntry(
          labelCtrl: TextEditingController(text: entry.key),
          priceCtrl: TextEditingController(text: entry.value.toStringAsFixed(0)),
        ));
      }
    } else {
      // Default weight options
      _weightEntries.addAll([
        _WeightEntry(
          labelCtrl: TextEditingController(text: '100g'),
          priceCtrl: TextEditingController(),
        ),
        _WeightEntry(
          labelCtrl: TextEditingController(text: '250g'),
          priceCtrl: TextEditingController(),
        ),
        _WeightEntry(
          labelCtrl: TextEditingController(text: '500g'),
          priceCtrl: TextEditingController(),
        ),
        _WeightEntry(
          labelCtrl: TextEditingController(text: '1kg'),
          priceCtrl: TextEditingController(),
        ),
      ]);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _priceCtrl.dispose();
    _descCtrl.dispose();
    _emojiCtrl.dispose();
    _tagCtrl.dispose();
    _ratingCtrl.dispose();
    _purityCtrl.dispose();
    _farmRegionCtrl.dispose();
    for (final e in _weightEntries) {
      e.labelCtrl.dispose();
      e.priceCtrl.dispose();
    }
    super.dispose();
  }

  Map<String, double> _buildWeightPrices() {
    final map = <String, double>{};
    for (final e in _weightEntries) {
      final label = e.labelCtrl.text.trim();
      final price = double.tryParse(e.priceCtrl.text.trim());
      if (label.isNotEmpty && price != null && price > 0) {
        map[label] = price;
      }
    }
    return map;
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    final weightPrices = _buildWeightPrices();
    final basePrice = double.parse(_priceCtrl.text.trim());

    final product = ProductModel(
      id: widget.product?.id ?? '',
      name: _nameCtrl.text.trim(),
      price: basePrice,
      subtitle: _descCtrl.text.trim(),
      emoji: _emojiCtrl.text.trim(),
      kind: ProductKind.spice,
      tag: _tagCtrl.text.trim(),
      rating: double.tryParse(_ratingCtrl.text.trim()) ?? 4.5,
      spiceCategory: _spiceCategory,
      weightPrices: weightPrices.isNotEmpty ? weightPrices : null,
      purityPercent: double.tryParse(_purityCtrl.text.trim()) ?? 98.0,
      farmRegion: _farmRegionCtrl.text.trim(),
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
            _isEditing ? 'Spice updated!' : 'Spice added!',
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
            backgroundColor: AppColors.primaryBrown,
            foregroundColor: AppColors.whiteSurface,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primaryBrown,
                      AppColors.primaryBrown.withValues(alpha: 0.82),
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
                            v.text.isEmpty ? '🌶️' : v.text,
                            style: const TextStyle(fontSize: 48),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isEditing ? 'Edit Spice' : 'Add Spice',
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
                      hint: '🌶️',
                      icon: Icons.emoji_emotions_outlined,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _nameCtrl,
                      label: 'Spice Name',
                      hint: 'e.g. Kashmiri Red Chilli',
                      icon: Icons.spa_rounded,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: _field(
                            controller: _priceCtrl,
                            label: 'Base Price (₹)',
                            hint: '179',
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
                      hint: 'Premium quality whole spice...',
                      icon: Icons.notes_rounded,
                      maxLines: 3,
                      validator: (v) => v == null || v.trim().isEmpty ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _tagCtrl,
                      label: 'Tag',
                      hint: 'Farm Fresh',
                      icon: Icons.label_rounded,
                    ),
                    const SizedBox(height: 24),

                    _sectionLabel('Spice Category'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _spiceCategory,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category_rounded, size: 20),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                        filled: true,
                        fillColor: AppColors.whiteSurface,
                      ),
                      style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                      items: const ['Whole', 'Ground', 'Blends', 'Seeds']
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => _spiceCategory = v!),
                    ),
                    const SizedBox(height: 24),

                    _sectionLabel('Weight Prices'),
                    const SizedBox(height: 4),
                    Text(
                      'Set price for each pack size',
                      style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 8),
                    ..._weightEntries.asMap().entries.map((e) {
                      final idx = e.key;
                      final entry = e.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: entry.labelCtrl,
                                style: GoogleFonts.poppins(fontSize: 14),
                                decoration: InputDecoration(
                                  labelText: 'Weight',
                                  hintText: '500g',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.whiteSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: entry.priceCtrl,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                style: GoogleFonts.poppins(fontSize: 14),
                                decoration: InputDecoration(
                                  labelText: 'Price (₹)',
                                  hintText: '179',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  filled: true,
                                  fillColor: AppColors.whiteSurface,
                                ),
                              ),
                            ),
                            const SizedBox(width: 6),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _weightEntries[idx].labelCtrl.dispose();
                                  _weightEntries[idx].priceCtrl.dispose();
                                  _weightEntries.removeAt(idx);
                                });
                              },
                              borderRadius: BorderRadius.circular(8),
                              child: const Padding(
                                padding: EdgeInsets.all(6),
                                child: Icon(Icons.remove_circle_outline,
                                    size: 22, color: AppColors.primaryRed),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () {
                          setState(() {
                            _weightEntries.add(_WeightEntry(
                              labelCtrl: TextEditingController(),
                              priceCtrl: TextEditingController(),
                            ));
                          });
                        },
                        icon: const Icon(Icons.add_rounded, size: 18),
                        label: Text('Add weight option',
                            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13)),
                        style: TextButton.styleFrom(foregroundColor: AppColors.primaryBrown),
                      ),
                    ),
                    const SizedBox(height: 20),

                    _sectionLabel('Quality & Origin'),
                    const SizedBox(height: 8),
                    _field(
                      controller: _purityCtrl,
                      label: 'Purity %',
                      hint: '98.0',
                      icon: Icons.verified_rounded,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    _field(
                      controller: _farmRegionCtrl,
                      label: 'Farm / Source Region',
                      hint: 'Partner farms across Rajasthan',
                      icon: Icons.agriculture_rounded,
                      maxLines: 2,
                    ),
                    const SizedBox(height: 16),
                    _availableToggle(),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 54,
                      child: ElevatedButton.icon(
                        onPressed: _save,
                        icon: Icon(_isEditing ? Icons.check_rounded : Icons.add_rounded),
                        label: Text(_isEditing ? 'Update Spice' : 'Save Spice'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBrown,
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

class _WeightEntry {
  final TextEditingController labelCtrl;
  final TextEditingController priceCtrl;

  _WeightEntry({required this.labelCtrl, required this.priceCtrl});
}
