import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/admin_service.dart';

class ManagePromosScreen extends StatelessWidget {
  const ManagePromosScreen({super.key});

  void _showAddDialog(BuildContext context) {
    final codeCtrl = TextEditingController();
    final discountCtrl = TextEditingController();
    final expiryCtrl = TextEditingController();
    
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('New Promo Code',
            style: GoogleFonts.poppins(fontWeight: FontWeight.w700)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _dialogField(codeCtrl, 'Code', 'SAVE10'),
              const SizedBox(height: 10),
              _dialogField(discountCtrl, 'Discount %', '10', type: TextInputType.number),
              const SizedBox(height: 10),
              _dialogField(expiryCtrl, 'Expiry Date', '31 Dec 2026'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeCtrl.text.isNotEmpty && discountCtrl.text.isNotEmpty) {
                await AdminService.instance.addPromo({
                  'code': codeCtrl.text.toUpperCase(),
                  'discountPercent': int.tryParse(discountCtrl.text) ?? 5,
                  'expiry': expiryCtrl.text.isEmpty ? 'N/A' : expiryCtrl.text,
                  'isActive': true,
                  'createdAt': DateTime.now().toIso8601String(),
                });
                if (ctx.mounted) Navigator.pop(ctx);
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

  Widget _dialogField(TextEditingController ctrl, String label, String hint, {TextInputType type = TextInputType.text}) {
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
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: AdminService.instance.getPromosStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final promos = snapshot.data ?? [];

          return Column(
            children: [
              _header(context),
              Expanded(
                child: promos.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: promos.length,
                        itemBuilder: (_, i) => _PromoCard(promo: promos[i]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.whiteSurface,
        icon: const Icon(Icons.add_rounded),
        label: Text('New Promo', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.local_offer_outlined, size: 64, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No promo codes yet',
            style: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
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
  final Map<String, dynamic> promo;

  const _PromoCard({required this.promo});

  @override
  Widget build(BuildContext context) {
    final code = promo['code'] ?? 'CODE';
    final discount = promo['discountPercent'] ?? 0;
    final expiry = promo['expiry'] ?? 'N/A';
    final isActive = promo['isActive'] ?? false;
    final id = promo['id'] ?? '';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
        border: Border.all(
          color: isActive ? const Color(0xFFFFCDD2) : AppColors.dividerGray,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? AppColors.lightPinkBg : AppColors.lightGrayBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              code,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: isActive ? AppColors.primaryRed : AppColors.textSecondary,
                letterSpacing: 1,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$discount% off',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary)),
                Text('Expires: $expiry',
                    style: GoogleFonts.poppins(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          Switch.adaptive(
            value: isActive,
            onChanged: (v) => AdminService.instance.togglePromo(id, isActive),
            activeTrackColor: AppColors.successGreen,
          ),
          InkWell(
            onTap: () => AdminService.instance.deletePromo(id),
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
