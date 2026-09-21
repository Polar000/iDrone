import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_badges_and_stats.dart';
import '../../app/theme/app_colors.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  String _filterStatus = 'all'; // 'all', 'completed', 'cancelled', 'scheduled'
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredBookings = store.bookings.where((b) {
      final matchesSearch = b.id.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.cropType.toLowerCase().contains(_searchQuery.toLowerCase());
      if (_filterStatus == 'all') return matchesSearch;
      if (_filterStatus == 'completed') return matchesSearch && b.status == BookingStatus.completed;
      if (_filterStatus == 'cancelled') return matchesSearch && b.status == BookingStatus.cancelled;
      if (_filterStatus == 'scheduled') return matchesSearch && (b.status == BookingStatus.scheduled || b.status == BookingStatus.confirmed);
      return matchesSearch;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Servicios'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Filter & Search Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (v) => setState(() => _searchQuery = v),
                  decoration: InputDecoration(
                    hintText: 'Buscar por folio o cultivo...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _FilterChipItem(
                        label: 'Todos',
                        isSelected: _filterStatus == 'all',
                        onTap: () => setState(() => _filterStatus = 'all'),
                      ),
                      _FilterChipItem(
                        label: 'Completados',
                        isSelected: _filterStatus == 'completed',
                        onTap: () => setState(() => _filterStatus = 'completed'),
                      ),
                      _FilterChipItem(
                        label: 'Programados',
                        isSelected: _filterStatus == 'scheduled',
                        onTap: () => setState(() => _filterStatus = 'scheduled'),
                      ),
                      _FilterChipItem(
                        label: 'Cancelados',
                        isSelected: _filterStatus == 'cancelled',
                        onTap: () => setState(() => _filterStatus = 'cancelled'),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),

          // History List
          Expanded(
            child: filteredBookings.isEmpty
                ? Center(
                    child: Text(
                      'No se encontraron servicios en el historial.',
                      style: TextStyle(color: isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      final booking = filteredBookings[index];
                      final parcel = store.parcels.firstWhere(
                        (p) => p.id == booking.parcelId,
                        orElse: () => store.parcels.first,
                      );
                      final service = store.services.firstWhere(
                        (s) => s.id == booking.serviceId,
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
                                  Text(
                                    service.name,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  StatusBadge.forBookingStatus(booking.status.name),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text('Folio: #${booking.id} | Cultivo: ${booking.cropType}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                              Text('Parcela: ${parcel.name} (${booking.areaHectares} Ha)', style: TextStyle(fontSize: 13, color: isDark ? AppColors.darkTextMuted : AppColors.mutedText)),
                              Text('Fecha: ${booking.scheduledDate.day}/${booking.scheduledDate.month}/${booking.scheduledDate.year}', style: TextStyle(fontSize: 12, color: isDark ? AppColors.darkTextMuted : AppColors.mutedText)),
                              const Divider(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total: \$${booking.total.toStringAsFixed(2)} MXN',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald, fontSize: 15),
                                  ),
                                  OutlinedButton.icon(
                                    style: OutlinedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    ),
                                    onPressed: () {
                                      _showReceiptDialog(context, booking, service, parcel);
                                    },
                                    icon: const Icon(Icons.receipt_long_rounded, size: 16),
                                    label: const Text('Ver Comprobante', style: TextStyle(fontSize: 12)),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }

  void _showReceiptDialog(BuildContext context, BookingModel booking, ServiceModel service, ParcelModel parcel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: const [
            Icon(Icons.verified_rounded, color: AppColors.emerald),
            SizedBox(width: 8),
            Text('Comprobante iDrone'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Folio de Servicio: #${booking.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
              const Divider(),
              Text('Servicio: ${service.name}'),
              Text('Parcela: ${parcel.name}'),
              Text('Área: ${booking.areaHectares} Hectáreas'),
              Text('Fecha: ${booking.scheduledDate.day}/${booking.scheduledDate.month}/${booking.scheduledDate.year}'),
              const SizedBox(height: 12),
              Text('Subtotal: \$${booking.subtotal.toStringAsFixed(2)} MXN'),
              Text('Descuento: -\$${booking.discount.toStringAsFixed(2)} MXN'),
              Text('Monto Pagado: \$${booking.paidAmount.toStringAsFixed(2)} MXN', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.emerald)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Comprobante descargado en formato PDF.')),
              );
            },
            child: const Text('Descargar PDF'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cerrar'),
          )
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepForest : AppColors.softGreen,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : AppColors.deepForest,
          ),
        ),
      ),
    );
  }
}
