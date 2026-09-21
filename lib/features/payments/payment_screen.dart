import 'package:flutter/material.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../components/app_buttons.dart';
import '../../app/theme/app_colors.dart';

class PaymentCheckoutScreen extends StatefulWidget {
  final BookingModel booking;
  final ServiceModel service;
  final ParcelModel parcel;
  final String currencySymbol;
  final VoidCallback onPaymentSuccess;

  const PaymentCheckoutScreen({
    super.key,
    required this.booking,
    required this.service,
    required this.parcel,
    this.currencySymbol = 'Q',
    required this.onPaymentSuccess,
  });

  @override
  State<PaymentCheckoutScreen> createState() => _PaymentCheckoutScreenState();
}

class _PaymentCheckoutScreenState extends State<PaymentCheckoutScreen> {
  String _selectedMethod = 'card'; // 'card', 'bank', 'wallet'
  final _cardNumberCtrl = TextEditingController(text: '4532 8910 2345 6789');
  final _expiryCtrl = TextEditingController(text: '08/28');
  final _cvvCtrl = TextEditingController(text: '321');
  final _cardHolderCtrl = TextEditingController(text: 'Roberto Gómez');
  final _formKey = GlobalKey<FormState>();

  bool _isProcessing = false;
  bool _isSuccess = false;

  void _processPayment() async {
    if (_selectedMethod == 'card' && !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    // Simulate payment gateway API processing (Stripe / MercadoPago / GuateFT)
    await Future.delayed(const Duration(milliseconds: 1800));

    if (mounted) {
      setState(() {
        _isProcessing = false;
        _isSuccess = true;
      });

      await Future.delayed(const Duration(milliseconds: 1200));
      if (mounted) {
        widget.onPaymentSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    if (_isSuccess) {
      return Scaffold(
        backgroundColor: AppColors.deepForest,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.emerald,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_rounded, color: Colors.white, size: 64),
              ),
              const SizedBox(height: 24),
              const Text(
                '¡Pago Confirmado!',
                style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Transacción procesada con éxito por ${widget.currencySymbol}${widget.booking.paidAmount.toStringAsFixed(2)}',
                style: const TextStyle(color: AppColors.limeAccent, fontSize: 14),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pasarela de Pago Segura'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Card
            AppCard(
              backgroundColor: isDark ? AppColors.darkSurface : AppColors.softGreen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('RESUMEN DE PAGO', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.mutedText)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.service.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text(
                        '${widget.currencySymbol}${widget.booking.paidAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.emerald),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text('Parcela: ${widget.parcel.name} (${widget.booking.areaHectares} Ha)', style: const TextStyle(fontSize: 13)),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Seguridad SSL 256-bit', style: TextStyle(fontSize: 12, color: AppColors.mutedText)),
                      Row(
                        children: const [
                          Icon(Icons.lock_rounded, size: 14, color: AppColors.emerald),
                          SizedBox(width: 4),
                          Text('Encriptado', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.emerald)),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Payment Methods Selector
            Text('Selecciona el Método de Pago', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: isDark ? Colors.white : AppColors.darkText)),
            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: _PaymentMethodOption(
                    title: 'Tarjeta',
                    icon: Icons.credit_card_rounded,
                    isSelected: _selectedMethod == 'card',
                    onTap: () => setState(() => _selectedMethod = 'card'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PaymentMethodOption(
                    title: 'Transferencia',
                    icon: Icons.account_balance_rounded,
                    isSelected: _selectedMethod == 'bank',
                    onTap: () => setState(() => _selectedMethod = 'bank'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _PaymentMethodOption(
                    title: 'Billetera',
                    icon: Icons.account_balance_wallet_rounded,
                    isSelected: _selectedMethod == 'wallet',
                    onTap: () => setState(() => _selectedMethod = 'wallet'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Method Form Views
            if (_selectedMethod == 'card')
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _cardHolderCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Titular de la Tarjeta',
                        prefixIcon: Icon(Icons.person_outline_rounded),
                      ),
                      validator: (v) => (v == null || v.isEmpty) ? 'Ingresa el nombre' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _cardNumberCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Número de Tarjeta',
                        prefixIcon: Icon(Icons.credit_card_rounded),
                      ),
                      validator: (v) => (v == null || v.length < 16) ? 'Tarjeta inválida' : null,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _expiryCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Expiración (MM/AA)',
                              prefixIcon: Icon(Icons.calendar_today_rounded),
                            ),
                            validator: (v) => (v == null || v.isEmpty) ? 'Ingresa MM/AA' : null,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _cvvCtrl,
                            obscureText: true,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Código CVV',
                              prefixIcon: Icon(Icons.lock_outline_rounded),
                            ),
                            validator: (v) => (v == null || v.length < 3) ? 'CVV 3 dígitos' : null,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            else if (_selectedMethod == 'bank')
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Transferencia Bancaria Directa (GuateFT / SPEI)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 8),
                    const Text('Banco: Banco Industrial / Banrural'),
                    const Text('Cuenta monetaria: 001-987654-01'),
                    const Text('A nombre de: iDrone Guatemala S.A.'),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.softGreen,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text('Nota: El servicio se confirmará al adjuntar la boleta o tras validación automática.', style: TextStyle(fontSize: 12, color: AppColors.deepForest)),
                    )
                  ],
                ),
              )
            else
              AppCard(
                child: Column(
                  children: const [
                    ListTile(
                      leading: Icon(Icons.payment_rounded, color: AppColors.emerald, size: 32),
                      title: Text('MercadoPago / Stripe Checkout'),
                      subtitle: Text('Procesamiento instantáneo seguro'),
                    )
                  ],
                ),
              ),

            const SizedBox(height: 32),
            PrimaryButton(
              label: _isProcessing
                  ? 'Procesando Transacción...'
                  : 'Pagar ${widget.currencySymbol}${widget.booking.paidAmount.toStringAsFixed(2)}',
              icon: Icons.lock_rounded,
              isLoading: _isProcessing,
              onPressed: _processPayment,
            ),
          ],
        ),
      ),
    );
  }
}

class _PaymentMethodOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _PaymentMethodOption({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.deepForest : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.deepForest : Colors.grey.shade400,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.limeAccent : AppColors.mutedText, size: 24),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : AppColors.mutedText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
