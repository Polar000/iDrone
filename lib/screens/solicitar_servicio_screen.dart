import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/primary_button.dart';
import '../components/section_header.dart';

class SolicitarServicioScreen extends StatefulWidget {
  final VoidCallback? onCompleteWizard;

  const SolicitarServicioScreen({
    Key? key,
    this.onCompleteWizard,
  }) : super(key: key);

  @override
  State<SolicitarServicioScreen> createState() => _SolicitarServicioScreenState();
}

class _SolicitarServicioScreenState extends State<SolicitarServicioScreen> {
  int _currentStep = 0;
  String _selectedService = 'Fumigación Agrícola';
  String _selectedParcel = 'Finca San José (45.2 ha)';
  String _selectedCrop = 'Maíz';
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Paso ${_currentStep + 1} de 5'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (_currentStep + 1) / 5,
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.softGreen,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: _buildStepContent(isDark),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  if (_currentStep > 0)
                    Expanded(
                      child: SecondaryButton(
                        label: 'Atrás',
                        onPressed: () => setState(() => _currentStep--),
                      ),
                    ),
                  if (_currentStep > 0) const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: _currentStep == 4 ? 'Ver Cotización' : 'Siguiente',
                      onPressed: () {
                        if (_currentStep < 4) {
                          setState(() => _currentStep++);
                        } else {
                          widget.onCompleteWizard?.call();
                        }
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent(bool isDark) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Selecciona el Servicio'),
            const SizedBox(height: 12),
            _buildOptionCard('Fumigación Agrícola', 'Aplicación precisa de líquidos y plaguicidas', _selectedService == 'Fumigación Agrícola', isDark, () {
              setState(() => _selectedService = 'Fumigación Agrícola');
            }),
            _buildOptionCard('Abonado / Sólidos', 'Esparcimiento de fertilizantes secos granulares', _selectedService == 'Abonado / Sólidos', isDark, () {
              setState(() => _selectedService = 'Abonado / Sólidos');
            }),
          ],
        );
      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Selecciona tu Parcela'),
            const SizedBox(height: 12),
            _buildOptionCard('Finca San José (45.2 ha)', 'Escuintla, Guatemala', _selectedParcel.contains('San José'), isDark, () {
              setState(() => _selectedParcel = 'Finca San José (45.2 ha)');
            }),
            _buildOptionCard('Lote El Paraíso (50.0 ha)', 'Suchitepéquez, Guatemala', _selectedParcel.contains('El Paraíso'), isDark, () {
              setState(() => _selectedParcel = 'Lote El Paraíso (50.0 ha)');
            }),
          ],
        );
      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Confirma el Cultivo'),
            const SizedBox(height: 12),
            _buildOptionCard('Maíz', 'Etapa vegetativa V4-V6', _selectedCrop == 'Maíz', isDark, () {
              setState(() => _selectedCrop = 'Maíz');
            }),
            _buildOptionCard('Caña de Azúcar', 'Desarrollo foliar', _selectedCrop == 'Caña de Azúcar', isDark, () {
              setState(() => _selectedCrop = 'Caña de Azúcar');
            }),
          ],
        );
      case 3:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Fecha Programada'),
            const SizedBox(height: 16),
            CalendarDatePicker(
              initialDate: _selectedDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 90)),
              onDateChanged: (date) => setState(() => _selectedDate = date),
            ),
          ],
        );
      case 4:
      default:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'Resumen del Pedido'),
            const SizedBox(height: 16),
            _buildSummaryRow('Servicio', _selectedService),
            _buildSummaryRow('Parcela', _selectedParcel),
            _buildSummaryRow('Cultivo', _selectedCrop),
            _buildSummaryRow('Fecha', '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
          ],
        );
    }
  }

  Widget _buildOptionCard(String title, String subtitle, bool isSelected, bool isDark, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? (isDark ? AppColors.darkSurfaceElevated : AppColors.softGreen)
            : (isDark ? AppColors.darkSurface : Colors.white),
        border: Border.all(
          color: isSelected ? AppColors.emerald : Colors.transparent,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(AppRadius.card),
      ),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: isSelected ? const Icon(Icons.check_circle_rounded, color: AppColors.emerald) : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: AppColors.mutedText, fontSize: 14)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14)),
        ],
      ),
    );
  }
}
