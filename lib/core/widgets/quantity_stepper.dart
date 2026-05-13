import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class QuantityStepper extends StatelessWidget {
  const QuantityStepper({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
    this.color = AppColors.primaryRed,
  });

  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 32,
          height: 32,
          child: Material(
            color: AppColors.lightGrayBg,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onMinus,
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.remove,
                size: 18,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '$quantity',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(
          width: 32,
          height: 32,
          child: Material(
            color: color,
            shape: const CircleBorder(),
            clipBehavior: Clip.antiAlias,
            child: InkWell(
              onTap: onPlus,
              customBorder: const CircleBorder(),
              child: const Icon(
                Icons.add,
                size: 18,
                color: AppColors.whiteSurface,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
