import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/admin_dummy_data.dart';

class ManagePromosScreen extends StatefulWidget {
  const ManagePromosScreen({super.key});

  @override
  State<ManagePromosScreen> createState() => _ManagePromosScreenState();
}

class _ManagePromosScreenState extends State<ManagePromosScreen> {
  final _promos = AdminDummyData.promos;

  void _delete(PromoCode p) {
    setState(() => _promos.remove(p));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Promo ${p.code} deleted', style: GoogleFonts.poppins()),
        backgroundColor: AppColors.primaryRed,
      ),
    );
  }

  void _showAddDialog() {
    final codeCtrl = TextEditingController();
    final discountCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('New Promo Code',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(codeCtrl, 'Code', 'SAVE10'),
              const SizedBox(height: 10),
              _dialogField(discountCtrl, 'Discount %', '10',
                  type: TextInputType.number),
              const SizedBox(height: 10),
              _dialogField(expiryCtrl, 'Expiry Date', '31 Dec 2026'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeCtrl.text.isNotEmpty && discountCtrl.text.isNotEmpty) {
                setState(() {
                  _promos.add(PromoCode(
                    id: 'PRO-${_promos.length + 1}',
                    code: codeCtrl.text.toUpperCase(),
                    discountPercent: int.tryParse(discountCtrl.text) ?? 5,
                    expiry: expiryCtrl.text.isEmpty ? 'N/A' : expiryCtrl.text,
                  ));
                });
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: AppColors.whiteSurface,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text('Add', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _dialogField(TextEditingController ctrl, String label, String hint,
      {TextInputType type = TextInputType.text}) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: _promos.isEmpty
                ? Center(
                    child: Text('No promo codes yet.',
                        style: GoogleFonts.poppins(color: AppColors.textSecondary)))
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                    itemCount: _promos.length,
                    itemBuilder: (_, i) => _PromoCard(
                      promo: _promos[i],
                      onDelete: () => _delete(_promos[i]),
                      onToggle: (v) => setState(() => _promos[i].isActive = v),
                    ),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.whiteSurface,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Promo', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _header(BuildContext context) {
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
          Text('Promo Codes',
              style: GoogleFonts.poppins(
                  fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface)),
          const Spacer(),
          Icon(Icons.local_offer_rounded, color: AppColors.whiteSurface.withValues(alpha: 0.8)),
        ],
      ),
    );
  }
}

class _PromoCard extends StatelessWidget {
  final PromoCode promo;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggle;

  const _PromoCard({required this.promo, required this.onDelete, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border.all(
          color: promo.isActive ? const Color(0xFFFFCDD2) : AppColors.dividerGray,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: promo.isActive ? AppColors.lightPinkBg : AppColors.lightGrayBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              promo.code,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: promo.isActive ? AppColors.primaryRed : AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${promo.discountPercent}% off',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                Text('Expires: ${promo.expiry}',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: promo.isActive,
            onChanged: onToggle,
            activeTrackColor: AppColors.successGreen,
          ),
          InkWell(
            onTap: onDelete,
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(Icons.delete_rounded, size: 20, color: AppColors.primaryRed),
            ),
          ),
        ],
      ),
    );
  }
}
