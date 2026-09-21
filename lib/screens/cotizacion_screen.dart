import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/primary_button.dart';

class CotizacionScreen extends StatefulWidget {
  final VoidCallback? onProceedToPayment;

  const CotizacionScreen({
    Key? key,
    this.onProceedToPayment,
  }) : super(key: key);

  @override
  State<CotizacionScreen> createState() => _CotizacionScreenState();
}

class _CotizacionScreenState extends State<CotizacionScreen> {
  bool _payDepositOnly = true;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double subtotal = 678.0;
    const double discount = 50.0;
    const double total = 628.0;
    final double deposit = total * 0.25;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cotización del Servicio'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildPriceRow('Subtotal (45.2 ha × \$15)', '\$${subtotal.toStringAsFixed(2)}', isDark),
                    const SizedBox(height: 10),
                    _buildPriceRow('Descuento Promocional', '-\$${discount.toStringAsFixed(2)}', isDark, isHighlight: true),
                    const Divider(height: 24),
                    _buildPriceRow('Total Final', '\$${total.toStringAsFixed(2)}', isDark, isTotal: true),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Modalidad de Pago',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.darkText,
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _payDepositOnly = true),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _payDepositOnly
                        ? (isDark ? AppColors.darkSurfaceElevated : AppColors.softGreen)
                        : (isDark ? AppColors.darkSurface : Colors.white),
                    border: Border.all(
                      color: _payDepositOnly ? AppColors.emerald : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: true,
                        groupValue: _payDepositOnly,
                        onChanged: (val) => setState(() => _payDepositOnly = val!),
                        activeColor: AppColors.emerald,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Reservar con 25%', style: TextStyle(fontWeight: FontWeight.w700)),
                            Text('Paga \$${deposit.toStringAsFixed(2)} hoy, saldo al finalizar.', style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: () => setState(() => _payDepositOnly = false),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: !_payDepositOnly
                        ? (isDark ? AppColors.darkSurfaceElevated : AppColors.softGreen)
                        : (isDark ? AppColors.darkSurface : Colors.white),
                    border: Border.all(
                      color: !_payDepositOnly ? AppColors.emerald : Colors.transparent,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.card),
                  ),
                  child: Row(
                    children: [
                      Radio<bool>(
                        value: false,
                        groupValue: _payDepositOnly,
                        onChanged: (val) => setState(() => _payDepositOnly = val!),
                        activeColor: AppColors.emerald,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Pagar 100% Completo', style: TextStyle(fontWeight: FontWeight.w700)),
                            Text('Paga \$${total.toStringAsFixed(2)} y liquida tu orden ahora.', style: const TextStyle(fontSize: 12, color: AppColors.mutedText)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: _payDepositOnly
                    ? 'Confirmar Reserva (\$${deposit.toStringAsFixed(2)})'
                    : 'Pagar \$${total.toStringAsFixed(2)}',
                onPressed: widget.onProceedToPayment ?? () {},
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, bool isDark, {bool isHighlight = false, bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w500,
            color: isHighlight
                ? AppColors.emerald
                : (isDark ? Colors.white : AppColors.darkText),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 20 : 14,
            fontWeight: isTotal ? FontWeight.w800 : FontWeight.w700,
            color: isTotal
                ? (isDark ? AppColors.limeAccent : AppColors.deepForest)
                : (isHighlight ? AppColors.emerald : (isDark ? Colors.white : AppColors.darkText)),
          ),
        ),
      ],
    );
  }
}
