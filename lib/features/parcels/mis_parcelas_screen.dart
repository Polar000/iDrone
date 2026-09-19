import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_states.dart';
import '../../app/theme/app_colors.dart';
import 'parcel_draw_screen.dart';

class MisParcelasScreen extends StatefulWidget {
  final Function(ParcelModel)? onSelectParcel;

  const MisParcelasScreen({super.key, this.onSelectParcel});

  @override
  State<MisParcelasScreen> createState() => _MisParcelasScreenState();
}

class _MisParcelasScreenState extends State<MisParcelasScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final filteredParcels = store.parcels.where((p) {
      return p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.cropType.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Parcelas'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_location_alt_rounded),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ParcelDrawScreen()),
              );
            },
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: 'Buscar parcela o cultivo...',
                prefixIcon: const Icon(Icons.search_rounded),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
            ),
          ),
          Expanded(
            child: filteredParcels.isEmpty
                ? EmptyStateView(
                    title: 'No hay parcelas encontradas',
                    message: 'Registra y dibuja tu primera parcela en el mapa para iniciar.',
                    icon: Icons.map_outlined,
                    actionLabel: 'Nueva Parcela',
                    onAction: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ParcelDrawScreen()),
                      );
                    },
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: filteredParcels.length,
                    itemBuilder: (context, index) {
                      final parcel = filteredParcels[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          onTap: widget.onSelectParcel != null
                              ? () => widget.onSelectParcel!(parcel)
                              : null,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: AppColors.softGreen,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Icon(Icons.landscape_rounded, color: AppColors.deepForest),
                                      ),
                                      const SizedBox(width: 12),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            parcel.name,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          Text(
                                            parcel.locationName,
                                            style: TextStyle(
                                              color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.errorRed),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                          title: const Text('Eliminar Parcela'),
                                          content: Text('¿Seguro que deseas eliminar "${parcel.name}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: const Text('Cancelar'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                store.deleteParcel(parcel.id);
                                                Navigator.pop(context);
                                              },
                                              child: const Text(
                                                'Eliminar',
                                                style: TextStyle(color: AppColors.errorRed),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              const Divider(height: 24),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _ParcelDetailChip(
                                    label: 'Cultivo',
                                    value: parcel.cropType,
                                    icon: Icons.grass_rounded,
                                  ),
                                  _ParcelDetailChip(
                                    label: 'Área',
                                    value: '${parcel.areaHectares.toStringAsFixed(1)} Ha',
                                    icon: Icons.square_foot_rounded,
                                  ),
                                  _ParcelDetailChip(
                                    label: 'Puntos Map',
                                    value: '${parcel.points.length} Vértices',
                                    icon: Icons.pin_drop_rounded,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.deepForest,
        foregroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ParcelDrawScreen()),
          );
        },
        icon: const Icon(Icons.add_location_alt_rounded),
        label: const Text('Dibujar Parcela'),
      ),
    );
  }
}

class _ParcelDetailChip extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _ParcelDetailChip({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.emerald),
        const SizedBox(width: 4),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 10, color: AppColors.mutedText),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        )
      ],
    );
  }
}
