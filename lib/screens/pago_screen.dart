import 'package:flutter/material.dart';
import '../utils/constants.dart';
import '../components/primary_button.dart';

class PagoScreen extends StatefulWidget {
  final VoidCallback? onPaymentSuccess;

  const PagoScreen({
    Key? key,
    this.onPaymentSuccess,
  }) : super(key: key);

  @override
  State<PagoScreen> createState() => _PagoScreenState();
}

class _PagoScreenState extends State<PagoScreen> {
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Pasarela de Pago')),
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
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Tarjeta de Crédito / Débito', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                    SizedBox(height: 16),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Número de Tarjeta',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.credit_card_rounded),
                      ),
                    ),
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'MM/AA',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              labelText: 'CVC',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Procesar Pago Seguro',
                isLoading: _isProcessing,
                onPressed: () {
                  setState(() => _isProcessing = true);
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() => _isProcessing = false);
                      widget.onPaymentSuccess?.call();
                    }
                  });
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
