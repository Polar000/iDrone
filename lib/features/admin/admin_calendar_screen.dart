import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../components/app_card.dart';
import '../../app/theme/app_colors.dart';

class AdminCalendarAndFleetScreen extends StatelessWidget {
  const AdminCalendarAndFleetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario Operativo & Gestión de Flota'),
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
                  const Text('Calendario de Misiones Programadas', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  ...store.bookings.map((b) => ListTile(
                        leading: const Icon(Icons.event_available_rounded, color: AppColors.emerald),
                        title: Text('Misión #${b.id}'),
                        subtitle: Text('Fecha: ${b.scheduledDate.day}/${b.scheduledDate.month}/${b.scheduledDate.year} | Parcela ID: ${b.parcelId}'),
                      )),
                ],
              ),
            ),
            const SizedBox(height: 20),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Matriz de Permisos por Rol', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const ListTile(
                    title: Text('CLIENTE'),
                    subtitle: Text('Permisos: Crear Parcelas, Solicitar Servicios, Pagar, Tracking'),
                  ),
                  const ListTile(
                    title: Text('OPERADOR'),
                    subtitle: Text('Permisos: Ver Misiones, Actualizar Telemetría, Subir Fotografías'),
                  ),
                  const ListTile(
                    title: Text('ADMIN / SUPER_ADMIN'),
                    subtitle: Text('Permisos: Control Total, Asignación de Drones, Auditoría'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
