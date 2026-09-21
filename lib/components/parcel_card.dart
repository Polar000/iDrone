import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ParcelCard extends StatelessWidget {
  final String title;
  final String crop;
  final String areaText;
  final String location;
  final String statusText;
  final String imagePath;
  final String? nextService;
  final VoidCallback onTap;

  const ParcelCard({
    Key? key,
    required this.title,
    required this.crop,
    required this.areaText,
    required this.location,
    this.statusText = 'Activa',
    required this.imagePath,
    this.nextService,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.25 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.card)),
                  child: Image.asset(
                    imagePath,
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: 140,
                      color: AppColors.softGreen,
                      child: const Center(
                        child: Icon(Icons.map_rounded, color: AppColors.forest, size: 48),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.emerald,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      statusText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.crop_square_rounded, color: Colors.white, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          areaText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.darkText,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceElevated : AppColors.softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          crop,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.limeAccent : AppColors.deepForest,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 15, color: AppColors.mutedText),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          location,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.mutedText,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (nextService != null) ...[
                    const Divider(height: 20),
                    Row(
                      children: [
                        const Icon(Icons.event_available_rounded, size: 15, color: AppColors.forest),
                        const SizedBox(width: 6),
                        Text(
                          'Próximo servicio: $nextService',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: isDark ? AppColors.limeAccent : AppColors.forest,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ParcelDetailCard extends StatelessWidget {
  final String area;
  final String crop;
  final String location;
  final String perimeter;

  const ParcelDetailCard({
    Key? key,
    required this.area,
    required this.crop,
    required this.location,
    required this.perimeter,
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
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Información Agrícola',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.darkText,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Área Total', area, Icons.aspect_ratio_rounded, isDark),
              ),
              Expanded(
                child: _buildInfoItem('Cultivo Actual', crop, Icons.eco_rounded, isDark),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem('Perímetro', perimeter, Icons.straighten_rounded, isDark),
              ),
              Expanded(
                child: _buildInfoItem('Ubicación', location, Icons.map_rounded, isDark),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String title, String value, IconData icon, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: AppColors.emerald),
            const SizedBox(width: 6),
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: AppColors.mutedText),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AppColors.darkText,
          ),
        ),
      ],
    );
  }
}
