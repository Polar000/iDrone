import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_buttons.dart';
import '../../app/theme/app_colors.dart';
import '../payments/payment_screen.dart';

class ServiceCatalogScreen extends StatelessWidget {
  final Function(ServiceModel)? onSelectService;

  const ServiceCatalogScreen({super.key, this.onSelectService});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catálogo de Servicios'),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: store.services.length,
        itemBuilder: (context, index) {
          final srv = store.services[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: AppCard(
              onTap: onSelectService != null ? () => onSelectService!(srv) : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.softGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.agriculture_rounded, color: AppColors.deepForest, size: 28),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              srv.name,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                            Text(
                              'Duración: ${srv.estimatedDuration}',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Q${srv.basePricePerHectare.toInt()}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.emerald,
                        ),
                      ),
                      const Text(
                        ' /Ha',
                        style: TextStyle(fontSize: 12, color: AppColors.mutedText),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    srv.description,
                    style: TextStyle(
                      fontSize: 14,
                      color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                    ),
                  ),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    label: 'Solicitar ${srv.name}',
                    icon: Icons.check_circle_outline_rounded,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingWizardScreen(initialService: srv),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class BookingWizardScreen extends StatefulWidget {
  final ServiceModel? initialService;

  const BookingWizardScreen({super.key, this.initialService});

  @override
  State<BookingWizardScreen> createState() => _BookingWizardScreenState();
}

class _BookingWizardScreenState extends State<BookingWizardScreen> {
  int _currentStep = 0;

  ServiceModel? _selectedService;
  ParcelModel? _selectedParcel;
  String _selectedCrop = 'Maíz';
  final _clientProductNameCtrl = TextEditingController(text: 'Fungicida Karate 500ml/Ha');
  bool _hasWaterAndProductsReady = true;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 2));
  String _paymentOption = 'deposit'; // 'deposit' or 'full'

  @override
  void initState() {
    super.initState();
    _selectedService = widget.initialService;
  }

