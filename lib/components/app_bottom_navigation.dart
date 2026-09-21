import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final VoidCallback onAddPressed;

  const AppBottomNavigation({
    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.onAddPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Inicio', isDark),
              _buildNavItem(1, Icons.map_rounded, 'Parcelas', isDark),
              const SizedBox(width: 48), // Space for central floating button
              _buildNavItem(2, Icons.miscellaneous_services_rounded, 'Servicios', isDark),
              _buildNavItem(3, Icons.person_rounded, 'Perfil', isDark),
            ],
          ),
          Positioned(
            top: -24,
            child: GestureDetector(
              onTap: onAddPressed,
              child: Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.emerald, AppColors.forest],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.emerald.withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = currentIndex == index;
    final activeColor = isDark ? AppColors.limeAccent : AppColors.deepForest;
    final inactiveColor = AppColors.mutedText;

    return InkWell(
      onTap: () => onTap(index),
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected ? activeColor : inactiveColor,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? activeColor : inactiveColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
