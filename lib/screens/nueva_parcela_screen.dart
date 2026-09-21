import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/map_hero.dart';
import '../components/primary_button.dart';

class NuevaParcelaScreen extends StatefulWidget {
  final Function(Map<String, dynamic> parcelData)? onSaveParcel;

  const NuevaParcelaScreen({
    Key? key,
    this.onSaveParcel,
  }) : super(key: key);

  @override
  State<NuevaParcelaScreen> createState() => _NuevaParcelaScreenState();
}

class _NuevaParcelaScreenState extends State<NuevaParcelaScreen> {
  final _nameController = TextEditingController(text: 'Mi Parcela Central');
  String _selectedCrop = 'Maíz';
  int _pointsCount = 4;
  double _calculatedArea = 32.5;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Delimitar Parcela'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MapHero(
                height: 280,
                imagePath: AppAssets.heroParcelas,
                overlay: Stack(
                  children: [
                    Positioned(
                      top: 12,
                      right: 12,
                      child: FloatingActionButton.small(
                        heroTag: 'clear_points',
                        backgroundColor: Colors.white,
                        onPressed: () {
                          setState(() {
                            _pointsCount = 0;
                            _calculatedArea = 0.0;
                          });
                        },
                        child: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.deepForest.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Puntos: $_pointsCount',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Área: ${_calculatedArea.toStringAsFixed(1)} ha',
                              style: const TextStyle(color: AppColors.limeAccent, fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nombre de la Parcela',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  prefixIcon: const Icon(Icons.landscape_rounded),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCrop,
                decoration: InputDecoration(
                  labelText: 'Cultivo Principal',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.button)),
                  prefixIcon: const Icon(Icons.eco_rounded),
                ),
                items: const [
                  DropdownMenuItem(value: 'Maíz', child: Text('Maíz')),
                  DropdownMenuItem(value: 'Caña de Azúcar', child: Text('Caña de Azúcar')),
                  DropdownMenuItem(value: 'Melón', child: Text('Melón')),
                  DropdownMenuItem(value: 'Pastos', child: Text('Pastos')),
                ],
                onChanged: (val) {
                  if (val != null) setState(() => _selectedCrop = val);
                },
              ),
              const SizedBox(height: 24),
              PrimaryButton(
                label: 'Guardar Parcela',
                icon: Icons.check_circle_rounded,
                onPressed: () {
                  widget.onSaveParcel?.call({
                    'name': _nameController.text,
                    'crop': _selectedCrop,
                    'area': _calculatedArea,
                    'points': _pointsCount,
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
