import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MapHero extends StatelessWidget {
  final String? imagePath;
  final Widget? overlay;
  final double height;

  const MapHero({
    Key? key,
    this.imagePath = AppAssets.heroParcelas,
    this.overlay,
    this.height = 240,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.card),
        image: DecorationImage(
          image: AssetImage(imagePath!),
          fit: BoxFit.cover,
          onError: (_, __) {},
        ),
      ),
      child: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppRadius.card),
              gradient: LinearGradient(
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          if (overlay != null) overlay!,
        ],
      ),
    );
  }
}

class ProgressDroneCard extends StatelessWidget {
  final double progress; // 0.0 to 1.0
  final String statusText;
  final String coveredAreaText;
  final String remainingTimeText;

  const ProgressDroneCard({
    Key? key,
    required this.progress,
    required this.statusText,
    required this.coveredAreaText,
    required this.remainingTimeText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.softGreen,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.flight_takeoff_rounded, color: AppColors.forest, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        statusText,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.darkText,
                        ),
                      ),
                      const Text(
                        'Dron DJI Agras T40 en misión',
                        style: TextStyle(fontSize: 12, color: AppColors.mutedText),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: isDark ? AppColors.limeAccent : AppColors.emerald,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: isDark ? AppColors.darkBg : AppColors.softGreen,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.limeAccent : AppColors.emerald,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildStat('Área Cubierta', coveredAreaText, isDark),
              _buildStat('Tiempo Restante', remainingTimeText, isDark),
              _buildStat('Velocidad', '18 km/h', isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, String value, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 11, color: AppColors.mutedText),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
