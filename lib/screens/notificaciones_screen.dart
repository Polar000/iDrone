import 'package:flutter/material.dart';
import '../utils/constants.dart';

class NotificacionesScreen extends StatelessWidget {
  const NotificacionesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Notificaciones')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildNotificationItem('Operador en camino', 'Carlos Mendoza se dirige a Finca San José.', 'Hace 10 min', isDark),
            _buildNotificationItem('Pago Confirmado', 'Reserva confirmada con el 25% de anticipo.', 'Hace 2 horas', isDark),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(String title, String body, String time, bool isDark) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: AppColors.softGreen,
          child: Icon(Icons.notifications_active_rounded, color: AppColors.forest),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(body),
        trailing: Text(time, style: const TextStyle(fontSize: 10, color: AppColors.mutedText)),
      ),
    );
  }
}
