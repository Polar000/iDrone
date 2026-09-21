import 'package:flutter/material.dart';
import '../utils/constants.dart';

class PerfilScreen extends StatelessWidget {
  final ThemeMode currentThemeMode;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback? onLogout;

  const PerfilScreen({
    Key? key,
    required this.currentThemeMode,
    required this.onThemeModeChanged,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Mi Perfil')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.forest,
                child: Icon(Icons.person_rounded, size: 48, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                'Propietario Agrícola',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.darkText,
                ),
              ),
              const Text('cliente@idrone.ag', style: TextStyle(color: AppColors.mutedText)),
              const SizedBox(height: 24),
              Container(
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(AppRadius.card),
                ),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.dark_mode_rounded, color: AppColors.emerald),
                      title: const Text('Modo Oscuro'),
                      trailing: Switch(
                        value: isDark,
                        activeColor: AppColors.limeAccent,
                        onChanged: (val) {
                          onThemeModeChanged(val ? ThemeMode.dark : ThemeMode.light);
                        },
                      ),
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.payment_rounded, color: AppColors.emerald),
                      title: const Text('Métodos de Pago'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () {},
                    ),
                    const Divider(height: 1),
                    ListTile(
                      leading: const Icon(Icons.help_outline_rounded, color: AppColors.emerald),
                      title: const Text('Ayuda y Soporte'),
                      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              ListTile(
                tileColor: isDark ? AppColors.darkSurface : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: const Text('Cerrar Sesión', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700)),
                onTap: onLogout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
