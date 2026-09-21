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
      backgroundColor: const Color(0xFF042B24),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const IDroneLogoWidget(
              size: 130,
              showBackground: true,
              backgroundColor: Color(0xFF061A12),
              greenColor: Color(0xFF00D819),
            ),
            const SizedBox(height: 32),
            const Text(
              'iDRONE',
              style: TextStyle(
                color: Colors.white,
                fontSize: 34,
                fontWeight: FontWeight.bold,
                letterSpacing: 3,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'AGRICULTURA DE PRECISIÓN',
              style: TextStyle(
                color: Color(0xFFC8F45A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 60),
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: Color(0xFFC8F45A),
                strokeWidth: 2.5,
              ),
            ),
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
  int _authTabIndex = 0; // 0 = Login, 1 = Register

  // Login Form Controllers
  final _loginEmailCtrl = TextEditingController(text: 'cliente@idrone.com');
  final _loginPassCtrl = TextEditingController(text: '123456');
  final _loginFormKey = GlobalKey<FormState>();

  // Register Form Controllers
  final _regNameCtrl = TextEditingController();
  final _regEmailCtrl = TextEditingController();
  final _regPhoneCtrl = TextEditingController();
  final _regPassCtrl = TextEditingController();
  final _regFormKey = GlobalKey<FormState>();

  String _regCountry = 'Guatemala';
  bool _acceptedTerms = true;
  bool _isLoading = false;

  void _submitAuth() async {
    final formKey = _authTabIndex == 0 ? _loginFormKey : _regFormKey;
    if (formKey.currentState?.validate() ?? false) {
      if (_authTabIndex == 1 && !_acceptedTerms) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Debes aceptar los Términos y Condiciones para registrarte')),
        );
        return;
      }

      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 900));

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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                children: const [
                  IDroneLogoWidget(size: 48, showBackground: true),
                  SizedBox(width: 12),
                  Text(
                    'iDRONE',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2),
                  )
                ],
              ),
              const SizedBox(height: 32),

              // Modern Tab Switcher (Ingresar / Registrarse)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFE5E7EB),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _authTabIndex = 0),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _authTabIndex == 0
                                ? (isDark ? AppColors.emerald : AppColors.deepForest)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Iniciar Sesión',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _authTabIndex == 0
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _authTabIndex = 1),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: _authTabIndex == 1
                                ? (isDark ? AppColors.emerald : AppColors.deepForest)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            'Crear Cuenta',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: _authTabIndex == 1
                                  ? Colors.white
                                  : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Role Selector Bar
              Text(
                'Selecciona Rol de Acceso:',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isDark ? AppColors.darkTextMuted : AppColors.mutedText),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : const Color(0xFFF3F4F6),
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
                          margin: const EdgeInsets.only(right: 4),
                          decoration: BoxDecoration(
                            color: isSelected ? AppColors.emerald : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            role.displayName,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.white : (isDark ? AppColors.darkTextMuted : AppColors.mutedText),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // Form View: Login vs Register
              if (_authTabIndex == 0)
                Form(
                  key: _loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bienvenido de nuevo',
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 26),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Ingresa credenciales para acceder como ${store.currentUser.role.displayName}.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _loginEmailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) => (val == null || !val.contains('@')) ? 'Correo inválido' : null,
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _loginPassCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (val) => (val == null || val.length < 6) ? 'Mínimo 6 caracteres' : null,
                      ),
                    ],
                  ),
                )
              else
                Form(
                  key: _regFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Registro de Productor Agrícola',
                        style: theme.textTheme.displayLarge?.copyWith(fontSize: 24),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Crea tu cuenta para mapear parcelas y contratar drones.',
                        style: theme.textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _regNameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Nombre Completo / Finca',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        validator: (val) => (val == null || val.isEmpty) ? 'Ingresa tu nombre' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _regEmailCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Correo Electrónico',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        validator: (val) => (val == null || !val.contains('@')) ? 'Correo inválido' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _regPhoneCtrl,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: 'Teléfono de Contacto (+502 / +52)',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        validator: (val) => (val == null || val.length < 8) ? 'Teléfono inválido' : null,
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _regCountry,
                        decoration: const InputDecoration(
                          labelText: 'País de Residencia',
                          prefixIcon: Icon(Icons.public_outlined),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Guatemala', child: Text('Guatemala (Quetzales - Mz)')),
                          DropdownMenuItem(value: 'México', child: Text('México (Pesos - Ha)')),
                          DropdownMenuItem(value: 'Colombia', child: Text('Colombia (Pesos - Ha)')),
                          DropdownMenuItem(value: 'Argentina', child: Text('Argentina (Pesos - Ha)')),
                        ],
                        onChanged: (val) {
                          if (val != null) setState(() => _regCountry = val);
                        },
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _regPassCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Crear Contraseña',
                          prefixIcon: Icon(Icons.lock_outline),
                        ),
                        validator: (val) => (val == null || val.length < 6) ? 'Mínimo 6 caracteres' : null,
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        activeColor: AppColors.emerald,
                        title: const Text('Acepto los Términos de Servicio y Políticas de Privacidad iDrone', style: TextStyle(fontSize: 12)),
                        value: _acceptedTerms,
                        onChanged: (v) => setState(() => _acceptedTerms = v ?? false),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.deepForest,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _isLoading ? null : _submitAuth,
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          _authTabIndex == 0
                              ? 'Ingresar como ${store.currentUser.role.displayName}'
                              : 'Registrar Cuenta en $_regCountry',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
