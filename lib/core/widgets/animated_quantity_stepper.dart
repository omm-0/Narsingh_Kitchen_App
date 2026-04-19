import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AnimatedQuantityStepper extends StatelessWidget {
  const AnimatedQuantityStepper({
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
        _RoundStepButton(
          onTap: onMinus,
          background: AppColors.lightGrayBg,
          iconColor: AppColors.textPrimary,
          icon: Icons.remove,
        ),
        SizedBox(
          width: 42,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (child, anim) =>
                ScaleTransition(scale: anim, child: child),
            child: Text(
              '$quantity',
              key: ValueKey<int>(quantity),
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ),
        _RoundStepButton(
          onTap: onPlus,
          background: color,
          iconColor: AppColors.whiteSurface,
          icon: Icons.add,
        ),
      ],
    );
  }
}

class _RoundStepButton extends StatelessWidget {
  const _RoundStepButton({
    required this.onTap,
    required this.background,
    required this.iconColor,
    required this.icon,
  });

  final VoidCallback onTap;
  final Color background;
  final Color iconColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        splashColor: iconColor.withValues(alpha: 0.12),
        highlightColor: iconColor.withValues(alpha: 0.06),
        child: SizedBox(
          width: 34,
          height: 34,
          child: Icon(icon, size: 18, color: iconColor),
        ),
      ),
    );
  }
}
