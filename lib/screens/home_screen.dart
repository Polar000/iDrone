import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/hero_header.dart';
import '../components/stat_card.dart';
import '../components/section_header.dart';
import '../components/service_card.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onRequestService;
  final Function(int)? onNavigateTab;

  const HomeScreen({
    Key? key,
    this.onRequestService,
    this.onNavigateTab,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeroHeader(
                title: 'Tu campo, en buenas manos',
                subtitle: 'Drones agrícolas para un campo más productivo, rentable y sostenible.',
                ctaText: 'Solicitar servicio',
                onCtaPressed: onRequestService ?? () {},
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      title: 'HECTÁREAS',
                      value: '+500 ha',
                      subtitle: 'Cubiertas con éxito',
                      icon: Icons.aspect_ratio_rounded,
                      iconColor: AppColors.emerald,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      title: 'EFICIENCIA',
                      value: '99.4%',
                      subtitle: 'Precisión de vuelo',
                      icon: Icons.verified_rounded,
                      iconColor: AppColors.forest,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SectionHeader(
                title: 'Nuestros Servicios',
                actionTitle: 'Ver todos',
                onAction: () => onNavigateTab?.call(2),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 250,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ServiceCard(
                      title: 'Fumigación Agrícola',
                      description: 'Aplicación ultratrazada de plaguicidas con mínima deriva.',
                      priceText: '\$15.00 / ha',
                      imagePath: AppAssets.serviceFumigacion,
                      onTap: onRequestService ?? () {},
                    ),
                    ServiceCard(
                      title: 'Abonado / Sólidos',
                      description: 'Distribución homogénea de fertilizantes granulares.',
                      priceText: '\$18.00 / ha',
                      imagePath: AppAssets.serviceAbonado,
                      onTap: onRequestService ?? () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const SectionHeader(title: 'Cultivos más comunes'),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: const [
                    CropChip(label: 'Maíz', imagePath: AppAssets.corn, isSelected: true),
                    CropChip(label: 'Caña de Azúcar', imagePath: AppAssets.sugarcane),
                    CropChip(label: 'Melón', imagePath: AppAssets.melon),
                    CropChip(label: 'Pastos', imagePath: AppAssets.livestock),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
