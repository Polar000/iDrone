import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HeroHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final String ctaText;
  final VoidCallback onCtaPressed;
  final String imagePath;

  const HeroHeader({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.ctaText,
    required this.onCtaPressed,
    this.imagePath = AppAssets.heroDrone,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 260,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(24.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppRadius.card),
          gradient: LinearGradient(
            colors: [
              AppColors.deepForest.withOpacity(0.92),
              AppColors.deepForest.withOpacity(0.4),
            ],
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.9),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onCtaPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.limeAccent,
                foregroundColor: AppColors.deepForest,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.button),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    ctaText,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
