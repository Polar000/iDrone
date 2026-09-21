import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'data/repositories/app_store.dart';
import 'data/models/idrone_models.dart';
import 'app/theme/app_theme.dart';
import 'components/app_bottom_navigation.dart';
import 'features/auth/auth_screens.dart';
import 'features/home/home_screen.dart';
import 'features/parcels/mis_parcelas_screen.dart';
import 'features/services/service_catalog_screen.dart';
import 'features/profile/profile_screen.dart';
import 'features/operator/operator_screens.dart';
import 'features/admin/admin_screens.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppStore(),
      child: const IDroneApp(),
    ),
  );
}

class IDroneApp extends StatelessWidget {
  const IDroneApp({super.key});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    return MaterialApp(
      title: 'iDrone Platform',
      debugShowCheckedModeBanner: false,
      themeMode: store.themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const MainShellRouter(),
    );
  }
}

class MainShellRouter extends StatefulWidget {
  const MainShellRouter({super.key});

  @override
  State<MainShellRouter> createState() => _MainShellRouterState();
}

class _MainShellRouterState extends State<MainShellRouter> {
  bool _showSplash = true;
  bool _isAuthenticated = true;
  int _currentTab = 0;

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);

    if (_showSplash) {
      return SplashScreen(
        onSplashComplete: () => setState(() => _showSplash = false),
      );
    }

    if (!_isAuthenticated) {
      return LoginScreen(
        onLoginSuccess: () => setState(() => _isAuthenticated = true),
      );
    }

    // Role-based Root Shell
    switch (store.currentUser.role) {
      case UserRole.operador:
        return const OperatorDashboardScreen();
      case UserRole.adminOperaciones:
      case UserRole.superAdmin:
        return const AdminDashboardLayout();
      case UserRole.cliente:
      default:
        return Scaffold(
          body: IndexedStack(
            index: _currentTab,
            children: [
              HomeScreen(
                onRequestServiceTap: () => setState(() => _currentTab = 2),
                onViewParcelsTap: () => setState(() => _currentTab = 1),
              ),
              const MisParcelasScreen(),
              const ServiceCatalogScreen(),
              ProfileScreen(
                onLogout: () => setState(() => _isAuthenticated = false),
              ),
            ],
          ),
          bottomNavigationBar: AppBottomNavigation(
            currentIndex: _currentTab,
            onTap: (index) => setState(() => _currentTab = index),
            onAddTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const BookingWizardScreen()),
              );
            },
          ),
        );
    }
  }
}
