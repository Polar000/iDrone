import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/primary_button.dart';

class DetalleServicioScreen extends StatelessWidget {
  final String bookingId;

  const DetalleServicioScreen({
    Key? key,
    required this.bookingId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de Servicio')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID Servicio: $bookingId', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  children: const [
                    ListTile(title: Text('Servicio'), trailing: Text('Fumigación Agrícola', style: TextStyle(fontWeight: FontWeight.w700))),
                    ListTile(title: Text('Parcela'), trailing: Text('Finca San José', style: TextStyle(fontWeight: FontWeight.w700))),
                    ListTile(title: Text('Estado'), trailing: Text('Completado', style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.emerald))),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Descargar Comprobante PDF',
                icon: Icons.download_rounded,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Descargando comprobante...')),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
