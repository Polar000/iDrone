import 'package:flutter/material.dart';
import '../utils/constants.dart';

class ClimaScreen extends StatelessWidget {
  const ClimaScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Condiciones Climáticas')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.deepForest, AppColors.forest],
                  ),
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  children: const [
                    Icon(Icons.wb_sunny_rounded, color: AppColors.limeAccent, size: 54),
                    SizedBox(height: 12),
                    Text('28°C', style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w800)),
                    Text('Condiciones Optimas para Vuelo', style: TextStyle(color: AppColors.limeAccent, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildMetric('Viento', '8 km/h', Icons.air_rounded, isDark),
                  _buildMetric('Humedad', '62%', Icons.water_drop_rounded, isDark),
                  _buildMetric('Lluvia', '5%', Icons.cloud_queue_rounded, isDark),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetric(String label, String value, IconData icon, bool isDark) {
    return Column(
      children: [
        Icon(icon, color: AppColors.emerald),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.darkText)),
        Text(label, style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
      ],
    );
  }
}
