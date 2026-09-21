import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../core/constants/location_data.dart';
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

  String _selectedCountry = 'Guatemala';
  String _selectedDepartment = 'Petén';
  bool _isSatellite = true;

  void _onLocationChanged(String country, String department) {
    final coords = LocationData.countriesAndDepartments[country]?[department];
    if (coords != null) {
      _mapController.move(coords, 13.5);
    }
  }

  double get _calculatedAreaHectares {
    if (_polygonPoints.length < 3) return 0.0;
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

  double get _calculatedAreaManzanas {
    // 1 Hectare = 1.4192 Manzanas in Guatemala (1 Mz = 0.7044 Ha or 7,044 m²)
    return _calculatedAreaHectares * 1.4192;
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
      locationName: '$_selectedDepartment, $_selectedCountry',
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
    final isGuatemala = _selectedCountry == 'Guatemala';

    final initialCoords = LocationData.countriesAndDepartments[_selectedCountry]?[_selectedDepartment] ??
        const LatLng(16.9120, -89.8910);

    final tileUrl = _isSatellite
        ? 'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}'
        : 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

    final departmentOptions = LocationData.countriesAndDepartments[_selectedCountry]?.keys.toList() ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trazar Parcela en Mapa'),
        actions: [
          IconButton(
            icon: Icon(_isSatellite ? Icons.map_rounded : Icons.satellite_alt_rounded),
            onPressed: () => setState(() => _isSatellite = !_isSatellite),
            tooltip: _isSatellite ? 'Cambiar a Mapa Estándar' : 'Cambiar a Satélite',
          ),
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
              initialCenter: initialCoords,
              initialZoom: 13.5,
              onTap: _onTapMap,
            ),
            children: [
              TileLayer(
                urlTemplate: tileUrl,
                userAgentPackageName: 'com.idrone.app',
              ),
              if (_polygonPoints.length >= 3)
                PolygonLayer(
                  polygons: [
                    Polygon(
                      points: _polygonPoints,
                      color: AppColors.freshGreen.withValues(alpha: 0.45),
                      borderColor: AppColors.limeAccent,
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
                        boxShadow: [BoxShadow(color: Colors.black38, blurRadius: 4)],
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

          // Country & Department Selector Header
          Positioned(
            top: 12,
            left: 12,
            right: 12,
            child: Card(
              color: isDark ? AppColors.darkSurface : Colors.white,
              elevation: 6,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.public_rounded, color: AppColors.emerald, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedCountry,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.darkText,
                              ),
                              items: LocationData.countriesAndDepartments.keys.map((c) {
                                return DropdownMenuItem(value: c, child: Text('País: $c'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedCountry = val;
                                    _selectedDepartment = LocationData.countriesAndDepartments[val]!.keys.first;
                                    _onLocationChanged(_selectedCountry, _selectedDepartment);
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: _selectedDepartment,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white : AppColors.darkText,
                              ),
                              items: departmentOptions.map((d) {
                                return DropdownMenuItem(value: d, child: Text('Dept/Estado: $d'));
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedDepartment = val;
                                    _onLocationChanged(_selectedCountry, _selectedDepartment);
                                  });
                                }
                              },
                            ),
                          ),
                        ),
                      ],
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
                          Text(
                            isGuatemala ? 'ÁREA EN MANZANAS (GUATEMALA)' : 'ÁREA CALCULADA',
                            style: const TextStyle(fontSize: 11, color: AppColors.mutedText, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            isGuatemala
                                ? '${_calculatedAreaManzanas.toStringAsFixed(2)} Mz (${_calculatedAreaHectares.toStringAsFixed(2)} Ha)'
                                : '${_calculatedAreaHectares.toStringAsFixed(2)} Ha',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.emerald),
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
