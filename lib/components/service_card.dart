import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String priceText;
  final String imagePath;
  final VoidCallback onTap;

  const ServiceCard({
    Key? key,
    required this.title,
    required this.description,
    required this.priceText,
    required this.imagePath,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 220,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
              child: Image.asset(
                imagePath,
                height: 120,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 120,
                  color: AppColors.softGreen,
                  child: const Icon(Icons.agriculture_rounded, color: AppColors.forest, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.mutedText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        priceText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? AppColors.limeAccent : AppColors.emerald,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.softGreen,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 12,
                          color: isDark ? AppColors.limeAccent : AppColors.deepForest,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CropChip extends StatelessWidget {
  final String label;
  final String imagePath;
  final bool isSelected;
  final VoidCallback? onTap;

  const CropChip({
    Key? key,
    required this.label,
    required this.imagePath,
    this.isSelected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        margin: const EdgeInsets.only(right: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.emerald : AppColors.deepForest)
              : (isDark ? AppColors.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(AppRadius.chip),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : (isDark ? AppColors.darkSurfaceElevated : Colors.black12),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                imagePath,
                width: 22,
                height: 22,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Icon(
                  Icons.eco_rounded,
                  size: 18,
                  color: isSelected ? Colors.white : AppColors.forest,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white : AppColors.darkText),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