  void _nextStep() {
    if (_currentStep == 0 && _selectedService == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona un servicio para continuar')),
      );
      return;
    }
    if (_currentStep == 1 && _selectedParcel == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona una parcela para continuar')),
      );
      return;
    }
    if (_currentStep == 2) {
      if (_clientProductNameCtrl.text.trim().isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor indica el nombre del producto que tú proveerás')),
        );
        return;
      }
      if (!_hasWaterAndProductsReady) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes confirmar que tendrás el agua e insumos listos en terreno')),
        );
        return;
      }
    }

    if (_currentStep < 4) {
      setState(() => _currentStep++);
    } else {
      _navigateToPayment();
    }
  }

  void _prevStep() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
    }
  }

  void _navigateToPayment() {
    final store = Provider.of<AppStore>(context, listen: false);

    final hectares = _selectedParcel!.areaHectares;
    final subtotal = store.calculateQuoteSubtotal(_selectedService!.id, hectares);
    final discount = hectares > 100 ? store.platformSettings.promoDiscountAmount : 0.0;
    final total = subtotal - discount;
    final depPct = store.platformSettings.depositPercentage;
    final paidAmount = _paymentOption == 'deposit' ? total * depPct : total;

    final newBooking = BookingModel(
      id: 'bk_${DateTime.now().millisecondsSinceEpoch}',
      userId: store.currentUser.id,
      serviceId: _selectedService!.id,
      parcelId: _selectedParcel!.id,
      cropType: _selectedCrop,
      areaHectares: hectares,
      scheduledDate: _selectedDate,
      subtotal: subtotal,
      discount: discount,
      total: total,
      paidAmount: paidAmount,
      status: BookingStatus.confirmed,
      notes: 'Producto propio: ${_clientProductNameCtrl.text.trim()} (Agua e insumos del cliente en terreno)',
      createdAt: DateTime.now(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => PaymentCheckoutScreen(
          booking: newBooking,
          service: _selectedService!,
          parcel: _selectedParcel!,
          currencySymbol: 'Q',
          onPaymentSuccess: () {
            store.addBooking(newBooking);
            Navigator.pop(context); // Close Payment Screen
            Navigator.pop(context); // Close Wizard
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Reserva y Pago procesados con éxito!')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_selectedService == null && store.services.isNotEmpty) {
      _selectedService = store.services.first;
    }
    if (_selectedParcel == null && store.parcels.isNotEmpty) {
      _selectedParcel = store.parcels.first;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Paso ${_currentStep + 1} de 5'),
        elevation: 0,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentStep + 1) / 5.0,
            backgroundColor: isDark ? AppColors.darkBorder : AppColors.softGreen,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.emerald),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: _buildStepContent(store, isDark),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              border: Border(top: BorderSide(color: isDark ? AppColors.darkBorder : Colors.black.withValues(alpha: 0.05))),
            ),
            child: Row(
              children: [
                if (_currentStep > 0) ...[
                  Expanded(
                    child: SecondaryButton(
                      label: 'Anterior',
                      onPressed: _prevStep,
                    ),
                  ),
                  const SizedBox(width: 12),
                ],
                Expanded(
                  child: PrimaryButton(
                    label: _currentStep == 4 ? 'Proceder al Pago' : 'Siguiente',
                    onPressed: _nextStep,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildStepContent(AppStore store, bool isDark) {
    switch (_currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('1. Selecciona el Servicio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...store.services.map((srv) {
              final isSelected = _selectedService?.id == srv.id;
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  border: isSelected ? Border.all(color: AppColors.emerald, width: 2) : null,
                  onTap: () => setState(() => _selectedService = srv),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.emerald : AppColors.mutedText,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(srv.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Q${srv.basePricePerHectare.toInt()} / Hectárea', style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('2. Selecciona la Parcela', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            ...store.parcels.map((pcl) {
              final isSelected = _selectedParcel?.id == pcl.id;
              final isGuatemala = pcl.locationName.contains('Guatemala');
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: AppCard(
                  border: isSelected ? Border.all(color: AppColors.emerald, width: 2) : null,
                  onTap: () => setState(() => _selectedParcel = pcl),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.emerald : AppColors.mutedText,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(pcl.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            Text('Área: ${isGuatemala ? '${(pcl.areaHectares * 1.4192).toStringAsFixed(1)} Mz' : '${pcl.areaHectares} Ha'} | Cultivo: ${pcl.cropType}', style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('3. Insumos y Producto Propio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: AppColors.deepForest),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'La empresa presta el servicio de aplicación aérea con dron. El cliente debe contar con el producto y el agua limpia en la parcela.',
                      style: TextStyle(color: AppColors.deepForest, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _clientProductNameCtrl,
              decoration: const InputDecoration(
                labelText: 'Nombre del Producto Propio a Aplicar',
                hintText: 'Ej. Fungicida Karate 500ml/Ha',
                prefixIcon: Icon(Icons.science_rounded),
              ),
            ),
            const SizedBox(height: 16),
            CheckboxListTile(
              activeColor: AppColors.emerald,
              title: const Text('Confirmo que tendré el agua limpia y el producto listos en terreno', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              value: _hasWaterAndProductsReady,
              onChanged: (val) => setState(() => _hasWaterAndProductsReady = val ?? false),
            ),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Selecciona la Fecha Programada:', style: TextStyle(fontWeight: FontWeight.bold)),
                  CalendarDatePicker(
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 90)),
                    onDateChanged: (d) => setState(() => _selectedDate = d),
                  ),
                ],
              ),
            )
          ],
        );

      case 3:
        final hectares = _selectedParcel?.areaHectares ?? 0.0;
        final subtotal = store.calculateQuoteSubtotal(_selectedService!.id, hectares);
        final discount = hectares > 100 ? store.platformSettings.promoDiscountAmount : 0.0;
        final total = subtotal - discount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('4. Cotización del Servicio', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _SummaryRow(label: 'Servicio', value: _selectedService!.name),
                  _SummaryRow(label: 'Parcela', value: _selectedParcel!.name),
                  _SummaryRow(label: 'Producto del Cliente', value: _clientProductNameCtrl.text.trim()),
                  _SummaryRow(label: 'Área Total', value: '${(hectares * 1.4192).toStringAsFixed(1)} Mz (${hectares.toStringAsFixed(1)} Ha)'),
                  _SummaryRow(label: 'Tarifa Base', value: 'Q${_selectedService!.basePricePerHectare}/Ha'),
                  const Divider(height: 24),
                  _SummaryRow(label: 'Subtotal', value: 'Q${subtotal.toStringAsFixed(2)}'),
                  if (discount > 0)
                    _SummaryRow(label: 'Descuento (+100 Ha)', value: '-Q${discount.toStringAsFixed(2)}', valueColor: AppColors.successGreen),
                  const Divider(height: 24),
                  _SummaryRow(
                    label: 'TOTAL',
                    value: 'Q${total.toStringAsFixed(2)} GTQ',
                    isBold: true,
                    valueColor: AppColors.emerald,
                  ),
                ],
              ),
            )
          ],
        );

      case 4:
      default:
        final hectares = _selectedParcel?.areaHectares ?? 0.0;
        final subtotal = store.calculateQuoteSubtotal(_selectedService!.id, hectares);
        final discount = hectares > 100 ? store.platformSettings.promoDiscountAmount : 0.0;
        final total = subtotal - discount;
        final depPct = store.platformSettings.depositPercentage;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('5. Opciones de Reserva', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            AppCard(
              border: _paymentOption == 'deposit' ? Border.all(color: AppColors.emerald, width: 2) : null,
              onTap: () => setState(() => _paymentOption = 'deposit'),
              child: Row(
                children: [
                  Icon(_paymentOption == 'deposit' ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.emerald),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reservar con Depósito ${(depPct * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Q${(total * depPct).toStringAsFixed(2)} hoy', style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
                        Text('Paga el ${((1.0 - depPct) * 100).toInt()}% restante al finalizar la operación', style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 12),
            AppCard(
              border: _paymentOption == 'full' ? Border.all(color: AppColors.emerald, width: 2) : null,
              onTap: () => setState(() => _paymentOption = 'full'),
              child: Row(
                children: [
                  Icon(_paymentOption == 'full' ? Icons.radio_button_checked : Icons.radio_button_off, color: AppColors.emerald),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Pagar 100% Completo', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text('Q${total.toStringAsFixed(2)} hoy', style: const TextStyle(color: AppColors.emerald, fontWeight: FontWeight.bold)),
                        const Text('Garantía total de asignación de dron y operador', style: TextStyle(fontSize: 12, color: AppColors.mutedText)),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        );
    }
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;
  final Color? valueColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.isBold = false,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 14, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 18 : 14,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
