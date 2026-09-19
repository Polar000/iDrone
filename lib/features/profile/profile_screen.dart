import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/repositories/app_store.dart';
import '../../data/models/idrone_models.dart';
import '../../components/app_card.dart';
import '../../app/theme/app_colors.dart';

class ProfileScreen extends StatelessWidget {
  final VoidCallback onLogout;

  const ProfileScreen({super.key, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final user = store.currentUser;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Header
            AppCard(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: AppColors.emerald,
                    child: Text(
                      user.name.substring(0, 1),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: isDark ? AppColors.darkTextPrimary : AppColors.darkText,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontSize: 14,
                            color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.deepForest.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            user.role.displayName,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: AppColors.emerald,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Role Switcher Card
            Text(
              'Cambiar Rol Activo (Demostración)',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: UserRole.values.map((role) {
                  final isSelected = user.role == role;
                  return RadioListTile<UserRole>(
                    title: Text(role.displayName),
                    value: role,
                    groupValue: user.role,
                    activeColor: AppColors.emerald,
                    onChanged: (val) {
                      if (val != null) {
                        store.switchUserRole(val);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Theme Preferences
            Text(
              'Preferencia de Tema',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.darkTextMuted : AppColors.mutedText,
              ),
            ),
            const SizedBox(height: 8),
            AppCard(
              child: Column(
                children: [
                  RadioListTile<ThemeMode>(
                    title: const Text('Tema Claro'),
                    value: ThemeMode.light,
                    groupValue: store.themeMode,
                    activeColor: AppColors.emerald,
                    onChanged: (val) => store.setThemeMode(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Tema Oscuro'),
                    value: ThemeMode.dark,
                    groupValue: store.themeMode,
                    activeColor: AppColors.emerald,
                    onChanged: (val) => store.setThemeMode(val!),
                  ),
                  RadioListTile<ThemeMode>(
                    title: const Text('Modo del Sistema'),
                    value: ThemeMode.system,
                    groupValue: store.themeMode,
                    activeColor: AppColors.emerald,
                    onChanged: (val) => store.setThemeMode(val!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.errorRed,
                  side: const BorderSide(color: AppColors.errorRed),
                ),
                onPressed: onLogout,
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Cerrar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
