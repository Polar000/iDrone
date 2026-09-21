import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/app_store.dart';
import 'theme/app_theme.dart';
import 'components/app_bottom_navigation.dart';
import 'features/auth/auth_screens.dart';
import 'features/operator/operator_screens.dart';
import 'features/admin/admin_screens.dart';
import 'screens/home_screen.dart';
import 'screens/mis_parcelas_screen.dart';
import 'screens/nueva_parcela_screen.dart';
import 'screens/detalle_parcela_screen.dart';
import 'screens/solicitar_servicio_screen.dart';
import 'screens/cotizacion_screen.dart';
import 'screens/pago_screen.dart';
import 'screens/servicio_en_curso_screen.dart';
import 'screens/historial_screen.dart';
import 'screens/detalle_servicio_screen.dart';
import 'screens/clima_screen.dart';
import 'screens/notificaciones_screen.dart';
import 'screens/perfil_screen.dart';
import 'data/models/idrone_models.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStore(),
      child: const IDroneApp(),
    ),
  );
}

class IDroneApp extends StatefulWidget {
  const IDroneApp({Key? key}) : super(key: key);

  @override
  State<IDroneApp> createState() => _IDroneAppState();
}

class _IDroneAppState extends State<IDroneApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppStore>(
      builder: (context, store, child) {
        return MaterialApp(
          title: 'iDrone Agricultural Platform',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light(),
          darkTheme: AppTheme.dark(),
          themeMode: _themeMode,
          initialRoute: '/',
          routes: {
            '/': (ctx) => _buildRoleRoot(store),
            '/login': (ctx) => LoginScreen(
                  onLoginSuccess: () => Navigator.pushReplacementNamed(ctx, '/'),
                ),
            '/admin': (ctx) => const AdminDashboardLayout(),
            '/operator': (ctx) => const OperatorDashboardScreen(),
            '/nueva-parcela': (ctx) => const NuevaParcelaScreen(),
            '/solicitar-servicio': (ctx) => SolicitarServicioScreen(
                  onCompleteWizard: () => Navigator.pushNamed(ctx, '/cotizacion'),
                ),
            '/cotizacion': (ctx) => CotizacionScreen(
                  onProceedToPayment: () => Navigator.pushNamed(ctx, '/pago'),
                ),
            '/pago': (ctx) => PagoScreen(
                  onPaymentSuccess: () => Navigator.pushReplacementNamed(ctx, '/servicio-en-curso'),
                ),
            '/servicio-en-curso': (ctx) => const ServicioEnCursoScreen(),
            '/clima': (ctx) => const ClimaScreen(),
            '/notificaciones': (ctx) => const NotificacionesScreen(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/detalle-parcela') {
              final parcelId = settings.arguments as String? ?? 'parcel-1';
              return MaterialPageRoute(
                builder: (ctx) => DetalleParcelaScreen(
                  parcelId: parcelId,
                  onRequestService: () => Navigator.pushNamed(ctx, '/solicitar-servicio'),
                ),
              );
            } else if (settings.name == '/detalle-servicio') {
              final bookingId = settings.arguments as String? ?? 'booking-101';
              return MaterialPageRoute(
                builder: (ctx) => DetalleServicioScreen(bookingId: bookingId),
              );
            }
            return null;
          },
        );
      },
    );
  }

  Widget _buildRoleRoot(AppStore store) {
    final role = store.currentUser?.role;
    if (role == UserRole.operador) {
      return const OperatorDashboardScreen();
    } else if (role == UserRole.adminOperaciones || role == UserRole.superAdmin) {
      return const AdminDashboardLayout();
    }
    return MainNavigationWrapper(
      themeMode: _themeMode,
      onThemeModeChanged: _toggleThemeMode,
    );
  }
}

class MainNavigationWrapper extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;

  const MainNavigationWrapper({
    Key? key,
    required this.themeMode,
    required this.onThemeModeChanged,
  }) : super(key: key);

  @override
  State<MainNavigationWrapper> createState() => _MainNavigationWrapperState();
}

class _MainNavigationWrapperState extends State<MainNavigationWrapper> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      HomeScreen(
        onRequestService: () => Navigator.pushNamed(context, '/solicitar-servicio'),
        onNavigateTab: (index) => setState(() => _currentIndex = index),
      ),
      MisParcelasScreen(
        onNuevaParcela: () => Navigator.pushNamed(context, '/nueva-parcela'),
        onParcelTap: (id) => Navigator.pushNamed(context, '/detalle-parcela', arguments: id),
      ),
      HistorialScreen(
        onSelectBooking: (id) => Navigator.pushNamed(context, '/detalle-servicio', arguments: id),
      ),
      PerfilScreen(
        currentThemeMode: widget.themeMode,
        onThemeModeChanged: widget.onThemeModeChanged,
      ),
    ];

    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: screens[_currentIndex],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        onAddPressed: () => Navigator.pushNamed(context, '/solicitar-servicio'),
      ),
    );
  }
}
