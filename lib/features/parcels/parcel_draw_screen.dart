import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../app/theme/app_colors.dart';

class ParcelDrawScreen extends StatefulWidget {
  const ParcelDrawScreen({super.key});

  @override
  State<ParcelDrawScreen> createState() => _ParcelDrawScreenState();
}

class _ParcelDrawScreenState extends State<ParcelDrawScreen> {
  final List<LatLng> _polygonPoints = [];
  final _nameController = TextEditingController();
  final _cropController = TextEditingController(text: 'Maíz');
  final MapController _mapController = MapController();

  double get _calculatedAreaHectares {
    if (_polygonPoints.length < 3) return 0.0;
    // Standard Shoelace Polygon Area calculation for Lat/Lng approx
    double area = 0.0;
    int j = _polygonPoints.length - 1;
    for (int i = 0; i < _polygonPoints.length; i++) {
      area += (_polygonPoints[j].longitude + _polygonPoints[i].longitude) *
          (_polygonPoints[j].latitude - _polygonPoints[i].latitude);
      j = i;
    }
    double sqMeters = (area.abs() / 2.0) * 111319.5 * 111319.5;
    return sqMeters / 10000.0;
  }

  double get _calculatedPerimeterMeters {
    if (_polygonPoints.length < 2) return 0.0;
    double perimeter = 0.0;
    for (int i = 0; i < _polygonPoints.length; i++) {
      int next = (i + 1) % _polygonPoints.length;
      perimeter += _calculateDistanceMeters(_polygonPoints[i], _polygonPoints[next]);
    }
    return perimeter;
  }

  double _calculateDistanceMeters(LatLng p1, LatLng p2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((p2.latitude - p1.latitude) * p) / 2 +
        c(p1.latitude * p) * c(p2.latitude * p) * (1 - c((p2.longitude - p1.longitude) * p)) / 2;
    return 12742 * asin(sqrt(a)) * 1000;
  }

  void _onTapMap(TapPosition tapPosition, LatLng point) {
    setState(() {
      _polygonPoints.add(point);
    });
  }

  void _undoLastPoint() {
    if (_polygonPoints.isNotEmpty) {
      setState(() {
        _polygonPoints.removeLast();
      });
    }
  }

  void _clearPoints() {
    setState(() {
      _polygonPoints.clear();
    });
  }

  void _saveParcel() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor ingresa un nombre para la parcela')),
      );
      return;
    }
    if (_polygonPoints.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debes marcar al menos 3 puntos en el mapa')),
      );
      return;
    }

    final store = Provider.of<AppStore>(context, listen: false);
    final newParcel = ParcelModel(
      id: 'par_${DateTime.now().millisecondsSinceEpoch}',
      userId: store.currentUser.id,
      name: _nameController.text.trim(),
      cropType: _cropController.text.trim(),
      areaHectares: double.parse(_calculatedAreaHectares.toStringAsFixed(2)),
      perimeterMeters: double.parse(_calculatedPerimeterMeters.toStringAsFixed(1)),
      locationName: 'Ubicación trazada en mapa',
      points: _polygonPoints.map((p) => ParcelPoint(latitude: p.latitude, longitude: p.longitude)).toList(),
      createdAt: DateTime.now(),
    );

    store.addParcel(newParcel);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trazar Parcela en Mapa'),
        actions: [
          if (_polygonPoints.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.undo_rounded),
              onPressed: _undoLastPoint,
              tooltip: 'Deshacer último punto',
            ),
          if (_polygonPoints.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep_rounded),
              onPressed: _clearPoints,
              tooltip: 'Limpiar mapa',
            ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: const LatLng(19.4326, -99.1332),
              initialZoom: 14.0,
              onTap: _onTapMap,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.idrone.app',
              ),
              if (_polygonPoints.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _polygonPoints,
                      color: AppColors.freshGreen.withValues(alpha: 0.35),
                      borderColor: AppColors.deepForest,
                      borderStrokeWidth: 3,
                    ),
                  ],
                ),
              MarkerLayer(
                markers: _polygonPoints.asMap().entries.map((entry) {
                  return Marker(
                    point: entry.value,
                    width: 30,
                    height: 30,
                    child: Container(
                      decoration: const BoxDecoration(
                        color: AppColors.deepForest,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${entry.key + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top Instruction Card
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Card(
              color: isDark ? AppColors.darkSurface : Colors.white,
              elevation: 4,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.touch_app_rounded, color: AppColors.emerald),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Toca en el mapa para añadir vértices y delimitar el terreno.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Area Details Sheet
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 16,
                    offset: const Offset(0, -4),
                  )
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'ÁREA CALCULADA',
                            style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_calculatedAreaHectares.toStringAsFixed(2)} Ha',
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.emerald),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'PERÍMETRO',
                            style: TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${_calculatedPerimeterMeters.toStringAsFixed(0)} m',
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Terreno / Parcela',
                      hintText: 'Ej. Finca Las Palmas',
                      prefixIcon: Icon(Icons.edit_location_alt_rounded),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _cropController,
                    decoration: const InputDecoration(
                      labelText: 'Tipo de Cultivo',
                      hintText: 'Ej. Maíz, Agave, Trigo',
                      prefixIcon: Icon(Icons.grass_rounded),
                    ),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.deepForest,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: _polygonPoints.length >= 3 ? _saveParcel : null,
                      child: const Text('Guardar Parcela', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
