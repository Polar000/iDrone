import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/map_hero.dart';
import '../components/primary_button.dart';

class ServicioEnCursoScreen extends StatelessWidget {
  final VoidCallback? onFinished;

  const ServicioEnCursoScreen({
    Key? key,
    this.onFinished,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Servicio en Curso')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: MapHero(
                  height: double.infinity,
                  imagePath: AppAssets.parcel1,
                  overlay: Stack(
                    children: [
                      Center(
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.emerald.withOpacity(0.9),
                            shape: BoxShape.circle,
                            boxShadow: const [
                              BoxShadow(color: Colors.black26, blurRadius: 10)
                            ],
                          ),
                          child: const Icon(Icons.flight_takeoff_rounded, color: Colors.white, size: 32),
                        ),
                      ),
                      Positioned(
                        bottom: 16,
                        left: 16,
                        right: 16,
                        child: ProgressDroneCard(
                          progress: 0.68,
                          statusText: 'Aplicación en Curso',
                          coveredAreaText: '30.7 ha',
                          remainingTimeText: '14 min',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              PrimaryButton(
                label: 'Ver Historial de Misiones',
                onPressed: onFinished ?? () => Navigator.pop(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
