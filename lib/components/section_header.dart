import 'package:flutter/material.dart';
import '../utils/constants.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionTitle;
  final VoidCallback? onAction;

  const SectionHeader({
    Key? key,
    required this.title,
    this.actionTitle,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkText,
            ),
          ),
          if (actionTitle != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionTitle!,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? AppColors.limeAccent : AppColors.emerald,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
