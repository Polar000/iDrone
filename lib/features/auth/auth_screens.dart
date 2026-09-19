import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/idrone_logo.dart';
import '../../app/theme/app_colors.dart';

class SplashScreen extends StatefulWidget {
  final VoidCallback onSplashComplete;

  const SplashScreen({super.key, required this.onSplashComplete});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        widget.onSplashComplete();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepForest,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IDroneLogoWidget(size: 110),
            const SizedBox(height: 24),
            const Text(
              'iDRONE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AGRICULTURA DE PRECISIÓN',
              style: TextStyle(
                color: AppColors.limeAccent,
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              color: AppColors.limeAccent,
              strokeWidth: 2,
            )
          ],
        ),
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  final VoidCallback onLoginSuccess;

  const LoginScreen({super.key, required this.onLoginSuccess});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl = TextEditingController(text: 'cliente@idrone.com');
  final _passwordCtrl = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  void _submit() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        setState(() => _isLoading = false);
        widget.onLoginSuccess();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 30),
                Row(
                  children: const [
                    IDroneLogoWidget(size: 48),
                    SizedBox(width: 12),
                    Text(
                      'iDRONE',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                    )
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  'Bienvenido de nuevo',
                  style: theme.textTheme.displayLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 8),
                Text(
                  'Ingresa para gestionar tus parcelas y servicios agrícolas.',
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 32),

                // Role Selector Bar
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: UserRole.values.map((role) {
                        final isSelected = store.currentUser.role == role;
                        return GestureDetector(
                          onTap: () => store.switchUserRole(role),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? (isDark ? AppColors.emerald : AppColors.deepForest)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              role.displayName,
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                TextFormField(
                  controller: _emailCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Correo Electrónico',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (val) => (val == null || !val.contains('@')) ? 'Correo inválido' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Contraseña',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (val) => (val == null || val.length < 6) ? 'Mínimo 6 caracteres' : null,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Ingresar como ${store.currentUser.role.displayName}'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
