import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_badges_and_stats.dart';
import '../../app/theme/app_colors.dart';

class ServiceTrackingScreen extends StatefulWidget {
  final BookingModel booking;

  const ServiceTrackingScreen({super.key, required this.booking});

  @override
  State<ServiceTrackingScreen> createState() => _ServiceTrackingScreenState();
}

class _ServiceTrackingScreenState extends State<ServiceTrackingScreen> {
  double _progress = 45.0; // %
  LatLng _dronePos = const LatLng(19.4326, -99.1332);

  void _simulateProgress() {
    setState(() {
      _progress = (_progress + 15) > 100 ? 100 : _progress + 15;
      _dronePos = LatLng(_dronePos.latitude + 0.001, _dronePos.longitude + 0.001);
    });
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final parcel = store.parcels.firstWhere(
      (p) => p.id == widget.booking.parcelId,
      orElse: () => store.parcels.first,
    );

    final operator = store.operators.firstWhere(
      (o) => o.id == widget.booking.operatorId,
      orElse: () => store.operators.first,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('Seguimiento: #${widget.booking.id}'),
        elevation: 0,
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _dronePos,
              initialZoom: 15.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.idrone.app',
              ),
              if (parcel.points.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: parcel.points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
                      color: AppColors.freshGreen.withValues(alpha: 0.3),
                      borderColor: AppColors.deepForest,
                      borderStrokeWidth: 2,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _dronePos,
                    width: 44,
                    height: 44,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.deepForest,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8)],
                      ),
                      child: const Icon(Icons.radar_rounded, color: AppColors.limeAccent, size: 28),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Floating Operational Status
          Positioned(
            bottom: 20,
            left: 16,
            right: 16,
            child: AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('OPERACIÓN EN CURSO', style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.bold)),
                          Text(parcel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      StatusBadge.forBookingStatus(widget.booking.status.name),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.person_rounded, size: 16, color: AppColors.emerald),
                      const SizedBox(width: 6),
                      Text('Operador: ${operator.name} (${operator.phone})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progreso: ${_progress.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Área: ${(parcel.areaHectares * (_progress / 100)).toStringAsFixed(1)} / ${parcel.areaHectares} Ha', style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: _progress / 100.0,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.softGreen,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: _simulateProgress,
                      icon: const Icon(Icons.refresh_rounded),
                      label: const Text('Simular Avance de Telemetría'),
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Condiciones Climáticas'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AppCard(
              backgroundColor: AppColors.deepForest,
              child: const Column(
                children: [
                  Icon(Icons.wb_sunny_rounded, color: AppColors.limeAccent, size: 64),
                  SizedBox(height: 12),
                  Text('24°C', style: TextStyle(color: Colors.white, fontSize: 42, fontWeight: FontWeight.bold)),
                  Text('Despejado - Óptimo para Vuelo', style: TextStyle(color: AppColors.limeAccent, fontSize: 16, fontWeight: FontWeight.w600)),
                  SizedBox(height: 16),
                  Text('Las condiciones meteorológicas son altamente favorables para operaciones de fumigación y monitoreo.', style: TextStyle(color: Colors.white70, fontSize: 13), textAlign: TextAlign.center),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: StatCard(title: 'VIENTO', value: '8 km/h', icon: Icons.air_rounded)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(title: 'HUMEDAD', value: '45%', icon: Icons.water_drop_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: StatCard(title: 'LLUVIA', value: '5%', icon: Icons.umbrella_rounded)),
                const SizedBox(width: 12),
                Expanded(child: StatCard(title: 'VISIBILIDAD', value: '10 km', icon: Icons.visibility_rounded)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NotificationCenterScreen extends StatelessWidget {
  const NotificationCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.done_all_rounded),
            onPressed: () => store.markAllNotificationsAsRead(),
            tooltip: 'Marcar todas como leídas',
          )
        ],
      ),
      body: store.notifications.isEmpty
          ? const Center(child: Text('No tienes notificaciones por el momento.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: store.notifications.length,
              itemBuilder: (context, index) {
                final notif = store.notifications[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    border: !notif.isRead ? Border.all(color: AppColors.emerald, width: 1.5) : null,
                    onTap: () => store.markNotificationAsRead(notif.id),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          notif.isRead ? Icons.notifications_none_rounded : Icons.notifications_active_rounded,
                          color: notif.isRead ? AppColors.mutedText : AppColors.emerald,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(notif.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                              const SizedBox(height: 4),
                              Text(notif.message, style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.mutedText)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
