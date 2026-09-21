import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/parcel_card.dart';
import '../components/primary_button.dart';

class MisParcelasScreen extends StatelessWidget {
  final VoidCallback? onNuevaParcela;
  final Function(String parcelId)? onParcelTap;

  const MisParcelasScreen({
    Key? key,
    this.onNuevaParcela,
    this.onParcelTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Parcelas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.deepForest, AppColors.forest],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          '3 Parcelas Registradas',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Total: 125.4 Hectáreas',
                          style: TextStyle(
                            color: AppColors.limeAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: onNuevaParcela,
                      icon: const Icon(Icons.add_location_alt_rounded, color: Colors.white, size: 28),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 20),
              PrimaryButton(
                label: 'Delimitar Nueva Parcela',
                icon: Icons.map_rounded,
                onPressed: onNuevaParcela ?? () {},
              ),
              const SizedBox(height: 24),
              Text(
                'Tus Terrenos',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              ParcelCard(
                title: 'Finca San José',
                crop: 'Maíz',
                areaText: '45.2 ha',
                location: 'Escuintla, Guatemala',
                statusText: 'Activa',
                imagePath: AppAssets.parcel1,
                nextService: 'Fumigación (Mañana)',
                onTap: () => onParcelTap?.call('parcel-1'),
              ),
              ParcelCard(
                title: 'Lote El Paraíso',
                crop: 'Caña de Azúcar',
                areaText: '50.0 ha',
                location: 'Suchitepéquez, Guatemala',
                statusText: 'Activa',
                imagePath: AppAssets.parcel2,
                onTap: () => onParcelTap?.call('parcel-2'),
              ),
              ParcelCard(
                title: 'Parcela La Esperanza',
                crop: 'Melón',
                areaText: '30.2 ha',
                location: 'Zacapa, Guatemala',
                statusText: 'En Descanso',
                imagePath: AppAssets.parcel3,
                onTap: () => onParcelTap?.call('parcel-3'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
