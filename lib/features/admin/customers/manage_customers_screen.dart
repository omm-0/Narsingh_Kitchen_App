import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../data/admin_dummy_data.dart';

class ManageCustomersScreen extends StatefulWidget {
  const ManageCustomersScreen({super.key});

  @override
  State<ManageCustomersScreen> createState() => _ManageCustomersScreenState();
}

class _ManageCustomersScreenState extends State<ManageCustomersScreen> {
  final _customers = AdminDummyData.customers;

  void _toggleBlock(AdminCustomer c) {
    setState(() => c.isBlocked = !c.isBlocked);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          c.isBlocked ? '${c.name} blocked' : '${c.name} unblocked',
          style: GoogleFonts.poppins(),
        ),
        backgroundColor: c.isBlocked ? AppColors.primaryRed : AppColors.successGreen,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              itemCount: _customers.length,
              itemBuilder: (_, i) => _CustomerCard(
                customer: _customers[i],
                onToggleBlock: () => _toggleBlock(_customers[i]),
              ),
            ),
          ),
        ],
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
            'Customers',
            style: GoogleFonts.poppins(
                fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppColors.whiteSurface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text('${_customers.length} users',
                style: GoogleFonts.poppins(color: AppColors.whiteSurface, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final AdminCustomer customer;
  final VoidCallback onToggleBlock;

  const _CustomerCard({required this.customer, required this.onToggleBlock});

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
          CircleAvatar(
            radius: 24,
            backgroundColor:
                customer.isBlocked ? const Color(0xFFFFEBEE) : AppColors.lightPinkBg,
            child: Text(
              customer.initials,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: customer.isBlocked ? AppColors.primaryRed : AppColors.primaryRed,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(customer.name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    if (customer.isBlocked)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFEBEE),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('Blocked',
                            style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryRed)),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(customer.email,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text(customer.phone,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          TextButton(
            onPressed: onToggleBlock,
            style: TextButton.styleFrom(
              foregroundColor:
                  customer.isBlocked ? AppColors.successGreen : AppColors.primaryRed,
            ),
            child: Text(
              customer.isBlocked ? 'Unblock' : 'Block',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
