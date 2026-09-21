import 'package:flutter/material.dart';
import '../utils/constants.dart';

class HistorialScreen extends StatelessWidget {
  final Function(String bookingId)? onSelectBooking;

  const HistorialScreen({
    Key? key,
    this.onSelectBooking,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Servicios')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildHistoryCard('Fumigación Agrícola', 'Finca San José', '12 Oct 2024', '\$678.00', 'Completado', isDark, () {
              onSelectBooking?.call('booking-101');
            }),
            _buildHistoryCard('Abonado / Sólidos', 'Lote El Paraíso', '05 Sep 2024', '\$900.00', 'Completado', isDark, () {
              onSelectBooking?.call('booking-102');
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(String service, String parcel, String date, String price, String status, bool isDark, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(service, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text('$parcel • $date'),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(price, style: const TextStyle(fontWeight: FontWeight.w800, color: AppColors.emerald)),
            Text(status, style: const TextStyle(fontSize: 11, color: AppColors.forest)),
          ],
        ),
      ),
    );
  }
}
