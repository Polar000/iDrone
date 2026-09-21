import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_buttons.dart';
import '../../components/app_badges_and_stats.dart';
import '../../app/theme/app_colors.dart';

class OperatorDashboardScreen extends StatelessWidget {
  const OperatorDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final myMissions = store.bookings;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Panel de Operador Drone'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Operator Status Banner
            AppCard(
              backgroundColor: AppColors.deepForest,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 28,
                    backgroundColor: AppColors.limeAccent,
                    child: Icon(Icons.flight_takeoff_rounded, color: AppColors.deepForest, size: 30),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          store.currentUser.name,
                          style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const Text(
                          'Piloto Certificado | Drone DJI Agras T30',
                          style: TextStyle(color: AppColors.limeAccent, fontSize: 12),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text('Estado: DISPONIBLE', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Row(
              children: [
                Expanded(child: StatCard(title: 'MISIONES HOY', value: '${myMissions.length}', icon: Icons.assignment_rounded)),
                const SizedBox(width: 12),
                const Expanded(child: StatCard(title: 'DRONE ASIGNADO', value: 'DRONE-AG-03', icon: Icons.radar_rounded)),
              ],
            ),
            const SizedBox(height: 28),

            Text(
              'Misiones Asignadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),

            if (myMissions.isEmpty)
              const Center(child: Text('No tienes misiones asignadas para hoy.'))
            else
              ...myMissions.map((b) {
                final parcel = store.parcels.firstWhere(
                  (p) => p.id == b.parcelId,
                  orElse: () => store.parcels.first,
                );
                final service = store.services.firstWhere(
                  (s) => s.id == b.serviceId,
                  orElse: () => store.services.first,
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            StatusBadge.forBookingStatus(b.status.name),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Parcela: ${parcel.name} (${b.areaHectares} Ha)', style: const TextStyle(fontSize: 14)),
                        Text('Ubicación: ${parcel.locationName}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.mutedText)),
                        if (b.notes != null && b.notes!.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text('Nota Insumos: ${b.notes}', style: const TextStyle(fontSize: 12, color: AppColors.emerald, fontWeight: FontWeight.bold)),
                        ],
                        const SizedBox(height: 16),
                        PrimaryButton(
                          label: 'Iniciar Misión & Checklist',
                          icon: Icons.play_arrow_rounded,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => OperatorMissionExecutionScreen(booking: b, parcel: parcel),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}

class OperatorMissionExecutionScreen extends StatefulWidget {
  final BookingModel booking;
  final ParcelModel parcel;

  const OperatorMissionExecutionScreen({
    super.key,
    required this.booking,
    required this.parcel,
  });

  @override
  State<OperatorMissionExecutionScreen> createState() => _OperatorMissionExecutionScreenState();
}

class _OperatorMissionExecutionScreenState extends State<OperatorMissionExecutionScreen> {
  late BookingStatus _currentStatus;

  // On-site Field Pre-flight Checklist
  bool _chkClientProductReady = false;
  bool _chkCleanWaterAvailable = false;
  bool _chkWindOk = false;
  bool _chkBatteryCharged = false;
  bool _chkGpsCalibrated = false;

  bool get _isChecklistComplete =>
      _chkClientProductReady &&
      _chkCleanWaterAvailable &&
      _chkWindOk &&
      _chkBatteryCharged &&
      _chkGpsCalibrated;

  bool _isSigned = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.booking.status;
  }

  void _updateStatus(BookingStatus newStatus) {
    final store = Provider.of<AppStore>(context, listen: false);
    store.updateBookingStatus(widget.booking.id, newStatus);
    setState(() => _currentStatus = newStatus);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Estado actualizado a: ${newStatus.name}')),
    );
  }

  void _showSignatureDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.draw_rounded, color: AppColors.emerald),
            SizedBox(width: 8),
            Text('Firma Digital del Cliente'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Solicita al cliente que firme en pantalla para validar la conformidad del servicio realizado en su terreno.', style: TextStyle(fontSize: 12)),
            const SizedBox(height: 16),
            Container(
              height: 140,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade400, style: BorderStyle.solid),
              ),
              child: const Center(
                child: Text('Espacio para Firma Digital', style: TextStyle(color: AppColors.mutedText, fontStyle: FontStyle.italic)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.emerald, foregroundColor: Colors.white),
            onPressed: () {
              setState(() => _isSigned = true);
              _updateStatus(BookingStatus.completed);
              Navigator.pop(ctx);
            },
            child: const Text('Confirmar & Firmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Ejecución Misión #${widget.booking.id}'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Parcela: ${widget.parcel.name}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Área: ${widget.parcel.areaHectares} Hectáreas | Cultivo: ${widget.booking.cropType}', style: const TextStyle(fontSize: 14)),
                  if (widget.booking.notes != null) ...[
                    const SizedBox(height: 4),
                    Text('Notas: ${widget.booking.notes}', style: const TextStyle(fontSize: 12, color: AppColors.emerald, fontWeight: FontWeight.bold)),
                  ],
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Estado Actual:', style: TextStyle(fontWeight: FontWeight.bold)),
                      StatusBadge.forBookingStatus(_currentStatus.name),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Pre-flight Mandatory Checklist
            Text(
              'Checklist de Seguridad en Sitio (Obligatorio antes de despegue)',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              child: Column(
                children: [
                  CheckboxListTile(
                    title: const Text('1. Cliente verificó y entregó su producto/insumo en sitio', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: _chkClientProductReady,
                    activeColor: AppColors.emerald,
                    onChanged: (v) => setState(() => _chkClientProductReady = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('2. Agua limpia y recipiente de mezcla disponibles en terreno', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: _chkCleanWaterAvailable,
                    activeColor: AppColors.emerald,
                    onChanged: (v) => setState(() => _chkCleanWaterAvailable = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('3. Condiciones de viento óptimas (< 20 km/h)', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: _chkWindOk,
                    activeColor: AppColors.emerald,
                    onChanged: (v) => setState(() => _chkWindOk = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('4. Baterías del dron y control al 100%', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: _chkBatteryCharged,
                    activeColor: AppColors.emerald,
                    onChanged: (v) => setState(() => _chkBatteryCharged = v ?? false),
                  ),
                  CheckboxListTile(
                    title: const Text('5. Calibración de GPS y Brújula de vuelo lista', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    value: _chkGpsCalibrated,
                    activeColor: AppColors.emerald,
                    onChanged: (v) => setState(() => _chkGpsCalibrated = v ?? false),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            Text(
              'Controles de Operación en Campo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),

            AppCard(
              child: Column(
                children: [
                  _StatusActionButton(
                    label: '1. Marcar "En Camino"',
                    icon: Icons.directions_car_rounded,
                    isActive: _currentStatus == BookingStatus.scheduled || _currentStatus == BookingStatus.confirmed,
                    onPressed: () => _updateStatus(BookingStatus.inProgress),
                  ),
                  const SizedBox(height: 10),
                  _StatusActionButton(
                    label: '2. Iniciar Vuelo & Aplicación',
                    icon: Icons.flight_takeoff_rounded,
                    isActive: _currentStatus == BookingStatus.inProgress && _isChecklistComplete,
                    onPressed: () => _updateStatus(BookingStatus.inProgress),
                  ),
                  if (!_isChecklistComplete && _currentStatus == BookingStatus.inProgress) ...[
                    const SizedBox(height: 6),
                    const Text('Completa todo el checklist para habilitar despegue', style: TextStyle(color: AppColors.alertOrange, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                  const SizedBox(height: 10),
                  _StatusActionButton(
                    label: '3. Finalizar Misión & Firmar',
                    icon: Icons.draw_rounded,
                    isActive: _currentStatus == BookingStatus.inProgress && _isChecklistComplete,
                    onPressed: _showSignatureDialog,
                  ),
                  if (_isSigned) ...[
                    const SizedBox(height: 8),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.verified_rounded, color: AppColors.successGreen, size: 16),
                        SizedBox(width: 4),
                        Text('Firma de conformidad capturada', style: TextStyle(color: AppColors.successGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    )
                  ]
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Photos Evidence Section
            Text(
              'Evidencia Fotográfica de Campo',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt_rounded, color: AppColors.emerald, size: 32),
                        SizedBox(height: 8),
                        Text('Foto Insumos/Mezcla', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppCard(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(Icons.camera_alt_rounded, color: AppColors.emerald, size: 32),
                        SizedBox(height: 8),
                        Text('Foto Aplicación', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class _StatusActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _StatusActionButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isActive ? AppColors.deepForest : Colors.grey.shade400,
          foregroundColor: Colors.white,
        ),
        onPressed: isActive ? onPressed : null,
        icon: Icon(icon),
        label: Text(label),
      ),
    );
  }
}
