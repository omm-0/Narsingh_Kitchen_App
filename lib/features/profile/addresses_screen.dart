import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/services/auth_service.dart';
import '../../models/address_model.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.instance.currentUser;
    if (user == null) return const Scaffold(body: Center(child: Text('Please sign in')));

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'My Addresses',
          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 24, color: AppColors.textPrimary),
        ),
      ),
      body: StreamBuilder<List<AddressModel>>(
        stream: AuthService.instance.getAddressesStream(user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final addresses = snapshot.data ?? [];
          if (addresses.isEmpty) {
            return _buildEmptyState(context, user.uid);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(24),
            itemCount: addresses.length,
            itemBuilder: (context, index) {
              final address = addresses[index];
              return _addressCard(context, user.uid, address);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddAddress(context, user.uid),
        backgroundColor: AppColors.primaryRed,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text('Add New', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String uid) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.location_off_rounded, size: 80, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 24),
          Text(
            'No Addresses Found',
            style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 8),
          Text(
            'Add your delivery addresses to get started',
            style: GoogleFonts.outfit(color: AppColors.textSecondary),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () => _showAddAddress(context, uid),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Add Address', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(BuildContext context, String uid, AddressModel address) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.cardShadow,
        border: address.isDefault ? Border.all(color: AppColors.primaryRed, width: 2) : null,
      ),
      child: InkWell(
        onTap: () => AuthService.instance.setDefaultAddress(uid, address.id),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: (address.isDefault ? AppColors.primaryRed : AppColors.textSecondary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  address.label.toLowerCase() == 'home' ? Icons.home_rounded : Icons.work_rounded,
                  color: address.isDefault ? AppColors.primaryRed : AppColors.textSecondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          address.label,
                          style: GoogleFonts.outfit(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.textPrimary),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: AppColors.primaryRed, borderRadius: BorderRadius.circular(8)),
                            child: Text('DEFAULT', style: GoogleFonts.outfit(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      address.fullAddress,
                      style: GoogleFonts.outfit(color: AppColors.textSecondary, height: 1.4),
                    ),
                    if (address.houseNo != null && address.houseNo!.isNotEmpty)
                      Text(
                        'House No: ${address.houseNo}',
                        style: GoogleFonts.outfit(color: AppColors.textSecondary, fontSize: 12),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => AuthService.instance.deleteAddress(uid, address.id),
                icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAddAddress(BuildContext context, String uid) {
    final labelController = TextEditingController();
    final addressController = TextEditingController();
    final houseController = TextEditingController();
    final landmarkController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          top: 24, left: 24, right: 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Add New Address', style: GoogleFonts.outfit(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.textPrimary)),
              const SizedBox(height: 24),
              _textField(labelController, 'Label (e.g. Home, Office)', Icons.label_outline_rounded),
              const SizedBox(height: 16),
              _textField(addressController, 'Full Address', Icons.location_on_outlined),
              const SizedBox(height: 16),
              _textField(houseController, 'House/Flat No.', Icons.house_outlined),
              const SizedBox(height: 16),
              _textField(landmarkController, 'Landmark', Icons.map_outlined),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (addressController.text.isEmpty) return;
                    await AuthService.instance.addAddress(uid, AddressModel(
                      id: '',
                      label: labelController.text.isEmpty ? 'Home' : labelController.text,
                      fullAddress: addressController.text,
                      houseNo: houseController.text,
                      landmark: landmarkController.text,
                    ));
                    if (context.mounted) Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Save Address', style: GoogleFonts.outfit(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _textField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryRed, size: 20),
        filled: true,
        fillColor: AppColors.lightGrayBg,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
      ),
    );
  }
}
