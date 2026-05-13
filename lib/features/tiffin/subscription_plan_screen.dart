import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_routes.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/subscription_service.dart';
import '../../models/subscription_model.dart';

class SubscriptionPlanScreen extends StatefulWidget {
  const SubscriptionPlanScreen({super.key});

  @override
  State<SubscriptionPlanScreen> createState() => _SubscriptionPlanScreenState();
}

class _SubscriptionPlanScreenState extends State<SubscriptionPlanScreen> {
  String? _selectedId;

  @override
  Widget build(BuildContext context) {
    final routeArg = ModalRoute.of(context)?.settings.arguments;
    final argPlans = routeArg is List<SubscriptionModel> ? routeArg : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: StreamBuilder<List<SubscriptionModel>>(
        stream: SubscriptionService.instance.getPlans(),
        builder: (context, snapshot) {
          final plans = (argPlans != null && argPlans.isNotEmpty)
              ? argPlans
              : (snapshot.data ?? const <SubscriptionModel>[]);
          if (plans.isNotEmpty && !_hasSelected(plans)) {
            final highlighted = plans.where((p) => p.highlight).toList();
            _selectedId = highlighted.isEmpty
                ? plans.first.id
                : highlighted.first.id;
          }

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 20, 8),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.maybePop(context),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                      ),
                      Expanded(
                        child: Text(
                          'Choose your plan',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
                Expanded(
                  child: plans.isEmpty
                      ? Center(
                          child: Text(
                            'No subscription plans available right now.',
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        )
                      : ListView.separated(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
                          itemCount: plans.length,
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 14),
                          itemBuilder: (context, index) {
                            final plan = plans[index];
                            final selected = _selectedId == plan.id;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              curve: Curves.easeOutCubic,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: selected
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.primaryOrange,
                                          AppColors.primaryOrange.withValues(
                                            alpha: 0.82,
                                          ),
                                        ],
                                      )
                                    : null,
                                color: selected ? null : AppColors.whiteSurface,
                                border: Border.all(
                                  color: selected
                                      ? Colors.transparent
                                      : AppColors.dividerGray,
                                  width: 1.2,
                                ),
                                boxShadow: selected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primaryOrange
                                              .withValues(alpha: 0.35),
                                          blurRadius: 24,
                                          offset: const Offset(0, 12),
                                        ),
                                      ]
                                    : AppColors.cardShadow,
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(22),
                                  customBorder: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                  onTap: () =>
                                      setState(() => _selectedId = plan.id),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                              child: Text(
                                                plan.title,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w700,
                                                  fontSize: 19,
                                                  color: selected
                                                      ? AppColors.whiteSurface
                                                      : AppColors.textPrimary,
                                                ),
                                              ),
                                            ),
                                            if (plan.highlight)
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: selected
                                                      ? AppColors.whiteSurface
                                                            .withValues(
                                                              alpha: 0.2,
                                                            )
                                                      : AppColors.lightOrangeBg,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                ),
                                                child: Text(
                                                  'Best value',
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 11,
                                                    color: selected
                                                        ? AppColors.whiteSurface
                                                        : AppColors
                                                              .primaryOrange,
                                                  ),
                                                ),
                                              ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          plan.mealsLabel,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 13,
                                            color: selected
                                                ? AppColors.whiteSurface
                                                      .withValues(alpha: 0.9)
                                                : AppColors.textSecondary,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Row(
                                          children: [
                                            Text(
                                              '₹${plan.price.toStringAsFixed(0)}',
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 26,
                                                color: selected
                                                    ? AppColors.whiteSurface
                                                    : AppColors.primaryOrange,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    horizontal: 10,
                                                    vertical: 4,
                                                  ),
                                              decoration: BoxDecoration(
                                                color: selected
                                                    ? AppColors.successGreen
                                                          .withValues(
                                                            alpha: 0.25,
                                                          )
                                                    : AppColors.successGreen
                                                          .withValues(
                                                            alpha: 0.12,
                                                          ),
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                plan.savingsLabel,
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color: selected
                                                      ? AppColors.whiteSurface
                                                      : AppColors.successGreen,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                  child: SizedBox(
                    height: 56,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _selectedId == null
                          ? null
                          : () async {
                              final selectedPlan = plans.firstWhere(
                                (plan) => plan.id == _selectedId,
                              );
                              final user = AuthService.instance.currentUser;
                              final defaultAddress = user == null
                                  ? null
                                  : await AuthService.instance
                                        .getDefaultAddress(user.uid);

                              await SubscriptionService.instance.createSubscription(
                                plan: selectedPlan,
                                mealType: 'Lunch & Dinner',
                                deliveryTime: 'Lunch 12:30 PM',
                                deliveryAddress:
                                    defaultAddress?.fullAddress ??
                                    'Delivery address to be updated by customer',
                              );

                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '${selectedPlan.title} subscription created',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ),
                              );
                              Navigator.pushNamed(
                                context,
                                AppRoutes.deliverySlot,
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        foregroundColor: AppColors.whiteSurface,
                        disabledBackgroundColor: AppColors.dividerGray
                            .withValues(alpha: 0.6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      child: const Text('Confirm subscription'),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  bool _hasSelected(List<SubscriptionModel> plans) {
    final selectedId = _selectedId;
    if (selectedId == null) return false;
    return plans.any((plan) => plan.id == selectedId);
  }
}
