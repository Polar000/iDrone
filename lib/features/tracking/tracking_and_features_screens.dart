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
  double _battery = 88.0; // %
  double _altitude = 12.5; // meters
  double _speed = 18.2; // km/h
  bool _isSatellite = true;
  bool _showNdviOverlay = false;
  LatLng _dronePos = const LatLng(19.4326, -99.1332);

  void _simulateProgress() {
    setState(() {
      _progress = (_progress + 15) > 100 ? 100 : _progress + 15;
      _battery = (_battery - 5) < 10 ? 95 : _battery - 5;
      _dronePos = LatLng(_dronePos.latitude + 0.0008, _dronePos.longitude + 0.0008);
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

    final tileUrl = _isSatellite
        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    return Scaffold(
      appBar: AppBar(
        title: Text('Telemetría Radar: #${widget.booking.id}'),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded),
            onPressed: () => setState(() => _isSatellite = !_isSatellite),
            tooltip: 'Alternar Vista Satelital',
          ),
          IconButton(
            icon: Icon(Icons.sensors_rounded, color: _showNdviOverlay ? AppColors.limeAccent : null),
            onPressed: () => setState(() => _showNdviOverlay = !_showNdviOverlay),
            tooltip: 'Alternar Capa NDVI',
          )
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              initialCenter: _dronePos,
              initialZoom: 15.5,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.idrone.app',
              ),
              if (parcel.points.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: parcel.points.map((p) => LatLng(p.latitude, p.longitude)).toList(),
                      color: _showNdviOverlay
                          ? Colors.lightGreen.withValues(alpha: 0.5)
                          : AppColors.freshGreen.withValues(alpha: 0.3),
                      borderColor: _showNdviOverlay ? Colors.greenAccent : AppColors.deepForest,
                      borderStrokeWidth: 3,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _dronePos,
                    width: 48,
                    height: 48,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: AppColors.deepForest,
                        shape: BoxShape.circle,
                        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 8)],
                      ),
                      child: const Icon(Icons.radar_rounded, color: AppColors.limeAccent, size: 30),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Top Floating Telemetry Pills
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _TelemetryPill(icon: Icons.battery_charging_full_rounded, label: '${_battery.toInt()}%', valueColor: AppColors.limeAccent),
                _TelemetryPill(icon: Icons.height_rounded, label: '${_altitude}m Alt'),
                _TelemetryPill(icon: Icons.speed_rounded, label: '${_speed} km/h'),
                _TelemetryPill(
                  icon: _showNdviOverlay ? Icons.grass_rounded : Icons.satellite_rounded,
                  label: _showNdviOverlay ? 'NDVI: 0.82' : (_isSatellite ? 'Satelital' : 'Estándar'),
                  valueColor: AppColors.freshGreen,
                ),
              ],
            ),
          ),

          // Bottom Operational Status Sheet
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
                          const Text('TELEMETRÍA EN TIEMPO REAL', style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.bold)),
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
                      Text('Piloto: ${operator.name} (${operator.phone})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Avance Misión: ${_progress.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text('Cobertura: ${(parcel.areaHectares * (_progress / 100)).toStringAsFixed(1)} / ${parcel.areaHectares} Ha', style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: _progress / 100.0,
                    backgroundColor: isDark ? AppColors.darkBorder : AppColors.softGreen,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _simulateProgress,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Simular Paso Dron'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        style: IconButton.styleFrom(backgroundColor: AppColors.deepForest, foregroundColor: AppColors.limeAccent),
                        icon: Icon(_isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded),
                        onPressed: () => setState(() => _isSatellite = !_isSatellite),
                      ),
                    ],
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

class _TelemetryPill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? valueColor;

  const _TelemetryPill({
    required this.icon,
    required this.label,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.deepForest.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 4)],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: valueColor ?? Colors.white),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
              children: const [
                Expanded(child: StatCard(title: 'VIENTO', value: '8 km/h', icon: Icons.air_rounded)),
                SizedBox(width: 12),
                Expanded(child: StatCard(title: 'HUMEDAD', value: '45%', icon: Icons.water_drop_rounded)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: const [
                Expanded(child: StatCard(title: 'LLUVIA', value: '5%', icon: Icons.umbrella_rounded)),
                SizedBox(width: 12),
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
