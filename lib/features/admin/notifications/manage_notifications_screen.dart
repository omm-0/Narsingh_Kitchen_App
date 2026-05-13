import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/admin_service.dart';

class ManageNotificationsScreen extends StatelessWidget {
  const ManageNotificationsScreen({super.key});

  void _showSendDialog(BuildContext context) {
    final titleCtrl = TextEditingController();
    final msgCtrl = TextEditingController();
    String selectedAudience = 'All';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (innerCtx, setLocal) => Container(
          decoration: const BoxDecoration(
            color: AppColors.whiteSurface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            left: 20, right: 20, top: 20,
            bottom: MediaQuery.of(innerCtx).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40, height: 4,
                  decoration: BoxDecoration(color: AppColors.dividerGray, borderRadius: BorderRadius.circular(4)),
                ),
              ),
              const SizedBox(height: 16),
              Text('Send Notification', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 16),
              TextField(
                controller: titleCtrl,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: msgCtrl,
                maxLines: 3,
                style: GoogleFonts.poppins(fontSize: 14),
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                ),
              ),
              const SizedBox(height: 12),
              InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Audience',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedAudience,
                    isExpanded: true,
                    style: GoogleFonts.poppins(fontSize: 14, color: AppColors.textPrimary),
                    items: ['All', 'Customers', 'Subscribers']
                        .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                        .toList(),
                    onChanged: (v) => setLocal(() => selectedAudience = v!),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    if (titleCtrl.text.isNotEmpty && msgCtrl.text.isNotEmpty) {
                      await AdminService.instance.sendNotification({
                        'title': titleCtrl.text,
                        'message': msgCtrl.text,
                        'audience': selectedAudience,
                      });
                      if (innerCtx.mounted) Navigator.pop(innerCtx);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text('Send Now', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: AdminService.instance.getSentNotificationsStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final notifications = snapshot.data ?? [];

          return Column(
            children: [
              _header(context),
              Expanded(
                child: notifications.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
                        itemCount: notifications.length,
                        itemBuilder: (_, i) => _NotificationCard(data: notifications[i]),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showSendDialog(context),
        backgroundColor: AppColors.primaryRed,
        foregroundColor: AppColors.whiteSurface,
        icon: const Icon(Icons.send_rounded),
        label: Text('Send New', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.notifications_none_rounded, size: 64, color: AppColors.dividerGray.withValues(alpha: 0.5)),
          const SizedBox(height: 16),
          Text(
            'No notifications sent yet',
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
        left: 20, right: 20, bottom: 20,
      ),
      child: Row(
        children: [
          Text('Notifications', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: AppColors.whiteSurface)),
          const Spacer(),
          Icon(Icons.notifications_rounded, color: AppColors.whiteSurface.withValues(alpha: 0.8)),
        ],
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _NotificationCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color audienceColor;
    switch (data['audience']) {
      case 'Customers': audienceColor = Colors.blue;
      case 'Subscribers': audienceColor = AppColors.primaryOrange;
      default: audienceColor = AppColors.successGreen;
    }

    String dateStr = 'Just now';
    if (data['createdAt'] != null) {
      final timestamp = data['createdAt'] as Timestamp;
      dateStr = DateFormat('dd MMM, hh:mm a').format(timestamp.toDate());
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.whiteSurface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppColors.cardShadow,
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42, height: 42,
            decoration: BoxDecoration(color: AppColors.lightPinkBg, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: const Icon(Icons.notifications_rounded, color: AppColors.primaryRed, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data['title'] ?? '', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13, color: AppColors.textPrimary)),
                const SizedBox(height: 3),
                Text(data['message'] ?? '', style: GoogleFonts.poppins(fontSize: 12, color: AppColors.textSecondary)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: audienceColor.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(10)),
                      child: Text(data['audience'] ?? 'All', style: GoogleFonts.poppins(fontSize: 10, fontWeight: FontWeight.w600, color: audienceColor)),
                    ),
                    const Spacer(),
                    Text(dateStr, style: GoogleFonts.poppins(fontSize: 10, color: AppColors.textSecondary)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
