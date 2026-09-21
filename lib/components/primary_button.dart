import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final double height;

  const PrimaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.height = 54.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = backgroundColor ?? (isDark ? AppColors.emerald : AppColors.deepForest);
    final fg = textColor ?? Colors.white;

    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bg,
        foregroundColor: fg,
        elevation: 2,
        shadowColor: bg.withOpacity(0.3),
        minimumSize: Size(double.infinity, height),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(color: fg, strokeWidth: 2.5),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20, color: fg),
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: fg,
                  ),
                ),
              ],
            ),
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? textColor;

  const SecondaryButton({
    Key? key,
    required this.label,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final border = borderColor ?? (isDark ? AppColors.emerald : AppColors.deepForest);
    final text = textColor ?? (isDark ? Colors.white : AppColors.deepForest);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: text,
        minimumSize: const Size(double.infinity, 52),
        side: BorderSide(color: border, width: 1.5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 20, color: text),
            const SizedBox(width: 8),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: text,
            ),
          ),
        ],
      ),
    );
  }
}
