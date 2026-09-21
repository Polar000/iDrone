import 'package:flutter/material.dart';
import '../app/theme/app_colors.dart';

class StatusBadge extends StatelessWidget {
  final String statusText;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;

  const StatusBadge({
    super.key,
    required this.statusText,
    required this.backgroundColor,
    required this.textColor,
    this.icon,
  });

  factory StatusBadge.forBookingStatus(String status) {
    switch (status.toLowerCase()) {
      case 'confirmed':
      case 'completado':
      case 'completed':
        return const StatusBadge(
          statusText: 'Completado',
          backgroundColor: Color(0xFFDCFCE7),
          textColor: Color(0xFF15803D),
          icon: Icons.check_circle_rounded,
        );
      case 'in_progress':
      case 'en curso':
      case 'en_curso':
        return const StatusBadge(
          statusText: 'En Curso',
          backgroundColor: Color(0xFFFEF9C3),
          textColor: Color(0xFFA16207),
          icon: Icons.autorenew_rounded,
        );
      case 'scheduled':
      case 'programado':
        return const StatusBadge(
          statusText: 'Programado',
          backgroundColor: Color(0xFFE0F2FE),
          textColor: Color(0xFF0369A1),
          icon: Icons.calendar_today_rounded,
        );
      case 'pending_payment':
      case 'pendiente':
        return const StatusBadge(
          statusText: 'Pago Pendiente',
          backgroundColor: Color(0xFFFFEDD5),
          textColor: Color(0xFFC2410C),
          icon: Icons.pending_rounded,
        );
      case 'cancelled':
      case 'cancelado':
        return const StatusBadge(
          statusText: 'Cancelado',
          backgroundColor: Color(0xFFFEE2E2),
          textColor: Color(0xFFB91C1C),
          icon: Icons.cancel_rounded,
        );
      default:
        return StatusBadge(
          statusText: status,
          backgroundColor: const Color(0xFFF3F4F6),
          textColor: const Color(0xFF374151),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 13, color: textColor),
            const SizedBox(width: 4),
          ],
          Text(
            statusText,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData icon;
  final Color? iconBgColor;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    this.subtitle,
    this.iconBgColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.black.withValues(alpha: 0.06),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor ?? AppColors.emerald.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isDark ? AppColors.limeAccent : AppColors.deepForest,
              size: 24,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.emerald,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
