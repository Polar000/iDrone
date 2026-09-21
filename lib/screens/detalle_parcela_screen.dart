import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/map_hero.dart';
import '../components/parcel_card.dart';
import '../components/primary_button.dart';

class DetalleParcelaScreen extends StatelessWidget {
  final String parcelId;
  final VoidCallback? onRequestService;
  final VoidCallback? onEditParcel;

  const DetalleParcelaScreen({
    Key? key,
    required this.parcelId,
    this.onRequestService,
    this.onEditParcel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de Parcela'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_location_alt_rounded),
            onPressed: onEditParcel,
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MapHero(
                imagePath: AppAssets.parcel1,
                overlay: Positioned(
                  bottom: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.deepForest.withOpacity(0.85),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Polígono Delimitado',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const ParcelDetailCard(
                area: '45.2 ha (64.2 Mz)',
                crop: 'Maíz',
                location: 'Escuintla, Guatemala',
                perimeter: '2,840 metros',
              ),
              const SizedBox(height: 20),
              Text(
                'Historial Reciente',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.darkText,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_rounded, color: AppColors.emerald, size: 24),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Fumigación Agrícola', style: TextStyle(fontWeight: FontWeight.w700)),
                          Text('Completado el 12 Oct 2024', style: TextStyle(fontSize: 12, color: AppColors.mutedText)),
                        ],
                      ),
                    ),
                    const Text('\$678.00', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.forest)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Solicitar Servicio en esta Parcela',
                icon: Icons.add_task_rounded,
                onPressed: onRequestService ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
