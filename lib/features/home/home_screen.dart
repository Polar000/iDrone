import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../components/app_card.dart';
import '../../components/app_badges_and_stats.dart';
import '../../app/theme/app_colors.dart';
import '../tracking/tracking_and_features_screens.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback onRequestServiceTap;
  final VoidCallback onViewParcelsTap;

  const HomeScreen({
    super.key,
    required this.onRequestServiceTap,
    required this.onViewParcelsTap,
  });

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totalHectares = store.parcels.fold<double>(0, (sum, p) => sum + p.areaHectares);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HERO BANNER SECTION
            Stack(
              children: [
                Container(
                  height: 320,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF042B24), Color(0xFF087A5F)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -40,
                        top: 20,
                        child: Icon(
                          Icons.radar_rounded,
                          size: 260,
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '¡Hola, ${store.currentUser.name}!',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      const Text(
                                        'Agricultura Digital iDrone',
                                        style: TextStyle(
                                          color: AppColors.limeAccent,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.white.withValues(alpha: 0.15),
                                    ),
                                    icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const NotificationCenterScreen()),
                                      );
                                    },
                                  )
                                ],
                              ),
                              const SizedBox(height: 24),
                              const Text(
                                'Tu campo, en buenas manos.',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.extrabold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Drones agrícolas para un campo más productivo, rentable y sostenible.',
                                style: TextStyle(
                                  color: Color(0xFFE2E8F0),
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.freshGreen,
                                  foregroundColor: AppColors.deepForest,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                ),
                                onPressed: onRequestServiceTap,
                                icon: const Icon(Icons.add_task_rounded, color: AppColors.deepForest),
                                label: const Text(
                                  'Solicitar servicio',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  // FLOATING STATS ROW
                  Row(
                    children: [
                      Expanded(
                        child: StatCard(
                          title: 'HECTÁREAS',
                          value: '${totalHectares.toStringAsFixed(1)} Ha',
                          subtitle: '${store.parcels.length} Parcelas',
                          icon: Icons.landscape_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const WeatherScreen()),
                            );
                          },
                          child: const StatCard(
                            title: 'CLIMA CULTIVO',
                            value: '24°C',
                            subtitle: 'Óptimo para Vuelo',
                            icon: Icons.wb_sunny_rounded,
                            iconBgColor: Color(0xFFFEF3C7),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),

                  // ACTIVE SERVICES PREVIEW
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Próximas Operaciones',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  if (store.bookings.isEmpty)
                    const AppCard(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text('No tienes servicios programados en este momento.'),
                        ),
                      ),
                    )
                  else
                    ...store.bookings.map((booking) {
                      final parcel = store.parcels.firstWhere(
                        (p) => p.id == booking.parcelId,
                        orElse: () => store.parcels.first,
                      );
                      final service = store.services.firstWhere(
                        (s) => s.id == booking.serviceId,
                        orElse: () => store.services.first,
                      );

                      return AppCard(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ServiceTrackingScreen(booking: booking),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  service.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                StatusBadge.forBookingStatus(booking.status.name),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Parcela: ${parcel.name} (${booking.areaHectares} Ha)',
                              style: TextStyle(
                                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Fecha: ${booking.scheduledDate.day}/${booking.scheduledDate.month}/${booking.scheduledDate.year}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const Text(
                                  'Ver Radar Live >',
                                  style: TextStyle(
                                    color: AppColors.emerald,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }),

                  const SizedBox(height: 28),

                  // SERVICES QUICK LIST
                  Text(
                    'Servicios Destacados',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: store.services.length,
                      itemBuilder: (context, index) {
                        final srv = store.services[index];
                        return Container(
                          width: 200,
                          margin: const EdgeInsets.only(right: 12),
                          child: AppCard(
                            onTap: onRequestServiceTap,
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: AppColors.softGreen,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: const Icon(Icons.agriculture_rounded, color: AppColors.deepForest, size: 20),
                                    ),
                                    const Spacer(),
                                    Text(
                                      '\$${srv.basePricePerHectare.toInt()}/Ha',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.emerald,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  srv.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  srv.estimatedDuration,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
