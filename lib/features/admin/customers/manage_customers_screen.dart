import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/admin_service.dart';

class ManageCustomersScreen extends StatelessWidget {
  const ManageCustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: AdminService.instance.getCustomersStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final customers = snapshot.data ?? [];
          
          return Column(
            children: [
              _buildHeader(context, customers.length),
              Expanded(
                child: customers.isEmpty 
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                        itemCount: customers.length,
                        itemBuilder: (_, i) {
                          final c = customers[i];
                          return _CustomerCard(customer: c);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline_rounded, size: 64, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No customers found',
            style: GoogleFonts.poppins(color: AppColors.textSecondary, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, int count) {
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
            child: Text('$count users',
                style: GoogleFonts.poppins(color: AppColors.whiteSurface, fontSize: 12)),
          ),
        ],
      ),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;

  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final name = customer['name'] ?? 'User';
    final email = customer['email'] ?? 'No email';
    final phone = customer['phone'] ?? 'No phone';
    final isBlocked = customer['isBlocked'] ?? false;
    final uid = customer['uid'] ?? '';
    final initials = name.isNotEmpty ? name[0].toUpperCase() : 'U';

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
            backgroundColor: isBlocked ? const Color(0xFFFFEBEE) : AppColors.lightPinkBg,
            child: Text(
              initials,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.primaryRed,
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
                    Text(name,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: AppColors.textPrimary)),
                    const SizedBox(width: 8),
                    if (isBlocked)
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
                Text(email,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                Text(phone,
                    style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => AdminService.instance.toggleUserBlock(uid, isBlocked),
            style: TextButton.styleFrom(
              foregroundColor: isBlocked ? AppColors.successGreen : AppColors.primaryRed,
            ),
            child: Text(
              isBlocked ? 'Unblock' : 'Block',
              style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
