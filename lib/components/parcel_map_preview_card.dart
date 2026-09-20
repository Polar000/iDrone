import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../data/models/idrone_models.dart';
import '../../app/theme/app_colors.dart';

class ParcelMapPreviewCard extends StatelessWidget {
  final ParcelModel parcel;
  final double height;
  final VoidCallback? onTap;

  const ParcelMapPreviewCard({
    super.key,
    required this.parcel,
    this.height = 140,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isGuatemala = parcel.locationName.contains('Guatemala');

    final LatLng center = parcel.points.isNotEmpty
        ? LatLng(parcel.points.first.latitude, parcel.points.first.longitude)
        : const LatLng(19.4326, -99.1332);

    final polygonLatLngs = parcel.points
        .map((p) => LatLng(p.latitude, p.longitude))
        .toList();

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: center,
                initialZoom: 14.5,
                interactionOptions: const InteractionOptions(
                  flags: InteractiveFlag.none,
                ),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                  userAgentPackageName: 'com.idrone.app',
                ),
                if (polygonLatLngs.length >= 3)
                  PolygonLayer(
                    polygons: [
                      Polygon(
                        points: polygonLatLngs,
                        color: AppColors.freshGreen.withValues(alpha: 0.45),
                        borderColor: AppColors.limeAccent,
                        borderStrokeWidth: 2.5,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: polygonLatLngs.map((p) {
                    return Marker(
                      point: p,
                      width: 12,
                      height: 12,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.limeAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                    );
                  }).toList(),
                )
              ],
            ),
            // Gradient Overlay and Info Badge
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withValues(alpha: 0.8),
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.square_foot_rounded,
                            color: AppColors.limeAccent, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          isGuatemala
                              ? '${(parcel.areaHectares * 1.4192).toStringAsFixed(1)} Mz (${parcel.areaHectares.toStringAsFixed(1)} Ha)'
                              : '${parcel.areaHectares.toStringAsFixed(1)} Ha',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.deepForest.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color: AppColors.limeAccent.withValues(alpha: 0.5)),
                      ),
                      child: Text(
                        parcel.cropType,
                        style: const TextStyle(
                          color: AppColors.limeAccent,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
